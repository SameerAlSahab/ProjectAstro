#!/bin/bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#

# [
INIT_BUILD_ENV()
{
    SOURCE_FW="${WORKDIR}/${MODEL}"
    STOCK_FW="${WORKDIR}/${STOCK_MODEL}"
    EXTRA_FW="${WORKDIR}/${EXTRA_MODEL}"

    setfacl -R -m u:"${SUDO_USER:-$(whoami)}":rwx "$ARCADEROM"

    setfacl -R -d -m u:"${SUDO_USER:-$(whoami)}":rwx "$ARCADEROM"

    EXTRACT_ROM || ERROR_EXIT "Firmware extraction failed."

    LOG_BEGIN "Creating final workspace"
    CREATE_WORKSPACE
}

CREATE_WORKSPACE()
{
    local WORKSPACE="$ARCADEROM/workspace"
    local CONFIG_DIR="$WORKSPACE/config"
    local WORKSPACE_MARKER="$WORKSPACE/.workspace"

    local BUILD_DATE BUILD_UTC BUILD_VERSION
    BUILD_DATE=$(GET_PROP "system" "ro.build.date" "main" 2>/dev/null || echo "unknown")
    BUILD_UTC=$(GET_PROP "system" "ro.build.date.utc" "main" 2>/dev/null || echo "0")
    BUILD_VERSION=$(GET_PROP "system" "ro.build.version.release" "main" 2>/dev/null || echo "unknown")

    if [[ -f "$WORKSPACE_MARKER" ]]; then
        local CACHED_PORT_MODEL CACHED_BUILD_DATE
        CACHED_PORT_MODEL=$(grep "^PORT_MODEL=" "$WORKSPACE_MARKER" | cut -d= -f2)
        CACHED_BUILD_DATE=$(grep "^BUILD_DATE=" "$WORKSPACE_MARKER" | cut -d= -f2)

        if [[ "$CACHED_PORT_MODEL" == "$MODEL" && "$CACHED_BUILD_DATE" == "$BUILD_DATE" ]]; then
            LOG_INFO "Workspace is already set. Skipping rebuild."
            WORKSPACE="$WORKSPACE"
            CONFIG_DIR="$CONFIG_DIR"
            return 0
        fi
    fi

    rm -rf "$WORKSPACE" || return 1
    mkdir -p "$CONFIG_DIR" || return 1

    local OEM_PARTITIONS=("vendor" "odm" "vendor_dlkm" "odm_dlkm" "system_dlkm")
    local PORT_PARTITIONS=("system" "product" "system_ext")
    local CSC_PARTITIONS=("optics" "prism")

    if [[ "$MODEL" == "$STOCK_MODEL" || -z "$STOCK_MODEL" ]]; then
        LINK_PARTITIONS "$SOURCE_FW" "$WORKSPACE" "$CONFIG_DIR" \
            "${PORT_PARTITIONS[@]}" "${OEM_PARTITIONS[@]}"
    else
        LINK_PARTITIONS "$SOURCE_FW" "$WORKSPACE" "$CONFIG_DIR" \
            "${PORT_PARTITIONS[@]}"
        LINK_PARTITIONS "$STOCK_FW" "$WORKSPACE" "$CONFIG_DIR" \
            "${OEM_PARTITIONS[@]}"
    fi

    LINK_PARTITIONS "$SOURCE_FW" "$WORKSPACE" "$CONFIG_DIR" \
        "${CSC_PARTITIONS[@]}"

    chown -R "$SUDO_USER:$SUDO_USER" "$WORKSPACE" 2>/dev/null

    cat > "$WORKSPACE_MARKER" <<EOF
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
PORT_MODEL=$MODEL
STOCK_MODEL=$STOCK_MODEL
EXTRA_MODEL=${EXTRA_MODEL:-None}
ANDROID_VERSION=$BUILD_VERSION
BUILD_DATE=$BUILD_DATE
BUILD_DATE_UTC=$BUILD_UTC
EOF

    DEVICE_HAVE_DONOR_SOURCE=${DEVICE_HAVE_DONOR_SOURCE:-false}
        if ! GET_FEATURE DEVICE_HAVE_DONOR_SOURCE; then
            GENERATE_CONFIG
        fi

    LOG_INFO "Checking VNDK version..."

    [[ -z "$DEVICE_VNDK_VERSION" ]] && ERROR_EXIT "VNDK version not defined."

    local SYSTEM_EXT_PATH
    SYSTEM_EXT_PATH=$(GET_PARTITION_PATH "system_ext") || return 1

    local VINTF_MANIFEST_PATH="$SYSTEM_EXT_PATH/etc/vintf/manifest.xml"
    local CURRENT_VNDK_VERSION=""
    local VNDK_PATCH_REQUIRED=false

    if [[ -f "$VINTF_MANIFEST_PATH" ]]; then
        CURRENT_VNDK_VERSION=$(grep -A2 -i "<vendor-ndk>" "$VINTF_MANIFEST_PATH" \
            | grep -oP '<version>\K[0-9]+' | head -1)
    fi

    if [[ "$CURRENT_VNDK_VERSION" != "$DEVICE_VNDK_VERSION" ]]; then
        VNDK_PATCH_REQUIRED=true
    else
        LOG_INFO "VNDK matches ($CURRENT_VNDK_VERSION). Skipping VNDK patch."
    fi

    if $VNDK_PATCH_REQUIRED; then
        LOG_WARN "VNDK mismatch or missing (Current: ${CURRENT_VNDK_VERSION:-None}, Target: $DEVICE_VNDK_VERSION). Patching..."

        local VNDK_APEX_NAME="com.android.vndk.v${DEVICE_VNDK_VERSION}.apex"
        local VNDK_SOURCE_PATH="$BLOBS_DIR/vndk/v${DEVICE_VNDK_VERSION}/${VNDK_APEX_NAME}"
        local VNDK_TARGET_PATH="apex/${VNDK_APEX_NAME}"

        find "$SYSTEM_EXT_PATH/apex" -name "com.android.vndk.v*.apex" -delete 2>/dev/null

        ADD "system_ext" "$VNDK_SOURCE_PATH" "$VNDK_TARGET_PATH" "VNDK v${DEVICE_VNDK_VERSION} APEX" \
            || ERROR_EXIT "Failed to set correct vndk version"

        if [[ ! -f "$VINTF_MANIFEST_PATH" ]]; then
            LOG_WARN "Manifest file not found at $VINTF_MANIFEST_PATH. Cannot patch XML."
        else
            if [[ -z "$CURRENT_VNDK_VERSION" ]]; then
                LOG_INFO "Manifest missing <vendor-ndk> tag. Adding it..."

                sed -i "/<\/manifest>/i \\
    <vendor-ndk>\\
        <version>$DEVICE_VNDK_VERSION</version>\\
    </vendor-ndk>" "$VINTF_MANIFEST_PATH"

            else
                LOG_INFO "Updating existing manifest version from $CURRENT_VNDK_VERSION to $DEVICE_VNDK_VERSION..."

                sed -i "s|<version>$CURRENT_VNDK_VERSION</version>|<version>$DEVICE_VNDK_VERSION</version>|g" "$VINTF_MANIFEST_PATH"
            fi
        fi

        LOG_END "VNDK patching completed."
    fi

    local STOCK_SYSTEM_EXT_PATH CURRENT_SYSTEM_EXT_PATH
    local STOCK_PARTITION_LAYOUT="merged"
    local CURRENT_PARTITION_LAYOUT="merged"

    if STOCK_SYSTEM_EXT_PATH=$(GET_PARTITION_PATH "system_ext" "stock" 2>/dev/null); then
        [[ "$STOCK_SYSTEM_EXT_PATH" == */system_ext && "$STOCK_SYSTEM_EXT_PATH" != */system/system/system_ext ]] \
            && STOCK_PARTITION_LAYOUT="separate"
    fi

    if CURRENT_SYSTEM_EXT_PATH=$(GET_PARTITION_PATH "system_ext" 2>/dev/null); then
        [[ "$CURRENT_SYSTEM_EXT_PATH" == */system_ext && "$CURRENT_SYSTEM_EXT_PATH" != */system/system/system_ext ]] \
            && CURRENT_PARTITION_LAYOUT="separate"
    else
        return 0
    fi

    local SYSTEM_EXT_FS_CONFIG_PATH="$CONFIG_DIR/system_fs_config"
    local SYSTEM_EXT_FILE_CONTEXTS_PATH="$CONFIG_DIR/system_file_contexts"

    if [[ "$CURRENT_PARTITION_LAYOUT" == "$STOCK_PARTITION_LAYOUT" ]]; then
        LOG_INFO "System_ext layout matches target ($CURRENT_PARTITION_LAYOUT). Skipping layout patches."
    else
        if [[ "$STOCK_PARTITION_LAYOUT" == "merged" ]]; then
            LOG_INFO "Merging system_ext into system..."

            if [[ ! -d "$WORKSPACE/system/system/system_ext" ]]; then
                rm -rf "$WORKSPACE/system/system_ext"
                rm -f  "$WORKSPACE/system/system/system_ext"

                sed -i "/system_ext/d" "$SYSTEM_EXT_FILE_CONTEXTS_PATH"
                sed -i "/system_ext/d" "$SYSTEM_EXT_FS_CONFIG_PATH"

                cp -a --preserve=all "$WORKSPACE/system_ext" "$WORKSPACE/system/system"
                ln -sf "/system/system_ext" "$WORKSPACE/system/system_ext"

                echo "/system_ext u:object_r:system_file:s0" >> "$SYSTEM_EXT_FILE_CONTEXTS_PATH"
                echo "system_ext 0 0 644 capabilities=0x0" >> "$SYSTEM_EXT_FS_CONFIG_PATH"

                sed "s|^/system_ext|/system/system_ext|g" \
                    "$CONFIG_DIR/system_ext_file_contexts" >> "$SYSTEM_EXT_FILE_CONTEXTS_PATH"

                sed "1d; s|^system_ext|system/system_ext|g" \
                    "$CONFIG_DIR/system_ext_fs_config" >> "$SYSTEM_EXT_FS_CONFIG_PATH"

                rm -rf "$WORKSPACE/system_ext"
            fi
        else
            LOG_INFO "Separating system_ext from system..."

            local SEPARATED_FS_CONFIG_PATH="$CONFIG_DIR/system_ext_fs_config"
            local SEPARATED_FILE_CONTEXTS_PATH="$CONFIG_DIR/system_ext_file_contexts"

            rm -f  "$WORKSPACE/system/system_ext"
            rm -rf "$WORKSPACE/system_ext"

            mkdir -p "$WORKSPACE/system_ext"
            mkdir -p "$WORKSPACE/system/system_ext"

            cp -a --preserve=all \
                "$WORKSPACE/system/system/system_ext/." \
                "$WORKSPACE/system_ext/"

            rm -rf "$WORKSPACE/system/system/system_ext"
            ln -sf "/system_ext" "$WORKSPACE/system/system/system_ext"

            : > "$SEPARATED_FS_CONFIG_PATH"
            : > "$SEPARATED_FILE_CONTEXTS_PATH"

            grep "^/system/system_ext" "$CONFIG_DIR/system_file_contexts" \
                | sed "s|^/system/system_ext|/system_ext|" \
                >> "$SEPARATED_FILE_CONTEXTS_PATH"

            grep "^system/system_ext" "$CONFIG_DIR/system_fs_config" \
                | sed "s|^system/system_ext|system_ext|" \
                >> "$SEPARATED_FS_CONFIG_PATH"

            sed -i "/^\/system\/system_ext/d" "$CONFIG_DIR/system_file_contexts"
            sed -i "/^system\/system_ext/d" "$CONFIG_DIR/system_fs_config"

            LOG_INFO "system_ext successfully separated from system."
        fi
    fi

    [ -f "$WORKSPACE/product/overlay/product_overlay.apk" ] || \
    (mv "$WORKSPACE/product/overlay"/framework-res*.apk "$WORKSPACE/product/overlay/product_overlay.apk" || ERROR_EXIT "Cannot process rro product overlay.")

# Camera blobs
    REMOVE "system" "cameradata/portrait_data"
    REMOVE "system" "cameradata/singletake"

LOG_INFO "Adding stock camera properties.."
    ADD_FROM_FW "stock" "system" "cameradata/portrait_data"
    ADD_FROM_FW "stock" "system" "cameradata/singletake"

if ! find "$OBJECTIVE" -type f -name "camera-feature.xml" | grep -q .; then
    ADD_FROM_FW "stock" "system" "cameradata/camera-feature.xml"
fi

    LOG_END "Build environment ready at $WORKSPACE"
}


LINK_PARTITIONS()
{
    local SOURCE_FIRMWARE_DIR="$1"
    local TARGET_WORKSPACE_DIR="$2"
    local TARGET_CONFIG_DIR="$3"
    shift 3
    local PARTITION_LIST=("$@")

    for PARTITION_NAME in "${PARTITION_LIST[@]}"; do
        local PARTITION_SOURCE_PATH="$SOURCE_FIRMWARE_DIR/$PARTITION_NAME"
        local PARTITION_TARGET_PATH="$TARGET_WORKSPACE_DIR/$PARTITION_NAME"

        [[ ! -d "$PARTITION_SOURCE_PATH" ]] && continue

        cp -al "$PARTITION_SOURCE_PATH" "$TARGET_WORKSPACE_DIR/" || ERROR_EXIT "Cannot process $PARTITION_NAME in workspace."

        find "$PARTITION_TARGET_PATH" -type f \( \
            -name "*.prop" -o -name "*.xml" -o -name "*.conf" -o \
            -name "*.sh" -o -name "*.json" -o -name "*.rc" -o -size -1M \
        \) -exec sh -c 'cp --preserve=mode,timestamps "$1" "$1.tmp" && mv "$1.tmp" "$1"' _ {} \; 2>/dev/null

        for CONFIG_FILE_TYPE in "fs_config" "file_contexts"; do
            local CONFIG_SOURCE_PATH="$SOURCE_FIRMWARE_DIR/config/${PARTITION_NAME}_${CONFIG_FILE_TYPE}"
            [[ -f "$CONFIG_SOURCE_PATH" ]] && cp -a "$CONFIG_SOURCE_PATH" "$TARGET_CONFIG_DIR/"
        done
    done
}

GET_PARTITION_PATH()
{
    local PARTITION_NAME="$1"
    local FIRMWARE_TYPE="${2:-}"
    local FIRMWARE_BASE_DIR

    if [[ -n "$FIRMWARE_TYPE" ]]; then
        FIRMWARE_BASE_DIR=$(GET_FW_DIR "$FIRMWARE_TYPE")
        if [[ -z "$FIRMWARE_BASE_DIR" ]]; then
            ERROR_EXIT "Unknown firmware type '$FIRMWARE_TYPE'" >&2
        fi
    else
        FIRMWARE_BASE_DIR="${WORKSPACE}"
    fi

    local PARTITION_RESOLVED_PATH
    case "$PARTITION_NAME" in
        system)
            if [[ -d "${FIRMWARE_BASE_DIR}/system/system" ]]; then
                PARTITION_RESOLVED_PATH="${FIRMWARE_BASE_DIR}/system/system"
            else
                PARTITION_RESOLVED_PATH="${FIRMWARE_BASE_DIR}/system"
            fi
            ;;
        system_ext)
            local SYSTEM_EXT_RESOLVED_PATH
            SYSTEM_EXT_RESOLVED_PATH=$(FIND_SYSTEM_EXT "$FIRMWARE_BASE_DIR" 2>/dev/null)
            if [[ -n "$SYSTEM_EXT_RESOLVED_PATH" ]]; then
                PARTITION_RESOLVED_PATH="$SYSTEM_EXT_RESOLVED_PATH"
            else
                LOG_WARN "Could not get system_ext in $FIRMWARE_BASE_DIR" >&2
                return 1
            fi
            ;;
        *)
            PARTITION_RESOLVED_PATH="${FIRMWARE_BASE_DIR}/${PARTITION_NAME}"
            ;;
    esac

    if [[ ! -d "$PARTITION_RESOLVED_PATH" ]]; then
        LOG_WARN "Partition directory '$PARTITION_NAME' not found in $FIRMWARE_BASE_DIR" >&2
        return 1
    fi

    echo "$PARTITION_RESOLVED_PATH"
    return 0
}

FIND_SYSTEM_EXT()
{
    local SEARCH_WORKSPACE_DIR="$1"

    if [[ -d "$SEARCH_WORKSPACE_DIR/system_ext" ]]; then
        echo "$SEARCH_WORKSPACE_DIR/system_ext"
        return 0
    elif [[ -d "$SEARCH_WORKSPACE_DIR/system/system/system_ext" ]]; then
        echo "$SEARCH_WORKSPACE_DIR/system/system/system_ext"
        return 0
    elif [[ -d "$SEARCH_WORKSPACE_DIR/system_a/system/system/system_ext" ]]; then
        echo "$SEARCH_WORKSPACE_DIR/system_a/system/system/system_ext"
        return 0
    fi

    return 1
}

GET_FW_DIR()
{
    local FIRMWARE_SOURCE_TYPE="$1"

    case "$FIRMWARE_SOURCE_TYPE" in
        "main")  echo "$WORKDIR/$MODEL" ;;
        "extra") echo "$WORKDIR/$EXTRA_MODEL" ;;
        "stock") echo "$WORKDIR/$STOCK_MODEL" ;;
        *)
            local BLOB_SOURCE_PATH="$BLOBS_DIR/$FIRMWARE_SOURCE_TYPE"
            if [[ -d "$BLOB_SOURCE_PATH" ]]; then
                echo "$BLOB_SOURCE_PATH"
            else
                return 1
            fi
            ;;
    esac
    return 0
}

VALIDATE_WORKDIR()
{
    local FIRMWARE_SOURCE_TYPE="$1"
    local VALIDATED_WORKDIR

    VALIDATED_WORKDIR=$(GET_FW_DIR "$FIRMWARE_SOURCE_TYPE" 2>/dev/null) || {
        return 1
    }

    if [[ ! -d "$VALIDATED_WORKDIR" ]]; then
        LOG_WARN "Work directory does not exist for '$FIRMWARE_SOURCE_TYPE': $VALIDATED_WORKDIR"
        return 1
    fi

    if [[ -z "$(ls -A "$VALIDATED_WORKDIR" 2>/dev/null)" ]]; then
        LOG_WARN "Work directory is empty for '$FIRMWARE_SOURCE_TYPE': $VALIDATED_WORKDIR"
        return 1
    fi

    return 0
}
# ]
