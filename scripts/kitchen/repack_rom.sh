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



REPACK_PARTITION() {
    local PART_NAME="$1"
    local TARGET_FILESYSTEM="$2"
    local OUT_DIR="$3"
    local MODEL_FW_DIR="$4"

    [[ ! -d "$MODEL_FW_DIR/$PART_NAME" ]] && {
        ERROR_EXIT "Partition folder not found in $MODEL_FW_DIR/$PART_NAME"
    }

    local UNPACK_CONF="$MODEL_FW_DIR/unpack.conf"
    local HEADROOM_PERCENT=9

    local FOLDERSIZE_IN_KB=$(du -s -k "$MODEL_FW_DIR/$PART_NAME" | awk '{print $1}')
    TARGET_SIZE_IN_KB=$((FOLDERSIZE_IN_KB + FOLDERSIZE_IN_KB * HEADROOM_PERCENT / 100))
    MIN_RESIZE_KB=2048

if [[ "$PART_NAME" == "optics" ]]; then
    TARGET_SIZE_IN_KB=$((4 * 1024))
elif (( FOLDERSIZE_IN_KB < 15043 )); then
    TARGET_SIZE_IN_KB=$((FOLDERSIZE_IN_KB * 2))
else
    TARGET_SIZE_IN_KB=$((FOLDERSIZE_IN_KB + FOLDERSIZE_IN_KB * HEADROOM_PERCENT / 100))
fi

    # System-as-root partitions use "/" as their mount point
    local MOUNT_POINT="/$PART_NAME"
    [[ "$PART_NAME" =~ ^system(_[ab])?$ ]] && MOUNT_POINT="/"


    local config_path="$MODEL_FW_DIR/$PART_NAME"
    [[ "$PART_NAME" == "system" && -d "$MODEL_FW_DIR/system/system" ]] && config_path="$MODEL_FW_DIR/system/system"

    local fs_config="$MODEL_FW_DIR/config/${PART_NAME}_fs_config"
    local file_contexts="$MODEL_FW_DIR/config/${PART_NAME}_file_contexts"


    # Generate known missing config and context entries before building the image
    "$PREBUILTS/gen_config/gen_fsconfig" -t "$USABLE_THREADS" -p "$config_path" -c "$fs_config" -q >/dev/null 2>&1 || {
        echo
        ERROR_EXIT "Failed to generate missing configs for $PART_NAME"
    }

    "$PREBUILTS/gen_config/gen_file_contexts" -t "$USABLE_THREADS" -a -f "$TARGET_FILESYSTEM" -p "$config_path" -c "$file_contexts" -q >/dev/null 2>&1 || {
        echo
        ERROR_EXIT "Failed to generate missing contexts for $PART_NAME"
    }

    # Remove duplicates and ensure known capabilities exist for consistency
    for f in "$fs_config" "$file_contexts"; do
        awk '!seen[$0]++' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        sed -i 's/\r//g; s/[^[:print:]]//g; /^$/d' "$f"
    done

    sed -i '/^[a-zA-Z0-9\/]/ { /capabilities=/! s/$/ capabilities=0x0/ }' "$fs_config"
    sed -i 's/  */ /g' "$fs_config"


    # https://source.android.com/docs/core/architecture/android-kernel-file-system-support
    case "$TARGET_FILESYSTEM" in
        ext4)
            local BLOCK_COUNT=$(( TARGET_SIZE_IN_KB / 4 )) # ext4 block size is 4096 bytes

            # Workaround: ext4 requires a lost+found entry to be declared in configs
            if [[ "$MOUNT_POINT" == "/" ]]; then
                grep -q "^/lost\+found " "$file_contexts" || echo "/lost\+found u:object_r:rootfs:s0" >> "$file_contexts"
                grep -q "^lost\+found " "$fs_config" || echo "lost+found 0 0 700 capabilities=0x0" >> "$fs_config"
            else
                grep -q "^/$PART_NAME/lost\+found " "$file_contexts" || echo "/$PART_NAME/lost\+found $(head -n 1 "$file_contexts" | awk '{print $2}')" >> "$file_contexts"
                grep -q "^$PART_NAME/lost\+found " "$fs_config" || echo "$PART_NAME/lost+found 0 0 700 capabilities=0x0" >> "$fs_config"
            fi

            # Build ext4 image using mke2fs, populate with e2fsdroid, and then make size minimium as possible.
            # https://android.googlesource.com/platform/prebuilts/fullsdk-linux/platform-tools/+/83a183b4bced4377eb5817074db82885cfcae393/e2fsdroid
            local build_cmd="$PREBUILTS/android-tools/mke2fs.android -t ext4 -b 4096 -L '$MOUNT_POINT' -O ^has_journal '$OUT_DIR/$PART_NAME.img' $BLOCK_COUNT"

            build_cmd+=" && $PREBUILTS/android-tools/e2fsdroid -e -T 1230735600 -C '$fs_config' -S '$file_contexts' -a '$MOUNT_POINT' -f '$MODEL_FW_DIR/$PART_NAME' '$OUT_DIR/$PART_NAME.img'"

            if (( TARGET_SIZE_IN_KB > 3072 )); then
                build_cmd+=" && tune2fs -m 0 '$OUT_DIR/$PART_NAME.img'"
                build_cmd+=" && e2fsck -fy '$OUT_DIR/$PART_NAME.img'"
                build_cmd+=" && NEW_BLOCKS=\$(tune2fs -l '$OUT_DIR/$PART_NAME.img' | awk '/Block count:/ {total=\$3} /Free blocks:/ {free=\$3} END { used=total-free; printf \"%d\", used + (used*0.01) + 10 }')"
                build_cmd+=" && resize2fs -f '$OUT_DIR/$PART_NAME.img' \$NEW_BLOCKS"
                build_cmd+=" && truncate -s \$((NEW_BLOCKS * 4096)) '$OUT_DIR/$PART_NAME.img'"
            fi

            RUN_CMD "Building ${PART_NAME} (ext4)" "$build_cmd" || return 1

            ;;

        erofs)
            # https://source.android.com/docs/core/architecture/kernel/erofs
            # Samsung uses a fixed timestamp for their erofs images.
            RUN_CMD "Building ${PART_NAME} (erofs)" \
                "$PREBUILTS/erofs-utils/mkfs.erofs -z 'lz4hc,9' -b 4096 -T 1640995200 --mount-point=$MOUNT_POINT --fs-config-file=$fs_config --file-contexts=$file_contexts $OUT_DIR/$PART_NAME.img $MODEL_FW_DIR/$PART_NAME/" || return 1
            ;;

        f2fs)
            # https://android.googlesource.com/platform/external/f2fs-tools/
            # F2FS requires more complex size calculation due to its internal structure and overhead.
            local BASE_SIZE=$(du -sb "$MODEL_FW_DIR/$PART_NAME" | awk '{print $1}')
            local F2FS_OVERHEAD
            local MARGIN_IN_PERCENT
            # TODO: Try make it minimium , as of now 56MB overhead+7% headroom
                F2FS_OVERHEAD=$((56 * 1024 * 1024))
                MARGIN_IN_PERCENT=107

            local TOTAL_SIZE=$(( (F2FS_OVERHEAD + BASE_SIZE) * MARGIN_IN_PERCENT / 100 ))
            local TEMP_IMG="$OUT_DIR/${PART_NAME}_temp.img"

            # Create a blank image, format it as F2FS, then populate it with sload.f2fs
            # https://android.googlesource.com/platform/external/f2fs-tools/+/71313114a147ee3fc4a411904de02ea8b6bf7f91/Android.mk
            RUN_CMD "Building ${PART_NAME} (f2fs)" \
                "truncate -s $TOTAL_SIZE $TEMP_IMG && \
                $PREBUILTS/android-tools/make_f2fs -f -O extra_attr,inode_checksum,sb_checksum,compression $TEMP_IMG && \
                $PREBUILTS/android-tools/sload_f2fs -f $MODEL_FW_DIR/$PART_NAME -C $fs_config -s $file_contexts -T 1640995200 -t $MOUNT_POINT -c $TEMP_IMG -a lz4 -L 2 && \
                mv $TEMP_IMG $OUT_DIR/$PART_NAME.img" || return 1
            ;;

        *)
            ERROR_EXIT "Unsupported filesystem: $TARGET_FILESYSTEM"
            ;;
    esac
}


