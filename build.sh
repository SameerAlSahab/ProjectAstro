#!/usr/bin/env bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#


set -o pipefail
export BASH_WARN_ON_NULL=0


ASTROROM="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ASTROROM

ROM_VERSION="2.0.7"

BETA_ASSERT=0
BETA_OTA_URL=""
export BETA_ASSERT BETA_OTA_URL

DEBUG_BUILD=false

PREBUILTS=$ASTROROM/prebuilts


PROJECT_DIR="$ASTROROM/astro"
OBJECTIVES_DIR="$ASTROROM/objectives"
BLOBS_DIR="$ASTROROM/blobs"

available_devices=()

if [[ -d "$OBJECTIVES_DIR" ]]; then
    for d in "$OBJECTIVES_DIR"/*/; do
        [[ -d "$d" ]] || continue
        available_devices+=("$(basename "$d")")
    done
fi

WORKDIR="$ASTROROM/firmware/unpacked"
WORKSPACE="$ASTROROM/workspace"
DIROUT="$ASTROROM/out"


SOURCE_FW="${WORKDIR}/${MODEL}"
STOCK_FW="${WORKDIR}/${STOCK_MODEL}"
EXTRA_FW="${WORKDIR}/${EXTRA_MODEL}"


MARKER_FILE="$WORKSPACE/.build_markers"

PLATFORM=""
CODENAME=""

shopt -s globstar

for util in "$ASTROROM"/scripts/**/*.sh; do
    if [[ -f "$util" ]]; then
        source "$util"
    fi
done


EXEC_SCRIPT() {
    local script_file="$1"
    local marker="$2"

    export SCRPATH
    SCRPATH=$(cd "$(dirname "$script_file")" && pwd)

    local rel_path="${script_file#$ASTROROM/}"

    local current_hash cached_hash
    current_hash=$(md5sum "$script_file" 2>/dev/null | awk '{print $1}')
    [[ -z "$current_hash" ]] && ERROR_EXIT "Hash failed: $rel_path"

    cached_hash=$(grep -F "$script_file" "$marker" 2>/dev/null | awk '{print $2}')

	if [[ "$cached_hash" == "$current_hash" ]]; then
        LOG_INFO "Skipping already applied script: $rel_path"
        return 0
    fi

    LOG_BEGIN "Applying: $rel_path"

    if ! source "$script_file"; then
        local rc=$?
        ERROR_EXIT "Script failed in $rel_path (exit $rc)"
    fi

    unset SCRPATH

    mkdir -p "$(dirname "$marker")"
    sed -i "\|^$script_file |d" "$marker" 2>/dev/null || true
    echo "$script_file $current_hash" >> "$marker"
}


_BUILD_WORKFLOW() {

    rm -rf "$ASTROROM/out" && mkdir -p "$ASTROROM/out"

    CHECK_ALL_DEPENDENCIES
    chmod +x -R "$PREBUILTS"

    if [[ -z "$device" ]]; then
        [[ ! -d "$OBJECTIVES_DIR" ]] && \
            ERROR_EXIT "objective folder not found: $OBJECTIVES_DIR"

        local devices=()
        for d in "$OBJECTIVES_DIR"/*/; do
            [[ -d "$d" ]] || continue
            devices+=("$(basename "$d")")
        done

        [[ ${#devices[@]} -eq 0 ]] && \
            ERROR_EXIT "No objectives found in $OBJECTIVES_DIR"

        local choice=$(_CHOICE "Available objectives" "${devices[@]}")
        device="${devices[choice-1]}"
    fi

    OBJECTIVE="$OBJECTIVES_DIR/$device"
    export OBJECTIVE

    source "$OBJECTIVE/$device.sh" || ERROR_EXIT "Device config load failed"

# Github Ubuntu runners have 72GB storage only. So skip extra firmwares
if  IS_GITHUB_ACTIONS; then
    unset EXTRA_MODEL
	unset EXTRA_CSC
	unset EXTRA_IMEI
fi

    local meta_tag="LAST_OBJ"
    local last_device=""
    local script_count=0
    local marker_exists=false

    if [[ -f "$MARKER_FILE" ]]; then
        marker_exists=true
        last_device=$(awk "/^$meta_tag / {print \$2}" "$MARKER_FILE")
        script_count=$(awk "!/^$meta_tag / {c++} END {print c+0}" "$MARKER_FILE")
    fi


    if ! $marker_exists || [[ "$last_device" != "$device" ]] || [[ "$script_count" -eq 0 ]]; then
        LOG_INFO "Initializing device environment for $device"

        SETUP_DEVICE_ENV || ERROR_EXIT "Env setup failed"

        mkdir -p "$(dirname "$MARKER_FILE")"
        sed -i "/^$meta_tag /d" "$MARKER_FILE" 2>/dev/null || true
        echo "$meta_tag $device" >> "$MARKER_FILE"
    fi


local layers=()

if [[ -n "$PLATFORM" ]]; then
    PLATFORM_DIR="$ASTROROM/platform/$PLATFORM"
    layers+=("$PLATFORM_DIR")
fi

layers+=(
    "$PROJECT_DIR"
    "$OBJECTIVE"
)


    for layer in "${layers[@]}"; do
        [[ ! -d "$layer" ]] && continue

        # Execute scripts
        while IFS= read -r -d '' sh; do
            [[ "$sh" == *"$device.sh" ]] && continue
            EXEC_SCRIPT "$sh" "$MARKER_FILE"
        done < <(find "$layer" -type f -name "*.sh" \
            ! -path "*.apk/*" \
            ! -path "*.jar/*" \
            -print0 | sort -z)


        while IFS= read -r -d '' cfg; do
            name="$(basename "$cfg")"
            target="$CONFIG_DIR/$name"

            if [[ ! -f "$target" ]]; then
                cp "$cfg" "$target"
            else
                grep -Fvx -f "$target" "$cfg" >> "$target" || true
            fi
        done < <(
            find "$layer" -type f \( \
                -name "*_file_contexts" -o \
                -name "*_fs_config" \
            \) -print0
        )

        # Sync partitions
        while IFS= read -r -d '' img; do
            part=$(basename "$img" .img)
            if target=$(GET_PARTITION_PATH "$part" 2>/dev/null); then
                mkdir -p "$target"
                rsync -a --no-links "$img/" "$target/" \
                    || ERROR_EXIT "Adding files failed for $part"
            else
                LOG_WARN "Unknown partition. Ignoring.. $part"
            fi
        done < <(find "$layer" -type d -name "*.img" -print0)
    done


    _APKTOOL_PATCH || ERROR_EXIT "APK/JAR patching failed"
    REPACK_ROM "$FILESYSTEM" || ERROR_EXIT "Repack failed"

    rm -rf "$WORKSPACE"

    LOG_END "Build completed for $device"
}



show_usage() {
cat <<EOF

AstroROM Build Tool v${ROM_VERSION}
Copyright (c) 2025 Sameer Al Sahab

USAGE:
 sudo ./build.sh [options] [command] [device:-optional]
  or
 sudo bash build.sh [options] [command] [device-optional]

COMMANDS:
  -b, --build [device]      Build ROM for a specific device.
                            If [device] is not given, a selection menu will appear.
  -c, --clean [option]      Cleanup build artifacts.
  -h, --help                Show usage.
      --ota-url [link]      Build astrorom from a beta firmware source.

CLEAN OPTIONS:
  -f, --firmware            Remove downloaded firmware files.
  -w, --workspace           Remove the workspace directory.
  --workdir                 Remove the unpacked firmware directory.
  --all                     Perform a full cleanup (firmware + workspace + workdir).

OPTIONS:
  -d, --debug               Build a debug rom for testing.

AVAILABLE OBJECTIVES:
  ${available_devices[*]:-None found in $OBJECTIVES_DIR}


EXAMPLES:
  sudo ./build.sh build x1q
  sudo ./build.sh b
  sudo ./build.sh clean --workspace
  sudo ./build.sh clean --all


NOTE:
  Root privileges are required for build and clean operations.

EOF
}


cleanup_workspace() {
    local targets=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--firmware)  targets+=("$FW_DIR") ;;
            -w|--workspace) targets+=("$WORKSPACE") ;;
            --all)
                targets+=("$FW_DIR" "$WORKSPACE")
                ;;
            *)
                LOG_WARN "Unknown clean option: $1"
                ;;
        esac
        shift
    done

    [[ ${#targets[@]} -eq 0 ]] && {
        LOG_WARN "Nothing to clean"
        return 0
    }

    for path in "${targets[@]}"; do
        [[ -d "$path" ]] || continue
        LOG_INFO "Removing ${path#$ASTROROM/}"
        rm -rf "$path" || ERROR_EXIT "Failed to remove $path"
    done

    rm -f "$MARKER_FILE" 2>/dev/null || true
    LOG "Cleanup completed"
}



device=""


while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug|-d)
            DEBUG_BUILD=true
            shift
            ;;
		--build|-b)
			if [[ -n "$2" && "$2" != -* ]]; then
				device="$2"
				shift 2
			else
				shift 1
		    fi
            ;;
        --clean|-c)

            cleanup_workspace "${@:2}"
            exit 0
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        --ota-url)
            [[ -z "$2" || "$2" == -* ]] && ERROR_EXIT "--ota-url requires a direct link"
            BETA_ASSERT=1
            BETA_OTA_URL="$2"
            export BETA_ASSERT BETA_OTA_URL
            shift 2
            ;;

        *)

            if [[ -z "$device" ]]; then
                device="$1"
            fi
            shift
            ;;
    esac
done



[[ $EUID -ne 0 ]] && ERROR_EXIT "Root required"


_BUILD_WORKFLOW

LOG_END "Completed everything" "Build finished for $device"


