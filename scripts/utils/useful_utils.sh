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


GET_FEAT_STATUS() {
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
    local partition="$1"
    local file_path="$2"
    local type="$3"

    [[ $# -lt 3 ]] && ERROR_EXIT "Usage: ADD_CONTEXT <partition> <file_path> <type>"

    local context_file="${CONFIG_DIR}/${partition}_file_contexts"


    [[ "$file_path" != /* ]] && file_path="/$file_path"

    type="${type%%:s0}"
    local context="u:object_r:${type}:s0"

    # Escape dots for regex
    local escaped_path
    escaped_path=$(printf '%s\n' "$file_path" | sed 's/\./\\./g')

    mkdir -p "$(dirname "$context_file")"
    touch "$context_file"

    local exact_entry="${escaped_path} ${context}"


    if grep -qxF "$exact_entry" "$context_file"; then
        return 0
    fi

    local tmp
    tmp=$(mktemp)

    local replaced=0
    while IFS= read -r line || [[ -n "$line" ]]; do

        if [[ "$line" =~ ^${escaped_path}[[:space:]] ]]; then
            if [[ $replaced -eq 0 ]]; then
                echo "$exact_entry" >> "$tmp"
                replaced=1
            fi
            continue
        fi
        echo "$line" >> "$tmp"
    done < "$context_file"


    [[ $replaced -eq 0 ]] && echo "$exact_entry" >> "$tmp"

    mv "$tmp" "$context_file"

    return 0
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
        ERROR_EXIT "Pattern not found in file: $from_hex"
        ERROR_EXIT "File: $rel_path"
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

# https://github.com/canonical/snapd/blob/ec7ea857712028b7e3be7a5f4448df575216dbfd/release/release.go#L169-L190
IS_WSL() {
    [ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ] || [ -e "/run/WSL" ]

# Check if running in GitHub Actions environment
IS_GITHUB_ACTIONS() {
    [[ "${GITHUB_ACTIONS}" == "true" || "${CI}" == "true" ]]
}
