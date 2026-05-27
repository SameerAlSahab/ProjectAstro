#!/usr/bin/env bash
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
PARTITION_HEADROOM_PERCENT=9
MINIMUM_RESIZE_THRESHOLD_KB=2048
# Optics is very tiny and need much extra space to repack fine.
OPTICS_PARTITION_EXTRA_SIZE_KB=51200

REPACK_PARTITION()
{
    local PARTITION_NAME="$1"
    local TARGET_FILESYSTEM="$2"
    local OUTPUT_DIR="$3"
    local FIRMWARE_WORK_DIR="$4"

    [[ ! -d "$FIRMWARE_WORK_DIR/$PARTITION_NAME" ]] && {
        ERROR_EXIT "Partition folder not found in $FIRMWARE_WORK_DIR/$PARTITION_NAME"
    }

    local EXTRACTION_CONFIG="$FIRMWARE_WORK_DIR/unpack.conf"

    local PARTITION_SIZE_KB=$(du -s -k "$FIRMWARE_WORK_DIR/$PARTITION_NAME" | awk '{print $1}')
    local TARGET_IMAGE_SIZE_KB


    if [[ "$PARTITION_NAME" == "optics" ]]; then
        TARGET_IMAGE_SIZE_KB=$((PARTITION_SIZE_KB + OPTICS_PARTITION_EXTRA_SIZE_KB))
    elif (( PARTITION_SIZE_KB < 15043 )); then
        TARGET_IMAGE_SIZE_KB=$((PARTITION_SIZE_KB * 2))
    else
        TARGET_IMAGE_SIZE_KB=$((PARTITION_SIZE_KB + PARTITION_SIZE_KB * PARTITION_HEADROOM_PERCENT / 100))
    fi

    # System-as-root partitions use "/" as their mount point
    local PARTITION_MOUNT_POINT="/$PARTITION_NAME"
    [[ "$PARTITION_NAME" =~ ^system(_[ab])?$ ]] && PARTITION_MOUNT_POINT="/"

    local CONFIG_BASE_PATH="$FIRMWARE_WORK_DIR/$PARTITION_NAME"
    [[ "$PARTITION_NAME" == "system" && -d "$FIRMWARE_WORK_DIR/system/system" ]] && CONFIG_BASE_PATH="$FIRMWARE_WORK_DIR/system/system"

    local FS_CONFIG_FILE="$FIRMWARE_WORK_DIR/config/${PARTITION_NAME}_fs_config"
    local FILE_CONTEXTS_FILE="$FIRMWARE_WORK_DIR/config/${PARTITION_NAME}_file_contexts"

    # Generate known missing config and context entries before building the image
    "$PREBUILTS/gen_config/gen_fsconfig" -t "$USABLE_THREADS" -p "$CONFIG_BASE_PATH" -c "$FS_CONFIG_FILE" -q >/dev/null 2>&1 || {
        echo
        ERROR_EXIT "Failed to generate missing configs for $PARTITION_NAME"
    }

    "$PREBUILTS/gen_config/gen_file_contexts" -t "$USABLE_THREADS" -a -f "$TARGET_FILESYSTEM" -p "$CONFIG_BASE_PATH" -c "$FILE_CONTEXTS_FILE" -q >/dev/null 2>&1 || {
        echo
        ERROR_EXIT "Failed to generate missing contexts for $PARTITION_NAME"
    }

    # Remove duplicates and ensure known capabilities exist for consistency
    for CONFIG_FILE in "$FS_CONFIG_FILE" "$FILE_CONTEXTS_FILE"; do
        awk '!seen[$0]++' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        sed -i 's/\r//g; s/[^[:print:]]//g; /^$/d' "$CONFIG_FILE"
    done

    sed -i '/^[a-zA-Z0-9\/]/ { /capabilities=/! s/$/ capabilities=0x0/ }' "$FS_CONFIG_FILE"
    sed -i 's/  */ /g' "$FS_CONFIG_FILE"

    # https://source.android.com/docs/core/architecture/android-kernel-file-system-support
    case "$TARGET_FILESYSTEM" in
        ext4)
            local EXT4_BLOCK_SIZE=4096
            local EXT4_BLOCK_COUNT=$((TARGET_IMAGE_SIZE_KB / 4))

            # Workaround: ext4 requires a lost+found entry to be declared in configs
            if [[ "$PARTITION_MOUNT_POINT" == "/" ]]; then
                grep -q "^/lost\+found " "$FILE_CONTEXTS_FILE" || echo "/lost\+found u:object_r:rootfs:s0" >> "$FILE_CONTEXTS_FILE"
                grep -q "^lost\+found " "$FS_CONFIG_FILE" || echo "lost+found 0 0 700 capabilities=0x0" >> "$FS_CONFIG_FILE"
            else
                grep -q "^/$PARTITION_NAME/lost\+found " "$FILE_CONTEXTS_FILE" || echo "/$PARTITION_NAME/lost\+found $(head -n 1 "$FILE_CONTEXTS_FILE" | awk '{print $2}')" >> "$FILE_CONTEXTS_FILE"
                grep -q "^$PARTITION_NAME/lost\+found " "$FS_CONFIG_FILE" || echo "$PARTITION_NAME/lost+found 0 0 700 capabilities=0x0" >> "$FS_CONFIG_FILE"
            fi

            # Build ext4 image using mke2fs, populate with e2fsdroid, and then make size minimum as possible
            # https://android.googlesource.com/platform/prebuilts/fullsdk-linux/platform-tools/+/83a183b4bced4377eb5817074db82885cfcae393/e2fsdroid
local BUILD_COMMAND="MKE2FS_CONFIG=/tmp/mke2fs.conf $PREBUILTS/android-tools/mke2fs.android \
-t ext4 \
-b $EXT4_BLOCK_SIZE \
-L '$PARTITION_MOUNT_POINT' \
-O sparse_super,filetype,resize_inode,dir_index,ext_attr,^has_journal \
'$OUTPUT_DIR/$PARTITION_NAME.img' \
$EXT4_BLOCK_COUNT"

            BUILD_COMMAND+=" && $PREBUILTS/android-tools/e2fsdroid -e -T 1230735600 -C '$FS_CONFIG_FILE' -S '$FILE_CONTEXTS_FILE' -a '$PARTITION_MOUNT_POINT' -f '$FIRMWARE_WORK_DIR/$PARTITION_NAME' '$OUTPUT_DIR/$PARTITION_NAME.img'"

            if [[ "$PARTITION_NAME" != "optics" ]]; then
                BUILD_COMMAND+=" && tune2fs -m 0 '$OUTPUT_DIR/$PARTITION_NAME.img'"
                BUILD_COMMAND+=" && e2fsck -fy '$OUTPUT_DIR/$PARTITION_NAME.img'"
                BUILD_COMMAND+=" && OPTIMIZED_BLOCKS=\$(tune2fs -l '$OUTPUT_DIR/$PARTITION_NAME.img' | awk '/Block count:/ {total=\$3} /Free blocks:/ {free=\$3} END { used=total-free; printf \"%d\", used + (used*0.01) + 10 }')"
                BUILD_COMMAND+=" && resize2fs -f '$OUTPUT_DIR/$PARTITION_NAME.img' \$OPTIMIZED_BLOCKS"
                BUILD_COMMAND+=" && truncate -s \$((OPTIMIZED_BLOCKS * $EXT4_BLOCK_SIZE)) '$OUTPUT_DIR/$PARTITION_NAME.img'"
            fi

            RUN_CMD "Building ${PARTITION_NAME} (ext4)" "$BUILD_COMMAND" || return 1
            ;;

        erofs)
            # https://source.android.com/docs/core/architecture/kernel/erofs
            # Samsung uses a fixed timestamp for their erofs images
            local EROFS_COMPRESSION="lz4hc,9"
            local EROFS_BLOCK_SIZE=4096
            local EROFS_TIMESTAMP=1640995200

            RUN_CMD "Building ${PARTITION_NAME} (erofs)" \
                "$PREBUILTS/erofs-utils/mkfs.erofs -z '$EROFS_COMPRESSION' -b $EROFS_BLOCK_SIZE -T $EROFS_TIMESTAMP --mount-point=$PARTITION_MOUNT_POINT --fs-config-file=$FS_CONFIG_FILE --file-contexts=$FILE_CONTEXTS_FILE $OUTPUT_DIR/$PARTITION_NAME.img $FIRMWARE_WORK_DIR/$PARTITION_NAME/" || return 1
            ;;

        f2fs)
            # https://android.googlesource.com/platform/external/f2fs-tools/
            # F2FS requires more complex size calculation due to its internal structure and overhead
            local PARTITION_BASE_SIZE=$(du -sb "$FIRMWARE_WORK_DIR/$PARTITION_NAME" | awk '{print $1}')
            local F2FS_OVERHEAD_BYTES
            local F2FS_MARGIN_PERCENT

            # TODO: Try make it minimum, as of now 56MB overhead + 7% headroom
            # TODO: f2fs is incomplete
            F2FS_OVERHEAD_BYTES=$((56 * 1024 * 1024))
            F2FS_MARGIN_PERCENT=107

            local F2FS_TOTAL_SIZE=$(( (F2FS_OVERHEAD_BYTES + PARTITION_BASE_SIZE) * F2FS_MARGIN_PERCENT / 100 ))
            local F2FS_TEMP_IMAGE="$OUTPUT_DIR/${PARTITION_NAME}_temp.img"
            local F2FS_TIMESTAMP=1640995200

            # Create a blank image, format it as F2FS, then populate it with sload.f2fs
            # https://android.googlesource.com/platform/external/f2fs-tools/+/71313114a147ee3fc4a411904de02ea8b6bf7f91/Android.mk
            RUN_CMD "Building ${PARTITION_NAME} (f2fs)" \
                "truncate -s $F2FS_TOTAL_SIZE $F2FS_TEMP_IMAGE && \
                $PREBUILTS/android-tools/make_f2fs -f -O extra_attr,inode_checksum,sb_checksum,compression $F2FS_TEMP_IMAGE && \
                $PREBUILTS/android-tools/sload_f2fs -f $FIRMWARE_WORK_DIR/$PARTITION_NAME -C $FS_CONFIG_FILE -s $FILE_CONTEXTS_FILE -T $F2FS_TIMESTAMP -t $PARTITION_MOUNT_POINT -c $F2FS_TEMP_IMAGE -a lz4 -L 2 && \
                mv $F2FS_TEMP_IMAGE $OUTPUT_DIR/$PARTITION_NAME.img" || return 1
            ;;

        *)
            ERROR_EXIT "Unsupported filesystem: $TARGET_FILESYSTEM"
            ;;
    esac
}
# ]
