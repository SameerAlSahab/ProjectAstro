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
PEM_CERT="${PREBUILTS}/signapk/keys/aosp_testkey.x509.pem"
PK8_KEY="${PREBUILTS}/signapk/keys/aosp_testkey.pk8"

CREATE_FLASHABLE_ZIP()
{
    local BUILD_DATE
    local ZIP_NAME_PREFIX
    local SUPER_IMAGE_PATH
    local ZIP_BUILD_DIR
    local UNSIGNED_ZIP_PATH
    local SIGNED_ZIP_PATH
    local UPDATER_SCRIPT_PATH
    local COMPRESSION_LEVEL=3

    local EXTRA_BLOCKS=""

    BUILD_DATE="$(date +%Y%m%d)"
    ZIP_NAME_PREFIX="AstroROM_${CODENAME}_v${ROM_VERSION}_${BUILD_DATE}"

    SUPER_IMAGE_PATH="${DIROUT}/super.img"
    ZIP_BUILD_DIR="${DIROUT}/zip_build"

    UNSIGNED_ZIP_PATH="${DIROUT}/${ZIP_NAME_PREFIX}.zip"
    SIGNED_ZIP_PATH="${DIROUT}/${ZIP_NAME_PREFIX}_signed.zip"

    [[ -f "${SUPER_IMAGE_PATH}" ]] || ERROR_EXIT "super.img missing."
    COMMAND_EXISTS "7z" || ERROR_EXIT "7z tool not found."

    [[ -f "${PREBUILTS}/signapk/signapk.jar" ]] || ERROR_EXIT "signapk.jar not found."

    rm -rf "${ZIP_BUILD_DIR}"
    mkdir -p "${ZIP_BUILD_DIR}"

    cp -a "${PREBUILTS}/dynamic_installer/." "${ZIP_BUILD_DIR}/"
    mv "${SUPER_IMAGE_PATH}" "${ZIP_BUILD_DIR}/super.img"

    cp "${DIROUT}"/*.img "${ZIP_BUILD_DIR}/" 2>/dev/null || true

    [[ -f "${DIROUT}/param.bin" ]] && cp "${DIROUT}/param.bin" "${ZIP_BUILD_DIR}/"

    UPDATER_SCRIPT_PATH="${ZIP_BUILD_DIR}/META-INF/com/google/android/updater-script"

    if [[ -f "${ZIP_BUILD_DIR}/boot.img" ]]; then
        EXTRA_BLOCKS+=$'\nui_print "Installing Kernel...";\nupdate_zip boot.img $(find_block boot);'
    fi

    if [[ -f "${ZIP_BUILD_DIR}/optics.img" ]]; then
        EXTRA_BLOCKS+=$'\nui_print "Installing Optics...";\nupdate_zip optics.img $(find_block optics);'
    fi

    if [[ -f "${ZIP_BUILD_DIR}/prism.img" ]]; then
        EXTRA_BLOCKS+=$'\nui_print "Installing Prism...";\nupdate_zip prism.img $(find_block prism);'
    fi

    if [[ -f "${ZIP_BUILD_DIR}/dtbo.img" ]]; then
        EXTRA_BLOCKS+=$'\nui_print "Installing DTBO...";\nupdate_zip dtbo.img $(find_block dtbo);'
    fi

    if [[ -f "${ZIP_BUILD_DIR}/up_param.bin" ]]; then
        EXTRA_BLOCKS+=$'\nui_print "Installing Param...";\nupdate_zip up_param.bin $(find_block up_param);'
    fi

    if [[ -f "${UPDATER_SCRIPT_PATH}" ]]; then
        local ASSERT_BLOCKS="${EXTRA_BLOCKS//$'\n'/\\n}"

        sed -i \
            -e "s|__ROM_VERSION__|${ROM_VERSION}|g" \
            -e "s|__MODEL_NAME__|${DEVICE_MODEL_NAME}|g" \
            -e "s|__BUILD_DATE__|${BUILD_DATE}|g" \
            -e "s|__CODENAME__|${CODENAME}|g" \
            -e "s|__EXTRA_ASSERTS__|${ASSERT_BLOCKS}|g" \
            "${UPDATER_SCRIPT_PATH}"
    fi

    RUN_CMD "Building ROM zip" \
        "cd '${ZIP_BUILD_DIR}' && 7z a -tzip -mx=${COMPRESSION_LEVEL} '${UNSIGNED_ZIP_PATH}' ."

    rm -rf "${ZIP_BUILD_DIR}"

    LOG_INFO "Signing ZIP.."
    java -jar "${PREBUILTS}/signapk/signapk.jar" -w \
        "${PREBUILTS}/signapk/keys/aosp_testkey.x509.pem" \
        "${PREBUILTS}/signapk/keys/aosp_testkey.pk8" \
        "$UNSIGNED_ZIP_PATH" \
        "$SIGNED_ZIP_PATH" \
        || ERROR_EXIT "Signing failed"

    rm -f "${UNSIGNED_ZIP_PATH}"
    LOG_END "Flashable zip created at $(basename "${SIGNED_ZIP_PATH}")"
}


BUILD_SUPER_IMAGE()
{
    local CONFIG_FILE="$WORKDIR/$STOCK_MODEL/unpack.conf"

    [[ ! -f "$CONFIG_FILE" ]] && ERROR_EXIT "config not found for super image generation. Make sure you have stock firmware unpacked."

    source "$CONFIG_FILE"

    [[ -n "${DEVICE_SUPER_PARTITION_SIZE:-}" ]] && SUPER_SIZE="$DEVICE_SUPER_PARTITION_SIZE"
    [[ -n "${DEVICE_SUPER_GROUP_BASIC_SIZE:-}" ]] && GROUP_SIZE="$DEVICE_SUPER_GROUP_BASIC_SIZE"

    local VALID_PARTITIONS=()
    local CURRENT_TOTAL_SIZE=0

    for PART in $PARTITIONS; do
        local IMG="$DIROUT/${PART}.img"

        if [[ -f "$IMG" ]] && IS_DYNAMIC_PARTITION "$PART"; then
            VALID_PARTITIONS+=("$PART")
            CURRENT_TOTAL_SIZE=$(( CURRENT_TOTAL_SIZE + $(stat -c%s "$IMG") ))
        fi
    done

    (( CURRENT_TOTAL_SIZE > GROUP_SIZE )) && ERROR_EXIT "Partition sizes ($CURRENT_TOTAL_SIZE) exceed group limit ($GROUP_SIZE). Please try to reduce size."

    # Build the argument list for lpmake
    # https://android.googlesource.com/platform/system/extras/+/master/partition_tools/
    local LP_ARGS=(
        --device-size "$SUPER_SIZE"
        --metadata-size "$METADATA_SIZE"
        --metadata-slots "$METADATA_SLOTS"
        --group "$GROUP_NAME:$GROUP_SIZE"
        --output "$DIROUT/super.img"
    )

    for PART in "${VALID_PARTITIONS[@]}"; do
        local P_SIZE=$(stat -c%s "$DIROUT/${PART}.img")
        LP_ARGS+=(--partition "${PART}:readonly:${P_SIZE}:${GROUP_NAME}")
        LP_ARGS+=(--image "${PART}=$DIROUT/${PART}.img")
    done

    RUN_CMD "Building super.img" "$PREBUILTS/android-tools/lpmake ${LP_ARGS[*]}"

    for PART in "${VALID_PARTITIONS[@]}"; do
        rm -f "$DIROUT/${PART}.img"
    done
}

REPACK_ROM()
{
    local TARGET_FILESYSTEM="$1"

    mkdir -p "$ARCADEROM/out"

    for PART_DIR in "$WORKSPACE"/*/; do
        local NAME=$(basename "$PART_DIR")
        local TARGET_FS="$TARGET_FILESYSTEM"

        [[ "$NAME" =~ ^(config|lost\+found|patches)$ ]] && continue

        if [[ "$NAME" == "optics" || "$NAME" == "prism" ]]; then
            TARGET_FS="ext4"
        fi

        REPACK_PARTITION "$NAME" "$TARGET_FS" "$DIROUT" "$WORKSPACE"
    done

    # Check if we should create a full zip or just the unpacked images for debugging. For instance , fastboot or recovery flash.
    if GET_FEATURE DEBUG_BUILD; then
        LOG_INFO "ROM debug build enabled. Repacked images are available at $DIROUT"
    else
        # For a release build, create the final flashable ZIP
        BUILD_SUPER_IMAGE
        CREATE_FLASHABLE_ZIP
    fi
}

# Very old method , work for under 4GB zips
# https://github.com/HemanthJabalpuri/signapk/blob/main/shell/SignApk.sh
SIGN_ROM_ZIP()
{
    local IN_ZIP="$1"
    local OUT_ZIP="$2"
    local PK8_FILE="$3"
    local PEM_FILE="$4"

    [[ -f "$IN_ZIP" ]]  || ERROR_EXIT "zip file not found $IN_ZIP"
    [[ -f "$PK8_FILE" ]] || ERROR_EXIT "PK8 key not found"
    [[ -f "$PEM_FILE" ]] || ERROR_EXIT "PEM cert not found"

    COMMAND_EXISTS openssl || ERROR_EXIT "openssl not found"
    COMMAND_EXISTS od || ERROR_EXIT "od not found"

    local FSIZE
    FSIZE=$(stat -c "%s" "$IN_ZIP")
    LOG_INFO "ZIP size: $FSIZE bytes"

    getData()
    {
        dd if="$IN_ZIP" status=none iflag=skip_bytes,count_bytes bs=4096 skip=$1 count=$2
    }

    getByte()
    {
        getData "$1" 1 | od -A n -t x1 | tr -d " "
    }

    local B1 B2 B3
    B1=$(getByte $((FSIZE-22)))
    B2=$(getByte $((FSIZE-21)))
    B3=$(getByte $((FSIZE-20)))

    if [[ "$B1" != "50" || "$B2" != "4b" || "$B3" != "05" ]]; then
        ERROR_EXIT "ZIP already signed or has a comment"
    fi

    getData 0 $((FSIZE - 2)) > "$OUT_ZIP"

    local SIGNATURE
    SIGNATURE=$(openssl dgst -sha1 -hex -sign "$PK8_FILE" "$OUT_ZIP" \
        | cut -d= -f2 | tr -d ' ' | sed 's/../\\x&/g')

    local CERT
    CERT=$(openssl x509 -in "$PEM_FILE" -outform DER \
        | od -A n -t x1 | tr -d ' \n' | sed 's/../\\x&/g')

    {
        printf '\xca\x06'
        printf 'signed by signapk'
        printf '\x00'
        printf "$CERT"
        printf "$SIGNATURE"
        printf '\xb8\x06\xff\xff\xca\x06'
    } >> "$OUT_ZIP"

    LOG_INFO "Signed successfully"
}

IS_DYNAMIC_PARTITION()
{
    local PART_NAME="$1"
    # List of common dynamic partitions
    case "$PART_NAME" in
        system|vendor|product|system_ext|odm|vendor_dlkm|system_dlkm|odm_dlkm)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
# ]
