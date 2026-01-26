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



_SANITIZE_PATH() {
    realpath -m --relative-to=. "$1" | sed 's|^/||; s|/$||'
}


GET_FEATURE() {
    local var_name="$1"
    local default="${2:-false}"


    if ! declare -p "$var_name" &>/dev/null; then
        ERROR_EXIT
    fi

    local val="${!var_name,,}"

    case "$val" in
        true|1|y|yes|on)
            return 0 ;;
        false|0|n|no|off|"")
            return 1 ;;
        *)
            LOG_WARN "Invalid value for $var_name='$val'"
            ERROR_EXIT ;;
    esac
}


#
# Adds/updates a unique entry to file_contexts
#
ADD_CONTEXT() {
    local PARTITION="$1"
    local FILE_PATH="$2"
    local TYPE="$3"

    (( $# < 3 )) && ERROR_EXIT "USAGE: ADD_CONTEXT <PARTITION> <FILE_PATH> <TYPE>"

    local CONTEXT_FILE="${CONFIG_DIR}/${PARTITION}_file_contexts"

    FILE_PATH="${FILE_PATH#/}"

    local FULL_PATH="/${PARTITION}/${FILE_PATH}"

    TYPE="${TYPE%%:s0}"
    local CONTEXT="u:object_r:${TYPE}:s0"

    # Escape dots for file_contexts regex
    local ESCAPED_PATH
    ESCAPED_PATH="$(printf '%s\n' "$FULL_PATH" | sed 's/\./\\./g')"

    local EXACT_ENTRY="${ESCAPED_PATH} ${CONTEXT}"

    mkdir -p -- "$(dirname -- "$CONTEXT_FILE")"
    touch -- "$CONTEXT_FILE"

    grep -qxF -- "$EXACT_ENTRY" "$CONTEXT_FILE" && return 0

    local TMP_FILE
    TMP_FILE="$(mktemp)"

    local REPLACED=0
    local LINE

    while IFS= read -r LINE || [[ -n "$LINE" ]]; do
        if [[ "$LINE" =~ ^${ESCAPED_PATH}[[:space:]] ]]; then
            if (( ! REPLACED )); then
                printf '%s\n' "$EXACT_ENTRY" >> "$TMP_FILE"
                REPLACED=1
            fi
            continue
        fi

        printf '%s\n' "$LINE" >> "$TMP_FILE"
    done < "$CONTEXT_FILE"

    (( ! REPLACED )) && printf '%s\n' "$EXACT_ENTRY" >> "$TMP_FILE"

    mv -- "$TMP_FILE" "$CONTEXT_FILE"
}


#
# Removes file frorm workspace
# Usage REMOVE "partition" "path"
#

REMOVE() {
    local partition="$1"
    local relative_path="$2"

    if [[ -z "$partition" || -z "$relative_path" ]]; then
        ERROR_EXIT "Missing arguments. Usage: REMOVE <partition> <path>"
    fi

    local base_dir
    base_dir=$(GET_PARTITION_PATH "$partition" 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        ERROR_EXIT "Failed to get partition directory for '$partition'"
    fi

    local clean_path
    clean_path=$(_SANITIZE_PATH "$relative_path")


    local found_any=false


    for match in "${base_dir}"/$clean_path; do

        [[ ! -e "$match" && ! -L "$match" ]] && continue

        found_any=true

        # Remove from Disk
        if ! rm -rf "$match" 2>/dev/null; then
            ERROR_EXIT "Failed to remove '$match'"
        fi


        local actual_rel_path="${match#$base_dir/}"


        local escaped_path
        escaped_path=$(printf '%s' "$actual_rel_path" | sed 's/[.[\*^$()+?{|]/\\&/g')

        local fs_config_file="$WORKSPACE/config/${partition}_fs_config"
        local file_contexts_file="$WORKSPACE/config/${partition}_file_contexts"

        if [[ -f "$fs_config_file" ]]; then
            sed -i "\|^${partition}/${escaped_path}\(/\|[[:space:]]\)|d" "$fs_config_file"
        fi

        if [[ -f "$file_contexts_file" ]]; then
            sed -i "\|^/${partition}/${escaped_path}\(/\|[[:space:]]\)|d" "$file_contexts_file"
        fi
    done

    if [[ "$found_any" = false ]]; then
        LOG_WARN "No files matching '${partition}/${clean_path}' found to remove."
    fi

    return 0
}




#
# Apply hex patch to file
# Usage: HEX_EDIT "vendor/lib64/lib.so" "DEADBEEF" "CAFEBABE"
#

HEX_EDIT() {
    local rel_path="$1"
    local from_hex="$2"
    local to_hex="$3"
    local file="${WORKSPACE}/${rel_path}"


    if [[ -z "$rel_path" ]] || [[ -z "$from_hex" ]] || [[ -z "$to_hex" ]]; then
        ERROR_EXIT "Usage: HEX_EDIT <relative-path> <old-hex> <new-hex>"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        ERROR_EXIT "File not found: $rel_path"
        return 1
    fi

    # Normalize patterns to lowercase
    from_hex=$(tr '[:upper:]' '[:lower:]' <<< "$from_hex")
    to_hex=$(tr '[:upper:]' '[:lower:]' <<< "$to_hex")

    # Get file's hex dump
    local file_hex
    file_hex=$(xxd -p "$file" | tr -d '\n ')

    # Check if already patched
    if grep -q "$to_hex" <<< "$file_hex"; then
        LOG_INFO "Already patched: $rel_path"
        return 0
    fi


    if ! grep -q "$from_hex" <<< "$file_hex"; then
        LOG_WARN "Pattern not found in file: $from_hex"
        LOG_WARN "File: $rel_path"
        return 1
    fi

    LOG_INFO "Patching $from_hex → $to_hex in $rel_path"

    if echo "$file_hex" | sed "s/$from_hex/$to_hex/" | xxd -r -p > "${file}.tmp"; then
        mv "${file}.tmp" "$file"
        return 0
    else
        ERROR_EXIT "Failed to apply patch to $rel_path"
        rm -f "${file}.tmp"
        return 1
    fi
}


IS_GITHUB_ACTIONS() {
    [[ "${GITHUB_ACTIONS}" == "true" || "${CI}" == "true" ]]
}


# https://github.com/canonical/snapd/blob/ec7ea857712028b7e3be7a5f4448df575216dbfd/release/release.go#L169-L190
IS_WSL() {
    [ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ] || [ -e "/run/WSL" ]
}


REPLACE_LINE() {
    local OLD="$1"
    local NEW="$2"
    local FILE="$3"

    if [ ! -f "$FILE" ]; then
        ERROR_EXIT "File not found: $FILE"
    fi

    if grep -Fq "$NEW" "$FILE"; then
        LOG_WARN "Already patched in $FILE"
        return 0
    fi

    if grep -Fq "$OLD" "$FILE"; then
        LOG_INFO "Replacing old line with new line in $FILE"

        sed -i "s|$OLD|$NEW|g" "$FILE" \
            || ERROR_EXIT "Failed to patch $FILE"

        LOG_INFO "Replaced $OLD with $NEW successfully to $FILE"
        return 0
    fi

    ERROR_EXIT "Line not found in $FILE: '$OLD'"
}

