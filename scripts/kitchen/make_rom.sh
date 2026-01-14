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
# Creates a flashable ZIP package from the super.img and an installer.
#
CREATE_FLASHABLE_ZIP() {
    local BUILD_DATE
    local ZIP_NAME_PREFIX
    local SUPER_IMAGE_PATH
    local ZIP_BUILD_DIR
    local UNSIGNED_ZIP_PATH
    local SIGNED_ZIP_PATH
    local UPDATER_SCRIPT_PATH
    local COMPRESSION_LEVEL=3

    BUILD_DATE="$(date +%Y%m%d)"
    ZIP_NAME_PREFIX="AstroROM_${STOCK_MODEL}_v${ROM_VERSION}_${BUILD_DATE}"

    SUPER_IMAGE_PATH="${DIROUT}/super.img"
    ZIP_BUILD_DIR="${DIROUT}/zip_build"

    UNSIGNED_ZIP_PATH="${DIROUT}/${ZIP_NAME_PREFIX}.zip"
    SIGNED_ZIP_PATH="${DIROUT}/${ZIP_NAME_PREFIX}_signed.zip"

    [[ -f "${SUPER_IMAGE_PATH}" ]] || ERROR_EXIT "super.img missing."
    COMMAND_EXISTS "7z" || ERROR_EXIT "7z tool not found."

    [[ -f "${PREBUILTS}/signapk/signapk.jar" ]] || ERROR_EXIT "signapk.jar not found."
    [[ -f "${PREBUILTS}/signapk/keys/aosp_testkey.x509.pem" ]] || ERROR_EXIT "X509 key not found."
    [[ -f "${PREBUILTS}/signapk/keys/aosp_testkey.pk8" ]] || ERROR_EXIT "PK8 key not found."

    rm -rf "${ZIP_BUILD_DIR}"
    mkdir -p "${ZIP_BUILD_DIR}"

    cp -a "${PREBUILTS}/dynamic_installer/." "${ZIP_BUILD_DIR}/"
    mv "${SUPER_IMAGE_PATH}" "${ZIP_BUILD_DIR}/super.img"


    UPDATER_SCRIPT_PATH="${ZIP_BUILD_DIR}/META-INF/com/google/android/updater-script"

    if [[ -f "${UPDATER_SCRIPT_PATH}" ]]; then
        sed -i \
            -e "s|__ROM_VERSION__|${ROM_VERSION}|g" \
            -e "s|__MODEL_NAME__|${MODEL_NAME}|g" \
            -e "s|__BUILD_DATE__|${BUILD_DATE}|g" \
            -e "s|__CODENAME__|${CODENAME}|g" \
            "${UPDATER_SCRIPT_PATH}"
    fi


    RUN_CMD "Building ROM zip" \
        "cd '${ZIP_BUILD_DIR}' && 7z a -tzip -mx=${COMPRESSION_LEVEL} '${UNSIGNED_ZIP_PATH}' ."

    rm -rf "${ZIP_BUILD_DIR}"


#    LOG_INFO "Signing ZIP.."
#
#    java -jar "${PREBUILTS}/signapk/signapk.jar" -w \
#        "${PREBUILTS}/signapk/keys/aosp_testkey.x509.pem" \
#        "${PREBUILTS}/signapk/keys/aosp_testkey.pk8" \
#        "${UNSIGNED_ZIP_PATH}" \
#        "${SIGNED_ZIP_PATH}" \
#        || ERROR_EXIT "ZIP signing failed"
#
#    rm -f "${UNSIGNED_ZIP_PATH}"

    LOG_END "Flashable zip created at $(basename "${UNSIGNED_ZIP_PATH}")"
}



#
# Creates a super.img from individual partition images using lpmake.
#
BUILD_SUPER_IMAGE() {
    local CONFIG_FILE="$WORKDIR/$STOCK_MODEL/unpack.conf"


    [[ ! -f "$CONFIG_FILE" ]] && ERROR_EXIT "config not found for super image generation. Make sure you have stock firmware unpacked."

    source "$CONFIG_FILE"

    local valid_partitions=()
    local current_total_size=0

    for part in $PARTITIONS; do
        local img="$DIROUT/${part}.img"
        if [[ -f "$img" ]]; then
            valid_partitions+=("$part")
            current_total_size=$(( current_total_size + $(stat -c%s "$img") ))
        fi
    done

    (( current_total_size > GROUP_SIZE )) && ERROR_EXIT "Partition sizes ($current_total_size) exceed group limit ($GROUP_SIZE). Please try to reduce size."

    # Build the argument list for lpmake
    # https://android.googlesource.com/platform/system/extras/+/master/partition_tools/
    local lp_args=(
        --device-size "$SUPER_SIZE"
        --metadata-size "$METADATA_SIZE"
        --metadata-slots "$METADATA_SLOTS"
        --group "$GROUP_NAME:$GROUP_SIZE"
        --output "$DIROUT/super.img"
    )

    for part in "${valid_partitions[@]}"; do
        local p_size=$(stat -c%s "$DIROUT/${part}.img")
        lp_args+=(--partition "${part}:readonly:${p_size}:${GROUP_NAME}")
        lp_args+=(--image "${part}=$DIROUT/${part}.img")
    done

    RUN_CMD "Building super.img" "$PREBUILTS/android-tools/lpmake ${lp_args[*]}"


    for part in "${valid_partitions[@]}"; do
        rm -f "$DIROUT/${part}.img"
    done
}


REPACK_ROM() {
    local TARGET_FILESYSTEM="$1"

    if [[ -d "$DIROUT" ]]; then
        rm -rf "$DIROUT"/*
    else
        mkdir -p "$DIROUT"
    fi

    for part_dir in "$WORKSPACE"/*/; do
        local name=$(basename "$part_dir")

        [[ "$name" =~ ^(config|lost\+found)$ ]] && continue

        REPACK_PARTITION "$name" "$TARGET_FILESYSTEM" "$DIROUT" "$WORKSPACE"
    done

    # Check if we should create a full zip or just the unpacked images for debugging. For instance , fastboot or recovery flash.
    if GET_FEAT_STATUS DEBUG_BUILD; then
        LOG_INFO "ROM debug build enabled. Repacked images are available at $DIROUT"
    else
        # For a release build, create the final flashable ZIP
        BUILD_SUPER_IMAGE
        CREATE_FLASHABLE_ZIP
    fi
}
