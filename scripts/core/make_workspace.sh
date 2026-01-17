#!/bin/bash
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




INIT_BUILD_ENV() {
    SOURCE_FW="${WORKDIR}/${MODEL}"
    STOCK_FW="${WORKDIR}/${STOCK_MODEL}"
    EXTRA_FW="${WORKDIR}/${EXTRA_MODEL}"


    SUDO EXTRACT_ROM || ERROR_EXIT "Firmware extraction failed."

    LOG_BEGIN "Creating final workspace"
    CREATE_WORKSPACE
}


CREATE_WORKSPACE() {
    local BUILD_DIRECTORY="$ASTROROM/workspace"
    local CONFIG_DIRECTORY="$BUILD_DIRECTORY/config"
    local marker="$BUILD_DIRECTORY/.workspace"


    local BUILD_DATE=$(GET_PROP "system" "ro.build.date" "main" 2>/dev/null || echo "unknown")
    local BUILD_UTC=$(GET_PROP "system" "ro.build.date.utc" "main" 2>/dev/null || echo "0")
    local BUILD_VERSION=$(GET_PROP "system" "ro.build.version.release" "main" 2>/dev/null || echo "unknown")


    if [[ -f "$marker" ]]; then
        local old_port=$(grep "^PORT_MODEL=" "$marker" | cut -d= -f2)
        local old_date=$(grep "^BUILD_DATE=" "$marker" | cut -d= -f2)
        if [[ "$old_port" == "$MODEL" && "$old_date" == "$BUILD_DATE" ]]; then
            LOG_INFO "Workspace is already set. Skipping rebuild."
            WORKSPACE="$BUILD_DIRECTORY"
            CONFIG_DIR="$CONFIG_DIRECTORY"
            return 0
        fi
    fi

    rm -rf "$BUILD_DIRECTORY" && mkdir -p "$CONFIG_DIRECTORY"


    local oem_parts=("vendor" "odm" "vendor_dlkm" "odm_dlkm" "system_dlkm")
    local port_parts=("system" "product" "system_ext")


    if [[ "$MODEL" == "$STOCK_MODEL" || -z "$STOCK_MODEL" ]]; then
        LINK_PARTITIONS "$SOURCE_FW" "$BUILD_DIRECTORY" "$CONFIG_DIRECTORY" "${port_parts[@]}" "${oem_parts[@]}"
    else
        LINK_PARTITIONS "$SOURCE_FW" "$BUILD_DIRECTORY" "$CONFIG_DIRECTORY" "${port_parts[@]}"
        LINK_PARTITIONS "$STOCK_FW" "$BUILD_DIRECTORY" "$CONFIG_DIRECTORY" "${oem_parts[@]}"
    fi


    chown -R -h "$SUDO_USER:$SUDO_USER" "$BUILD_DIRECTORY" 2>/dev/null


    cat > "$marker" <<EOF
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
PORT_MODEL=$MODEL
STOCK_MODEL=${STOCK_MODEL}
EXTRA_MODEL=${EXTRA_MODEL:-None}
ANDROID_VERSION=$BUILD_VERSION
BUILD_DATE=$BUILD_DATE
BUILD_DATE_UTC=$BUILD_UTC
EOF

    WORKSPACE="$BUILD_DIRECTORY"
    CONFIG_DIR="$CONFIG_DIRECTORY"

    LOG_INFO "Checking VNDK version..."

    [[ -z "$VNDK" ]] && { ERROR_EXIT "VNDK version not defined."; return 1; }
    local SYSTEM_EXT_PATH
    SYSTEM_EXT_PATH=$(GET_PARTITION_PATH "system_ext") || return 1

 
    local VINTF_MANIFEST="${SYSTEM_EXT_PATH}/etc/vintf/VINTF_MANIFEST.xml"

    local CURRENT_VNDK=""


    if [[ -f "$VINTF_MANIFEST" ]]; then
        CURRENT_VNDK=$(grep -A2 -i "vendor-ndk" "$VINTF_MANIFEST" | grep -oP '<version>\K[0-9]+' | head -1)
        [[ "$CURRENT_VNDK" == "$VNDK" ]] && { LOG_END "VNDK matches ($VNDK)."; return 0; }
    fi

    LOG_WARN "VNDK mismatch (Current: ${CURRENT_VNDK:-None} and Target: $VNDK). Patching..."

    local APEX_PREFIX="com.android.vndk.v${VNDK}.apex"
    local SOURCE_FILE="${BLOBS_DIR}/vndk/v${VNDK}/${APEX_PREFIX}"
    local TARGET_APEX_PATH="apex/${APEX_PREFIX}"


    find "${SYSTEM_EXT_PATH}/apex" -name "com.android.vndk.v*.apex" -delete 2>/dev/null


    if ! ADD "system_ext" "$SOURCE_FILE" "$TARGET_APEX_PATH" "VNDK v${VNDK} APEX"; then
        ERROR_EXIT "Failed to install VNDK APEX."
        return 1
    fi

    # Update Manifest
    if [[ -f "$VINTF_MANIFEST" ]]; then
        if grep -q "<vendor-ndk>" "$VINTF_MANIFEST"; then
            sed -i "s|<version>[0-9]\+</version>|<version>${VNDK}</version>|g" "$VINTF_MANIFEST"
        else
            sed -i "s|</VINTF_MANIFEST>|    <vendor-ndk>\\n        <version>${VNDK}</version>\\n    </vendor-ndk>\\n</VINTF_MANIFEST>|" "$VINTF_MANIFEST"
        fi
        LOG_INFO "Manifest updated."
    fi

    LOG_END "VNDK patching completed."

    local STOCK_EXT_PATH CURRENT_EXT_PATH
    local STOCK_LAYOUT="merged" CURRENT_LAYOUT="merged"

   
    if STOCK_EXT_PATH=$(GET_PARTITION_PATH "system_ext" "stock" 2>/dev/null); then
        [[ "$STOCK_EXT_PATH" == *"/system_ext" ]] && [[ "$STOCK_EXT_PATH" != *"/system/system/system_ext" ]] && STOCK_LAYOUT="separate"
    fi

    
    if CURRENT_EXT_PATH=$(GET_PARTITION_PATH "system_ext" 2>/dev/null); then
        [[ "$CURRENT_EXT_PATH" == *"/system_ext" ]] && [[ "$CURRENT_EXT_PATH" != *"/system/system/system_ext" ]] && CURRENT_LAYOUT="separate"
    else
        return 0
    fi

    [[ "$CURRENT_LAYOUT" == "$STOCK_LAYOUT" ]] && return 0

   
    local sys_config="${CONFIG_DIR}/system_fs_config"
    local sys_contexts="${CONFIG_DIR}/system_file_contexts"
    
    if [[ "$STOCK_LAYOUT" == "merged" ]]; then
      
        LOG_INFO "Merging system_ext into system..."
        local dest_dir="$WORKSPACE/system/system/system_ext"
        
        mkdir -p "$dest_dir"
        rsync -a --delete "${CURRENT_EXT_PATH}/" "${dest_dir}/" || return 1
        rm -rf "$CURRENT_EXT_PATH"
        
        
        ln -sf "/system/system_ext" "$WORKSPACE/system/system_ext"
        echo "system/system_ext 0 0 755 capabilities=0x0" >> "$sys_config"
        echo "/system_ext u:object_r:system_file:s0" >> "$sys_contexts"

    else
        
        LOG_INFO "Separating system_ext from system..."
        local dest_dir="$WORKSPACE/system_ext"
        
        mkdir -p "$dest_dir"
        rsync -a --delete "${CURRENT_EXT_PATH}/" "${dest_dir}/" || return 1
        rm -rf "$CURRENT_EXT_PATH"
        [[ -L "$WORKSPACE/system/system_ext" ]] && rm -f "$WORKSPACE/system/system_ext"

     
        echo "system_ext" > "${CONFIG_DIR}/system_ext_fs_config"
        sed -i '/^system\/system_ext/d' "$sys_config"
        sed -i '/^\/system\/system_ext/d' "$sys_contexts"
    fi

  
    local target="$WORKSPACE/${STOCK_LAYOUT:0:6}_ext"
    [[ "$STOCK_LAYOUT" == "merged" ]] && target="$WORKSPACE/system/system/system_ext"
    [[ "$STOCK_LAYOUT" == "separate" ]] && target="$WORKSPACE/system_ext"


    LOG_END "Build environment ready at $BUILD_DIRECTORY"
}


LINK_PARTITIONS() {
    local SOURCE_DIR="$1"
    local BUILD_DIRECTORY="$2"
    local CONFIG_DIRECTORY="$3"
    shift 3
    local partitions=("$@")

    for part in "${partitions[@]}"; do
        local src_path="$SOURCE_DIR/$part"
        local target_path="$BUILD_DIRECTORY/$part"

        [[ ! -d "$src_path" ]] && continue


        cp -al "$src_path" "$BUILD_DIRECTORY/" || ERROR_EXIT "Cannot process $part in workspace."


        find "$target_path" -type f \( \
            -name "*.prop" -o -name "*.xml" -o -name "*.conf" -o \
            -name "*.sh" -o -name "*.json" -o -name "*.rc" -o -size -1M \
        \) -exec sh -c 'cp --preserve=mode,timestamps "$1" "$1.tmp" && mv "$1.tmp" "$1"' _ {} \; 2>/dev/null

        chmod -R u+w "$target_path" 2>/dev/null


        for cfg_type in "fs_config" "file_contexts"; do
            local cfg_file="$SOURCE_DIR/config/${part}_${cfg_type}"
            [[ -f "$cfg_file" ]] && cp -a "$cfg_file" "$CONFIG_DIRECTORY/"
        done
    done
}


GET_PARTITION_PATH() {
    local partition_name="$1"
    local firmware_type="${2:-}"
    local base_dir


    if [[ -n "$firmware_type" ]]; then
        base_dir=$(GET_FW_DIR "$firmware_type")
        if [[ -z "$base_dir" ]]; then
            ERROR_EXIT "Unknown firmware type '$firmware_type'" >&2
        fi
    else

        base_dir="${WORKSPACE}"
    fi


    local target_dir
    case "$partition_name" in
        system)

            if [[ -d "${base_dir}/system/system" ]]; then
                target_dir="${base_dir}/system/system"
            else
                target_dir="${base_dir}/system"
            fi
            ;;
        system_ext)
            local system_ext_path
            system_ext_path=$(FIND_SYSTEM_EXT "$base_dir" 2>/dev/null)
            if [[ -n "$system_ext_path" ]]; then
                target_dir="$system_ext_path"
            else
                LOG_WARN "Could not get system_ext in $base_dir" >&2
                return 1
            fi
            ;;
        *)
            target_dir="${base_dir}/${partition_name}"
            ;;
    esac


    if [[ ! -d "$target_dir" ]]; then
        LOG_WARN "Partition directory '$partition_name' not found in $base_dir" >&2
        return 1
    fi

    echo "$target_dir"
    return 0
}



FIND_SYSTEM_EXT() {
    local workspace="$1"

    if [[ -d "$workspace/system_ext" ]]; then
        echo "$workspace/system_ext"
        return 0
    elif [[ -d "$workspace/system/system/system_ext" ]]; then
        echo "$workspace/system/system/system_ext"
        return 0
    elif [[ -d "$workspace/system_a/system/system/system_ext" ]]; then
        echo "$workspace/system_a/system/system/system_ext"
        return 0
    fi

    return 1
}


GET_FW_DIR() {
    local source_firmware="$1"
    
    case "$source_firmware" in
        "main")  echo "$WORKDIR/$MODEL" ;;
        "extra") echo "$WORKDIR/$EXTRA_MODEL" ;;
        "stock") echo "$WORKDIR/$STOCK_MODEL" ;;
        *)
        
            local blob_source="$BLOBS_DIR/$source_firmware"
            if [[ -d "$blob_source" ]]; then
                echo "$blob_source"
            else
                return 1
            fi
            ;;
    esac
    return 0
}


VALIDATE_WORKDIR() {
    local source_firmware="$1"
    local workdir

    workdir=$(GET_FW_DIR "$source_firmware" 2>/dev/null) || {
        return 1
    }

    if [[ ! -d "$workdir" ]]; then
        LOG_WARN "Work directory does not exist for '$source_firmware': $workdir"
        return 1
    fi

    if [[ -z "$(ls -A "$workdir" 2>/dev/null)" ]]; then
        LOG_WARN "Work directory is empty for '$source_firmware': $workdir"
        return 1
    fi

    return 0
}

