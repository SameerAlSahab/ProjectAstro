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

#
# Usage: NUKE_BLOAT <KnoxGuard> <SamsungPass>
#
NUKE_BLOAT() {
    local targets=("$@")
	# We dont need more partitions as of now
    local partitions=("system" "product" "system_ext")

    [[ ${#targets[@]} -eq 0 ]] && \
        ERROR_EXIT "Usage: NUKE_BLOAT <PackageName1> <PackageName2> ..."

    local TARGETS_LC=()
    for t in "${targets[@]}"; do
        TARGETS_LC+=("${t,,}")
    done

    for part in "${partitions[@]}"; do
        local part_path
        part_path=$(GET_PARTITION_PATH "$part" 2>/dev/null) || continue
        [[ ! -d "$part_path" ]] && continue

        for subdir in app priv-app; do
            local base_dir="$part_path/$subdir"
            [[ ! -d "$base_dir" ]] && continue

            for folder in "$base_dir"/*; do
                [[ ! -d "$folder" ]] && continue

                local name
                name=$(basename "$folder")
                local name_lc="${name,,}"

                for target in "${TARGETS_LC[@]}"; do
                    [[ "$name_lc" != "$target" ]] && continue


                    if rm -rf "$folder" 2>/dev/null; then
                    _UPDATE_LOG \
                        "Removed ${name}..."
                    else
                        ERROR_EXIT "Failed to remove package: ${name}"
                    fi
                done
            done
        done
    done



    return 0
}



# Reference: https://source.android.com/docs/core/ota/apex
EXTRACT_FROM_APEX_PAYLOAD() {
    local APEX_FILE_NAME="$1"
    local TARGET_FILE="$2"
    local OUT="$3"

    local APEX_FILE="${WORKSPACE}/${APEX_FILE_NAME}"
    local OUT_DIR="${WORKSPACE}/${OUT}"
    local TMP_DIR="/tmp/apex_extract_$$"


    if [[ -f "$OUT_DIR" ]]; then
        LOG_INFO "Already extracted $OUT"
        return 0
    fi

    if [[ ! -f "$APEX_FILE" ]]; then
        ERROR_EXIT "APEX not found: $APEX_FILE"
    fi

    LOG_INFO "Extracting $TARGET_FILE from ${APEX_FILE##*/}..."


    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"


    if ! unzip -j "$APEX_FILE" "apex_payload.img" -d "$TMP_DIR" >/dev/null 2>&1; then
	    rm -rf "$TMP_DIR"
        ERROR_EXIT "Failed to extract apex_payload.img from $APEX_FILE"
    fi


    local lib_name
    lib_name=$(basename "$TARGET_FILE")
    local extracted=false


    if command -v 7z &>/dev/null; then
        if 7z e -y "$TMP_DIR/apex_payload.img" "$TARGET_FILE" -o"$TMP_DIR" >/dev/null 2>&1; then
            extracted=true
        fi
    fi


    if [[ "$extracted" == false ]] && command -v debugfs &>/dev/null; then
        if echo "dump $TARGET_FILE $TMP_DIR/$lib_name" | debugfs "$TMP_DIR/apex_payload.img" 2>/dev/null; then
            extracted=true
        fi
    fi


    if [[ "$extracted" == false ]] || [[ ! -f "$TMP_DIR/$lib_name" ]]; then
	    rm -rf "$TMP_DIR"
        ERROR_EXIT "Failed to extract $TARGET_FILE from apex_payload.img"
    fi


    mkdir -p "$(dirname "$OUT_DIR")"
    if mv "$TMP_DIR/$lib_name" "$OUT_DIR"; then
        LOG "Extracted to $OUT"
    else
	    rm -rf "$TMP_DIR"
        ERROR_EXIT "Failed to move extracted file to: $OUT"
    fi

    rm -rf "$TMP_DIR"
    return 0
}


# REMOVE_SELINUX_ENTRY <filename> <entry1> [entry2 ...]
REMOVE_SELINUX_ENTRY() {
    local filename="$1"
    shift

    [ -z "$filename" ] && ERROR_EXIT "Usage: REMOVE_SELINUX_ENTRY <filename>"

    local file=""
    local base


    if base="$(GET_PARTITION_PATH system_ext 2>/dev/null)"; then
        file="$(find "$base" -type f -name "$filename" 2>/dev/null | head -n1)"
    fi


    if [ -z "$file" ]; then
        ERROR_EXIT "SELinux file '$filename' not found in system_ext"
    fi

    local e
    for e in "$@"; do
        sed -i "/($e)/d" "$file"
        sed -i "/genfscon.*$e/d" "$file"
        sed -i "/$e/d" "$file"
    done
}
