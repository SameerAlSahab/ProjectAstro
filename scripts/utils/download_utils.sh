##!/usr/bin/env bash
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


FW_DIR="${ASTROROM}/firmware"
FW_BASE="${FW_DIR}/downloaded"


DOWNLOAD_FW() {
    local TARGET_FW="${1:-}"
    local TMP_DIR="${FW_BASE}/tmp_download"


    _CHECK_NETWORK_CONNECTION && LOG_INFO "Internet connection [OK]" || LOG_WARN "Cannot connect to internet."

    [[ -z "$MODEL$EXTRA_MODEL$STOCK_MODEL" ]] && ERROR_EXIT "No firmware configs found."

    mkdir -p "$FW_BASE"
    declare -A processed_models

    for cfg in \
      "MAIN|$MODEL|$CSC|$IMEI" \
      "EXTRA|$EXTRA_MODEL|$EXTRA_CSC|${EXTRA_IMEI:-$IMEI}" \
      "STOCK|$STOCK_MODEL|$STOCK_CSC|$STOCK_IMEI"
    do
        IFS="|" read -r PREFIX mod reg imei <<< "$cfg"

        [[ -z "$mod" || -z "$reg" ]] && continue


        if [[ -n "$TARGET_FW" && "${PREFIX,,}" != "${TARGET_FW,,}" ]]; then
            continue
        fi

        [[ -v "processed_models[$mod]" ]] && continue
        processed_models["$mod"]=1

        FETCH_FW "$PREFIX" "$mod" "$reg" "$imei" "$FW_BASE" "$TMP_DIR"
    done

    rm -rf "$TMP_DIR"
}


FETCH_FW() {
    local PREFIX="$1" mod="$2" reg="$3" imei="$4" base="$5" tmp="$6"
    local TARGET="${base}/${mod}_${reg}"
    local METADATA="${TARGET}/firmware.info"
    local FW_OUT_DIR="${tmp}/${mod}_${reg}"


    LOG_BEGIN "Checking Firmware for $mod ($reg)..."


    local has_local_fw=false
    if [[ -d "$TARGET" ]]; then

        if ls "$TARGET"/AP_*.tar.md5 >/dev/null 2>&1; then
            local AP_FILE=$(ls "$TARGET"/AP_*.tar.md5 2>/dev/null | head -1)
            if [[ -f "$AP_FILE" && $(stat -f%z "$AP_FILE" 2>/dev/null || stat -c%s "$AP_FILE" 2>/dev/null) -gt 1024 ]]; then
                has_local_fw=true


            fi
        fi
    fi

    # Fetch latest firmware version from server
    local xml ver_full ver_simple android_ver
    xml=$(curl -s -A "Dalvik/2.1.0" "https://fota-cloud-dn.ospserver.net/firmware/${reg}/${mod}/version.xml" 2>/dev/null)

    if echo "$xml" | grep -q '<latest'; then
        android_ver=$(echo "$xml" | grep -oP '<latest o="\K\d+' | head -1)
        ver_simple=$(echo "$xml" | grep -oP '<latest o="\d+">\K[^<]+' | head -1)
        ver_full="${android_ver}_${ver_simple}"
    fi


    if [[ -z "$ver_full" ]]; then
        if [[ "$has_local_fw" == true ]]; then
            LOG_INFO "Cannot connect to the internet. Using existing local firmware."
            return 0
        fi
        ERROR_EXIT "No internet connection and existing firmware found for $mod ($reg)"
    fi

    LOG_INFO "Latest version: $ver_simple (Android $android_ver)"


    local current=""
    [[ -f "$METADATA" ]] && current=$(<"$METADATA")

    if [[ "$current" == "$ver_full" && "$has_local_fw" == true ]]; then
        LOG_END "$PREFIX firmware is up to date/latest ($ver_simple)"
        return 0
    fi


    local prompt
    if [[ "$has_local_fw" == true ]]; then
        local local_ver="unknown"
        [[ -n "$current" ]] && local_ver=$(echo "$current" | cut -d'_' -f2-)
        prompt="Newer firmware available. Current: $local_ver. Download update?"
    fi


    mkdir -p "$TARGET"
    
LOG_INFO "Downloading firmware $ver_simple..."
rm -rf "$tmp" && mkdir -p "$tmp"

(
  cd "$tmp" 
  "$PREBUILTS/samfirm/samfirm.js" -m "$mod" -r "$reg" -i "$imei"
)


if [[ $? -ne 0 ]]; then
    ERROR_EXIT "Failed to download the firmware for $mod ($reg)"
fi

    local new_ap=$(ls "$FW_OUT_DIR"/AP_*.tar.md5 2>/dev/null | head -1)
    if [[ -z "$new_ap" ]]; then
        ERROR_EXIT "Download completed but AP file not found in $FW_OUT_DIR"
    fi

    if ! _VALIDATE_AP_FILE "$new_ap"; then
        ERROR_EXIT "Downloaded AP file is corrupted or invalid"
    fi

    rm -rf "$TARGET" && mkdir -p "$TARGET"
 
    mv "$FW_OUT_DIR"/* "$TARGET"/ 2>/dev/null
        echo "$ver_full" > "$METADATA"


        local fs_var="${PREFIX}_WORKDIR"
        local fs_path="${!fs_var}"
        if [[ -n "$fs_path" && -d "$fs_path" ]]; then
            rm -rf "$fs_path" "$WORKSPACE"
        fi

        LOG_END "Successfully downloaded $PREFIX firmware ($ver_simple)"
}



_CHECK_NETWORK_CONNECTION() {
    curl -s \
        --connect-timeout 0.5 \
        --max-time 1 \
        https://clients3.google.com/generate_204 \
        >/dev/null
}


_VALIDATE_AP_FILE() {
    local AP_FILE="$1"

    [[ ! -f "$AP_FILE" ]] && return 1


    if ! tar -tf "$AP_FILE" >/dev/null 2>&1; then
        LOG_WARN "File is not a valid tar archive $AP_FILE"
        return 1
    fi


    local lz4_files
    lz4_files=$(tar -tf "$AP_FILE" | grep '\.lz4$' 2>/dev/null)

    if [[ -z "$lz4_files" ]]; then
        LOG "No .lz4 payloads found in $AP_FILE to validate."
        return 1
    fi


    while read -r img; do

        if ! tar -xf "$AP_FILE" "$img" -O 2>/dev/null | lz4 -t >/dev/null 2>&1; then
            LOG_WARN "Corrupted LZ4 payload found: $img in $AP_FILE"
            return 1
        fi
    done < <(tar -tf "$AP_FILE" | grep '\.lz4$')

    return 0
}


#
# Usage:
#DLOAD out <link>
#DLOAD out <link> <file_to_rename>
#DLOAD out <link> -unzip
#DLOAD <partition> <rel_path> <link>
#DLOAD <partition> <rel_path> <link> <file_to_rename>
#DLOAD <partition> <rel_path> <link> -unzip
#

DLOAD() {
    local TARGET="$1" path url opt1 opt2 final_path tmpfile

    if [[ "$TARGET" == "out" ]]; then
        path="$OUTDIR"
        url="$2"
        opt1="$3"
        shift 2
    else
        local base; base=$(GET_PARTITION_PATH "$TARGET" 2>/dev/null)
        [[ -z "$base" ]] && { echo "[-] Target $TARGET failed"; return 1; }
        path="${base}/$2"
        url="$3"
        opt1="$4"
        opt2="$5"
        shift 3
    fi

    mkdir -p "$path"
    tmpfile=$(mktemp "${path}/dl.XXXX")


    LOG "Downloading: $(basename "$url")"

    if ! curl -LSs -o "$tmpfile" "$url"; then
        ERROR_EXIT "Failed to fetch from $url"
        rm -f "$tmpfile"
        return 1
    fi


    if [[ "$opt1" == "-unzip" || "$opt2" == "-unzip" ]]; then
        unzip -qo "$tmpfile" -d "$path" && rm -f "$tmpfile"
    else
        local name; [[ -n "$opt1" && "$opt1" != "-unzip" ]] && name="$opt1" || name=$(basename "$url" | cut -d'?' -f1)
        mv "$tmpfile" "${path}/${name}"
    fi

}
