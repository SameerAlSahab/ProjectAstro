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



EXTRACT_ROM() {
    mkdir -p "$WORKDIR"

    local targets=(
        "$MODEL:$CSC:main"
        "${STOCK_MODEL:-}:$STOCK_CSC:stock"
        "${EXTRA_MODEL:-}:$EXTRA_CSC:extra"
    )

    local processed=""

    for entry in "${targets[@]}"; do
        IFS=":" read -r m c type <<< "$entry"
        [[ -z "$m" || -z "$c" ]] && continue

        DOWNLOAD_FW "$type" || ERROR_EXIT "Firmware download failed"

        local fw_id="${m}_${c}"
        if [[ "$processed" =~ "$fw_id" ]]; then
            continue
        fi

        if [[ "$type" == "main" && "$BETA_ASSERT" == "1" ]]; then
            PATCH_BETA_FW "$m" "$c" || return 1
        else
            EXTRACT_FIRMWARE "$m" "$c" "$type" || return 1
        fi

        processed+="$fw_id "
    done

    return 0
}




EXTRACT_FIRMWARE() {
    local model=$1
    local csc=$2
    local fw_type=$3

    local ODIN_FOLDER="${FW_BASE}/${model}_${csc}"
    local CURRENT_MODEL="${WORKDIR}/${model}"
    UNPACK_CONF="${CURRENT_MODEL}/unpack.conf"


    local target_partitions=(system product system_ext odm vendor_dlkm odm_dlkm system_dlkm vendor)


    LOG_BEGIN "Checking $fw_type firmware.."

    mkdir -p "$CURRENT_MODEL"

    local ap_file
    ap_file=$(find "$ODIN_FOLDER" -maxdepth 1 \( -name "AP_*.tar.md5" -o -name "AP_*.tar" \) | head -1)
    [[ -z "$ap_file" ]] && { ERROR_EXIT "AP package missing for $model"; return 1; }

    # Check if we need to extract or not
    local current_data

	# Samsung saves the md5 at the last of the file , so it takes a lot of time in low end machines, instead i thought to use inode+mtime verify.
	# Remove # on _GET_MD5_HASH to verify with md5.

	#current_data=$(_GET_MD5_HASH "$ap_file")
	current_data=$(_GET_FILE_STAT "$ap_file")

    if [[ -f "$UNPACK_CONF" ]]; then
        local cached_data
        cached_data=$(source "$UNPACK_CONF" && echo "$METADATA")

        if [[ "$cached_data" == "$current_data" && -f "${CURRENT_MODEL}/.extraction_complete" ]]; then
            LOG_INFO "$model firmware already extracted."
            return 0
        fi
    fi


    LOG_INFO "Unpacking $model firmware.."


    rm -rf "${CURRENT_MODEL:?}"/*
    mkdir -p "$CURRENT_MODEL"

    local super_img="${CURRENT_MODEL}/super.img"

    FETCH_FILE "$ap_file" "super.img" "$CURRENT_MODEL" >/dev/null || {
        rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
        ERROR_EXIT "Failed to extract super.img from $ap_file"
        return 1
    }

    # Free space ASAP on GitHub Actions
        if IS_GITHUB_ACTIONS; then
            rm -f "$ap_file"
            rm -rf "$ODIN_FOLDER"
        fi


    [[ ! -f "$super_img" ]] && {
        rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
        ERROR_EXIT "super.img not found after extraction"
        return 1
    }

    # https://source.android.com/docs/core/ota/sparse_images
    if file "$super_img" | grep -q "sparse"; then
        local super_raw="${CURRENT_MODEL}/super.raw"
        RUN_CMD "Converting sparse image" \
            "\"$PREBUILTS/android-tools/simg2img\" \"$super_img\" \"$super_raw\" >/dev/null" || {
            rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
            ERROR_EXIT "sparse image to raw conversion failed"
        }
        rm -f "$super_img"
        super_img="$super_raw"
    fi

    #https://source.android.com/docs/core/ota/dynamic_partitions
    if [[ ! -f "$UNPACK_CONF" ]]; then
        local lpdump_output
        lpdump_output=$("$PREBUILTS/android-tools/lpdump" "$super_img" 2>&1) || {
            rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
            ERROR_EXIT "Failed to generate super metadata for $model"
        }

        local super_size metadata_size metadata_slots group_name group_size
        super_size=$(echo "$lpdump_output" | awk '/Partition name: super/,/Flags:/ {if ($1 == "Size:") {print $2; exit}}')
        metadata_size=$(echo "$lpdump_output" | awk '/Metadata max size:/ {print $4}')
        metadata_slots=$(echo "$lpdump_output" | awk '/Metadata slot count:/ {print $4}')

        read -r group_name group_size <<< $(echo "$lpdump_output" | awk '
            /Group table:/ {in_table=1}
            in_table && /Name:/ {name=$2}
            in_table && /Maximum size:/ {size=$3; if(size+0 > 0){print name, size; exit}}
        ')

        if [[ -n "$super_size" && -n "$group_name" ]]; then

		cat > "$UNPACK_CONF" <<EOF
METADATA="$current_data"
SUPER_SIZE="$super_size"
METADATA_SIZE="$metadata_size"
METADATA_SLOTS="$metadata_slots"
GROUP_NAME="$group_name"
GROUP_SIZE="$group_size"
EXTRACT_DATE="$(date '+%Y-%m-%d %H:%M:%S')"
PARTITIONS=""
EOF
        else
            ERROR_EXIT "Incomplete super metadata for $model"
        fi
    fi


RUN_CMD "Extracting partitions" \
    "\"$PREBUILTS/android-tools/lpunpack\" \"$super_img\" \"$CURRENT_MODEL/\"" || {
        rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
        ERROR_EXIT "Failed to extract partitions from $model"
    }

LOG_END "Partitions unpacked"


    rm -f "$super_img"

    local found_count=0
    for part in "${target_partitions[@]}"; do

        #https://source.android.com/docs/core/ota/ab
        for suffix in "_a" ""; do
            local src_img="${CURRENT_MODEL}/${part}${suffix}.img"
            local dst_img="${CURRENT_MODEL}/${part}.img"

            if [[ -f "$src_img" ]]; then
                [[ "$src_img" != "$dst_img" ]] && mv -f "$src_img" "$dst_img"

                UNPACK_PARTITION "$dst_img" "$model" || {
                    rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
                    return 1
                }

                rm -f "$dst_img"
                ((found_count++))
                break
            fi
        done
    done

    # Remove empty B slots (Virtual A/B)
    find "$CURRENT_MODEL" -maxdepth 1 -type f -name "*_b.img" -delete

    [[ $found_count -eq 0 ]] && {
        rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
        ERROR_EXIT "No valid partitions found for $model"
        return 1
    }

    # Put marker to skip next time.
    touch "${CURRENT_MODEL}/.extraction_complete"


if [[ -n "${SUDO_USER:-}" ]]; then
    chown -R "$SUDO_USER:$SUDO_USER" "$WORKDIR"
    chmod -R 755 "$WORKDIR"
fi

    LOG_END "Unpacked $model firmware. ( Got $found_count partitions)"

    return 0
}




#
# Detect filesystem type of partition images
#
# Uses magic numbers and blkid for reliable filesystem detection
# EROFS: 0xE0F5E1E2 (Linux 5.4+ read-only filesystem)
# F2FS:  0x1020F5F2 (Flash-Friendly File System)
# EXT4:  0x53EF at offset 1080 (Standard Linux filesystem)
#

DETECT_FILESYSTEM() {
    local IMAGE_PATH="$1"

    [[ ! -f "$IMAGE_PATH" ]] && ERROR_EXIT "Missing image: $IMAGE_PATH"

    # EROFS magic (offset 1024)
    if [[ "$(xxd -p -l 4 -s 1024 "$IMAGE_PATH" 2>/dev/null)" == "e0f5e1e2" ]]; then
        echo "erofs"
        return 0
    fi

    # EXT4 magic (offset 1080)
    if [[ "$(xxd -p -l 2 -s 1080 "$IMAGE_PATH" 2>/dev/null)" == "53ef" ]]; then
        echo "ext4"
        return 0
    fi

    # F2FS left only lul
    echo "f2fs"
    return 0
}




UNPACK_PARTITION() {
    local IMAGE_PATH=$1
    local FIRMWARE_NAME=$2
    local PART_NAME=$(basename "$IMAGE_PATH" .img)
    local FILESYSTEM_TYPE=$(DETECT_FILESYSTEM "$IMAGE_PATH")
    local UNPACKED_FW_DIR="${WORKDIR}/${FIRMWARE_NAME}"
    local CONFIG_OUT_DIR="$UNPACKED_FW_DIR/config"
    local PART_DESTINATION="$UNPACKED_FW_DIR/$PART_NAME"
    local FS_CONFIG_FILE="$CONFIG_OUT_DIR/${PART_NAME}_fs_config"
    local FILE_CONTEXTS_FILE="$CONFIG_OUT_DIR/${PART_NAME}_file_contexts"
    local TMP_MOUNT_DIR=""
    UNPACK_CONF="$UNPACKED_FW_DIR/unpack.conf"

    [[ ! -f "$IMAGE_PATH" ]] && ERROR_EXIT "Image not found: $IMAGE_PATH" && return 1


    rm -rf "$ASTROROM/out"
    mkdir -p "$CONFIG_OUT_DIR"

    LOG_INFO "Extracting $PART_NAME "


    [[ -d "$PART_DESTINATION" ]] && rm -rf "$PART_DESTINATION"
    rm -f "$FS_CONFIG_FILE" "$FILE_CONTEXTS_FILE"
    mkdir -p "$PART_DESTINATION"


    TMP_MOUNT_DIR=$(mktemp -d)
    trap 'SUDO umount "$TMP_MOUNT_DIR" &>/dev/null; fusermount -u "$TMP_MOUNT_DIR" &>/dev/null; rm -rf "$TMP_MOUNT_DIR"' RETURN


case $FILESYSTEM_TYPE in
    ext4)
            mount -o ro "$IMAGE_PATH" "$TMP_MOUNT_DIR" >/dev/null || {
              ERROR_EXIT "ext4 mount failed for $PART_NAME"
            return 1
        }
        ;;
    erofs)
            "$PREBUILTS/erofs-utils/fuse.erofs" "$IMAGE_PATH" "$TMP_MOUNT_DIR" 2> >(grep -v '^<W>' >&2) >/dev/null || {
              ERROR_EXIT "erofs mount failed for $PART_NAME"
            return 1
        }
        ;;
    f2fs)
            if IS_WSL; then
              ERROR_EXIT "Cannot mount f2fs image on WSL environment as of now"
            fi

            mount -o ro "$IMAGE_PATH" "$TMP_MOUNT_DIR" >/dev/null || {
              ERROR_EXIT "f2fs mount failed for $PART_NAME"
            return 1
        }
        ;;
    *)
        ERROR_EXIT "Unsupported filesystem: $FILESYSTEM_TYPE"
        return 1
        ;;
esac

        cp -a -T "$TMP_MOUNT_DIR" "$PART_DESTINATION" || {
          ERROR_EXIT "Cannot copy files to unpack directory for $PART_NAME"
        return 1
    }



#https://source.android.com/docs/security/features/selinux/implement
#https://source.android.com/docs/security/features/selinux
    LOG_INFO "Extracting links, modes & attrs from $PART_NAME"
    echo

    # Generate fs_config: UID, GID, permissions, capabilities
    # Format: <path> <uid> <gid> <mode> capabilities=<capability_mask>
    find "$TMP_MOUNT_DIR" | xargs stat -c "%n %u %g %a capabilities=0x0" > "$FS_CONFIG_FILE" || {
        ERROR_EXIT "Cannot generate file config for $PART_NAME"
        return 1
    }

    # Generate file_contexts: SELinux security contexts
    # Format: <path> <selinux_context>
    find "$TMP_MOUNT_DIR" | xargs -I {} sh -c 'echo "{} $(getfattr -n security.selinux --only-values -h --absolute-names "{}")"' sh > "$FILE_CONTEXTS_FILE" || {
        ERROR_EXIT "Cannot generate file contexts for $PART_NAME"
        return 1
    }


	sort -o "$FS_CONFIG_FILE" "$FS_CONFIG_FILE" 2>/dev/null
	sort -o "$FILE_CONTEXTS_FILE" "$FILE_CONTEXTS_FILE" 2>/dev/null


    if [[ "$PART_NAME" == "system" ]] && [[ -d "$PART_DESTINATION/system" ]]; then

        # System-as-root layout [/] | https://source.android.com/docs/core/architecture/partitions/system-as-root
        sed -i -e "s|$TMP_MOUNT_DIR |/ |g" -e "s|$TMP_MOUNT_DIR||g" "$FILE_CONTEXTS_FILE"
        sed -i -e "s|$TMP_MOUNT_DIR | |g" -e "s|$TMP_MOUNT_DIR/||g" "$FS_CONFIG_FILE"
    else
        # Other normal partition layout [PART_NAME/]
        sed -i "s|$TMP_MOUNT_DIR|/$PART_NAME|g" "$FILE_CONTEXTS_FILE"
        sed -i -e "s|$TMP_MOUNT_DIR | |g" -e "s|$TMP_MOUNT_DIR|$PART_NAME|g" "$FS_CONFIG_FILE"
        sed -i '1s|^|/ |' "$FS_CONFIG_FILE"
    fi

    # Escape regex metacharacters
    sed -i -E 's/([][()+*.^$?\\|])/\\\1/g' "$FILE_CONTEXTS_FILE"



    local CAPS_MAP_FILE=$(mktemp)


    while read -r raw_path; do
        real_cap=$(_GET_CAPABILITIES_HEX "$raw_path")

        if [[ "$real_cap" != "0x0" ]]; then

            if [[ "$PART_NAME" == "system" ]] && [[ -d "$PART_DESTINATION/system" ]]; then
                 config_path=${raw_path#$TMP_MOUNT_DIR/}
                 [[ "$config_path" == "$raw_path" ]] && config_path=""
            else
                 config_path="$PART_NAME${raw_path#$TMP_MOUNT_DIR}"
            fi

            [[ "$config_path" != /* ]] && config_path="/$config_path"
            [[ "$config_path" == "/" ]] && config_path="" # Root adjustment if needed


            echo "$config_path $real_cap" >> "$CAPS_MAP_FILE"
        fi
    done < <(find "$TMP_MOUNT_DIR" -type f)


    if [[ -s "$CAPS_MAP_FILE" ]]; then
        awk 'NR==FNR {caps[$1]=$2; next}
             ($1 in caps) { sub("capabilities=0x0", "capabilities=" caps[$1]); print; next }
             {print}' "$CAPS_MAP_FILE" "$FS_CONFIG_FILE" > "${FS_CONFIG_FILE}.tmp" && mv "${FS_CONFIG_FILE}.tmp" "$FS_CONFIG_FILE"
    fi

    rm -f "$CAPS_MAP_FILE"


    sed -i "/^PARTITIONS=/s/\"$/ $PART_NAME\"/" "$UNPACK_CONF"
    sed -i '/^PARTITIONS=/s/=" /="/' "$UNPACK_CONF"


    return 0
}


#
# Extracts the security.capability xattr and converts it to the fs_config hex format.
#

_GET_CAPABILITIES_HEX() {
    local FILE_PATH="$1"
    local CAP_HEX
    local DEFAULT_CAP="0x0"


    CAP_HEX=$(getfattr -n security.capability \
        --only-values -h --absolute-names \
        "$FILE_PATH" 2>/dev/null | xxd -p | tr -d '\n')

    # If empty, return default
    [[ -z "$CAP_HEX" ]] && echo "$DEFAULT_CAP" && return


    local PERMITTED_HEX
    PERMITTED_HEX=$(echo "$CAP_HEX" | cut -c 9-16)

    [[ -z "$PERMITTED_HEX" ]] && echo "$DEFAULT_CAP" && return

    # Convert Little Endian to Big Endian
    local BIG_ENDIAN
    BIG_ENDIAN=$(echo "$PERMITTED_HEX" | sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/')

    # formatting: 0x + hex value
    local FINAL_CAP="0x$(echo "$BIG_ENDIAN" | sed 's/^0*//')"

    # If the result is just "0x", make it "0x0"
    [[ "$FINAL_CAP" == "0x" ]] && FINAL_CAP="0x0"

    echo "$FINAL_CAP"
}

