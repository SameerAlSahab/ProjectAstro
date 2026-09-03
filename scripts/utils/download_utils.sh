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
FW_DIR="${ARCADEROM}/firmware"
FW_BASE="${FW_DIR}/downloaded"


DOWNLOAD_FW() {
    local TARGET_FIRMWARE="${1:-}"
    local TEMP_DOWNLOAD_DIR="${FW_BASE}/tmp_download"

    _CHECK_NETWORK_CONNECTION && LOG_INFO "Internet connection [OK]" || LOG_WARN "Cannot connect to internet."

    [[ -z "$MODEL$EXTRA_MODEL$STOCK_MODEL" ]] && ERROR_EXIT "No firmware configs found."

    mkdir -p "$FW_BASE"

    declare -A PROCESSED_MODELS

    for CONFIG_ENTRY in \
        "MAIN|$MODEL|$CSC|$IMEI" \
        "EXTRA|$EXTRA_MODEL|$EXTRA_CSC|${EXTRA_IMEI:-$IMEI}" \
        "STOCK|$STOCK_MODEL|$STOCK_CSC|$STOCK_IMEI"
    do
        IFS="|" read -r FW_PREFIX DEVICE_MODEL REGION_CODE DEVICE_IMEI <<< "$CONFIG_ENTRY"

        [[ -z "$DEVICE_MODEL" || -z "$REGION_CODE" ]] && continue

        if [[ -n "$TARGET_FIRMWARE" && "${FW_PREFIX,,}" != "${TARGET_FIRMWARE,,}" ]]; then
            continue
        fi

        [[ -v "PROCESSED_MODELS[$DEVICE_MODEL]" ]] && continue
        PROCESSED_MODELS["$DEVICE_MODEL"]=1

        FETCH_FW \
            "$FW_PREFIX" \
            "$DEVICE_MODEL" \
            "$REGION_CODE" \
            "$DEVICE_IMEI" \
            "$FW_BASE" \
            "$TEMP_DOWNLOAD_DIR"
    done

    rm -rf "$TEMP_DOWNLOAD_DIR"
}


FETCH_FW() {
    local FW_PREFIX="$1"
    local DEVICE_MODEL="$2"
    local REGION_CODE="$3"
    local DEVICE_IMEI="$4"
    local BASE_DIR="$5"
    local TEMP_DIR="$6"

    local TARGET_DIR="${BASE_DIR}/${DEVICE_MODEL}_${REGION_CODE}"
    local METADATA_FILE="${TARGET_DIR}/firmware.info"
    local FW_OUTPUT_DIR="${TEMP_DIR}/${DEVICE_MODEL}_${REGION_CODE}"

    LOG_BEGIN "Checking Firmware for $DEVICE_MODEL ($REGION_CODE)..."

    local HAS_LOCAL_FIRMWARE=false

    if [[ -d "$TARGET_DIR" ]]; then
        if ls "$TARGET_DIR"/AP_*.tar.md5 >/dev/null 2>&1; then
            local AP_FILE_PATH
            AP_FILE_PATH=$(ls "$TARGET_DIR"/AP_*.tar.md5 2>/dev/null | head -1)

            if [[ -f "$AP_FILE_PATH" && $(stat -f%z "$AP_FILE_PATH" 2>/dev/null || stat -c%s "$AP_FILE_PATH" 2>/dev/null) -gt 1024 ]]; then
                HAS_LOCAL_FIRMWARE=true
            fi
        fi
    fi

    local VERSION_XML
    local ANDROID_VERSION
    local SIMPLE_VERSION
    local FULL_VERSION

    VERSION_XML=$(
        curl -s -A "Dalvik/2.1.0" \
            "https://fota-cloud-dn.ospserver.net/firmware/${REGION_CODE}/${DEVICE_MODEL}/version.xml" \
            2>/dev/null
    )

    if echo "$VERSION_XML" | grep -q '<latest'; then
        ANDROID_VERSION=$(echo "$VERSION_XML" | grep -oP '<latest o="\K\d+' | head -1)
        SIMPLE_VERSION=$(echo "$VERSION_XML" | grep -oP '<latest o="\d+">\K[^<]+' | head -1)
        FULL_VERSION="${ANDROID_VERSION}_${SIMPLE_VERSION}"
    fi

    if [[ -z "$FULL_VERSION" ]]; then
        if [[ "$HAS_LOCAL_FIRMWARE" == true ]]; then
            LOG_INFO "Cannot connect to the internet. Using existing local firmware."
            return 0
        fi
        ERROR_EXIT "No internet connection and existing firmware found for $DEVICE_MODEL ($REGION_CODE)"
    fi

    LOG_INFO "Latest version: $SIMPLE_VERSION (Android $ANDROID_VERSION)"

    local CURRENT_VERSION=""
    [[ -f "$METADATA_FILE" ]] && CURRENT_VERSION=$(<"$METADATA_FILE")

    if [[ "$CURRENT_VERSION" == "$FULL_VERSION" && "$HAS_LOCAL_FIRMWARE" == true ]]; then
        LOG_END "$FW_PREFIX firmware is up to date/latest ($SIMPLE_VERSION)"
        return 0
    fi

    local USER_PROMPT
    if [[ "$HAS_LOCAL_FIRMWARE" == true ]]; then
        local LOCAL_VERSION="unknown"
        [[ -n "$CURRENT_VERSION" ]] && LOCAL_VERSION=$(echo "$CURRENT_VERSION" | cut -d'_' -f2-)
        USER_PROMPT="Newer firmware available. Current: $LOCAL_VERSION. Download update?"
    fi

    mkdir -p "$TARGET_DIR"

    LOG_INFO "Downloading firmware $SIMPLE_VERSION..."
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"

    (
        cd "$TEMP_DIR" || exit 1
        "$PREBUILTS/samfirm/samfirm.js" -m "$DEVICE_MODEL" -r "$REGION_CODE" -i "$DEVICE_IMEI"
    )

    if [[ $? -ne 0 ]]; then
        ERROR_EXIT "Failed to download the firmware for $DEVICE_MODEL ($REGION_CODE)"
    fi

    local NEW_AP_FILE
    NEW_AP_FILE=$(ls "$FW_OUTPUT_DIR"/AP_*.tar.md5 2>/dev/null | head -1)

    if [[ -z "$NEW_AP_FILE" ]]; then
        ERROR_EXIT "Download completed but AP file not found in $FW_OUTPUT_DIR"
    fi

    if ! _VALIDATE_AP_FILE "$NEW_AP_FILE"; then
        ERROR_EXIT "Downloaded AP file is corrupted or invalid"
    fi

    rm -rf "$TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    mv "$FW_OUTPUT_DIR"/* "$TARGET_DIR"/ 2>/dev/null
    echo "$FULL_VERSION" > "$METADATA_FILE"

    local WORKDIR_VAR_NAME="${FW_PREFIX}_WORKDIR"
    local WORKDIR_PATH="${!WORKDIR_VAR_NAME}"

    if [[ -n "$WORKDIR_PATH" && -d "$WORKDIR_PATH" ]]; then
        rm -rf "$WORKDIR_PATH" "$WORKSPACE"
    fi

}


_CHECK_NETWORK_CONNECTION() {
    curl -s \
        --connect-timeout 0.5 \
        --max-time 1 \
        https://clients3.google.com/generate_204 \
        >/dev/null
}


_VALIDATE_AP_FILE() {
    local AP_FILE_PATH="$1"

    [[ ! -f "$AP_FILE_PATH" ]] && return 1

    if ! tar -tf "$AP_FILE_PATH" >/dev/null 2>&1; then
        LOG_WARN "File is not a valid tar archive $AP_FILE_PATH"
        return 1
    fi

    local LZ4_PAYLOADS
    LZ4_PAYLOADS=$(tar -tf "$AP_FILE_PATH" | grep '\.lz4$' 2>/dev/null)

    if [[ -z "$LZ4_PAYLOADS" ]]; then
        LOG "No .lz4 payloads found in $AP_FILE_PATH to validate."
        return 1
    fi

    while read -r IMAGE_FILE; do
        if ! tar -xf "$AP_FILE_PATH" "$IMAGE_FILE" -O 2>/dev/null | lz4 -t >/dev/null 2>&1; then
            LOG_WARN "Corrupted LZ4 payload found: $IMAGE_FILE in $AP_FILE_PATH"
            return 1
        fi
    done < <(tar -tf "$AP_FILE_PATH" | grep '\.lz4$')

    return 0
}
# ]
