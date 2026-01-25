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


_GET_FILE_INODE() {
    local file_path="$1"
	# Returns inode only
    stat -c "%i" "$file_path" 2>/dev/null || echo ""
}


_GET_MD5_HASH() {
    local file_path="$1"
    md5sum "$file_path" 2>/dev/null | awk '{print $1}' | tr -d '[:space:]'
}


_GET_FILE_STAT() {
    local file_path="$1"
    # %i=inode, %s=size, %Y=mtime
    stat -c "%i.%s.%Y" "$file_path" 2>/dev/null || echo "unknown"
}


#
# FETCH_FILE <container> <target_file> <output_directory>
#
FETCH_FILE() {
    local container="$1"
    local target_file="$2"
    local out_dir="$3"
    local depth="${4:-0}"

    [[ -f "$container" ]] || return 1
    mkdir -p "$out_dir"

    local out_path="$out_dir/$target_file"
    [[ -s "$out_path" ]] && return 0

    (( depth >= 5 )) && return 1

    if [[ -z "${IS_DEPS_OK:-}" ]]; then
        COMMAND_EXISTS 7z  || CHECK_DEPENDENCY p7zip-full "7zip" true
        COMMAND_EXISTS lz4 || CHECK_DEPENDENCY lz4 "lz4" true
        IS_DEPS_OK=1
    fi

    LOG_BEGIN "Fetching $target_file from $(basename "$container") (Depth: $depth)"

    local file_list
    file_list="$(7z l "$container" 2>/dev/null)" || return 1


    if echo "$file_list" | awk '{print $NF}' | grep -Fxq "$target_file"; then
        7z x "$container" "$target_file" -so 2>/dev/null > "$out_path"
        [[ -s "$out_path" ]] && return 0
        rm -f "$out_path"
    fi


    if echo "$file_list" | awk '{print $NF}' | grep -Fxq "$target_file.lz4"; then
        if 7z x "$container" "$target_file.lz4" -so 2>/dev/null \
            | lz4 -d -c > "$out_path"; then
            [[ -s "$out_path" ]] && return 0
        fi
        rm -f "$out_path"
    fi


    echo "$file_list" | awk '{print $NF}' \
        | grep -E '\.(tar(\.md5)?|zip|lz4|bin|img|7z|xz|gz)$' \
        | while read -r node; do

        local tmp_node
        tmp_node="$(mktemp "$out_dir/tmp_$(basename "$node").XXXXXX")"

        7z x "$container" "$node" -so 2>/dev/null > "$tmp_node" || {
            rm -f "$tmp_node"
            continue
        }

        if FETCH_FILE "$tmp_node" "$target_file" "$out_dir" "$((depth + 1))"; then
            rm -f "$tmp_node"
            exit 0
        fi

        rm -f "$tmp_node"
    done

    return 1
}


#
# Checks if a file exists or not in a firmware partition
#
EXISTS() {
    local source_firmware
    local partition_name
    local target_path

    if [[ $# -eq 2 ]]; then
        source_firmware=""
        partition_name="$1"
        target_path="$2"
    elif [[ $# -eq 3 ]]; then
        source_firmware="$1"
        partition_name="$2"
        target_path="$3"
    else
        ERROR_EXIT "Usage: EXISTS [source] <partition> <path>"
        return 1
    fi

    local base_dir
    base_dir=$(GET_PARTITION_PATH "$partition_name" "$source_firmware" 2>/dev/null) || return 1
    [[ ! -d "$base_dir" ]] && return 1

    local sanitized_path
    sanitized_path=$(_SANITIZE_PATH "$target_path")

    for match in "$base_dir"/$sanitized_path; do
        [[ -e "$match" ]] && return 0
    done

    return 1
}


MERGE_SPLITS() {
    local src_base="$1"
    local dest_file="$2"
    local search_mode="$3"
    local parts=()

    if [[ "$search_mode" == "DIR_CONTENTS" && -d "$src_base" ]]; then

        local first
        first=$(ls "$src_base"/*.part* "$src_base"/*.0[0-9]* "$src_base"/*.a[a-z] 2>/dev/null | head -n 1)

        if [[ -n "$first" ]]; then

            local base_name
            base_name=$(basename "$first" | sed -E 's/\.(part[0-9]+|[0-9]{2,}|[a-z]{2})$//')
            parts=($(ls "$src_base/$base_name."* "$src_base/${base_name}_part"* 2>/dev/null | sort))

            mkdir -p "$dest_file"
            dest_file="$dest_file/$base_name"
        fi

    elif [[ "$search_mode" == "FILE_SUFFIX" ]]; then

        parts=($(ls "${src_base}".part* "${src_base}"*.[0-9][0-9]* "${src_base}"*.[a-z][a-z] 2>/dev/null | sort))
    fi

    if [[ ${#parts[@]} -gt 0 ]]; then
        mkdir -p "$(dirname "$dest_file")"
        cat "${parts[@]}" > "$dest_file" || ERROR_EXIT "Failed to merge splits to $dest_file"
        return 0
    fi

    return 1
}

#
# Adds a file/folder from another firmware
# ADD_FROM_FW "source" "partition" "path" [dest_partition]
#
ADD_FROM_FW() {
    local source="$1"
    local src_part="$2"
    local src_path="$3"
    local dst_part="${4:-$src_part}"

    [[ -z "$source" || -z "$src_part" || -z "$src_path" ]] && \
        ERROR_EXIT "Usage: ADD_FROM_FW <source> <src_partition> <src_path> [dest_partition]"

    VALIDATE_WORKDIR "$source" || ERROR_EXIT "Invalid source: $source"

    local src_dir dst_dir
    src_dir=$(GET_PARTITION_PATH "$src_part" "$source") || ERROR_EXIT "Unknown src partition: $src_part"
    dst_dir=$(GET_PARTITION_PATH "$dst_part") || ERROR_EXIT "Unknown dst partition: $dst_part"

    local clean_path full_src full_dst
    clean_path=$(_SANITIZE_PATH "$src_path")
    full_src="$src_dir/$clean_path"
    full_dst="$dst_dir/$clean_path"

    if [[ -d "$full_src" ]]; then
        if MERGE_SPLITS "$full_src" "$full_dst" "DIR_CONTENTS"; then
            return 0
        fi

        mkdir -p "$full_dst"

        LOG "Adding folder $clean_path from $source"


        rsync -a --no-owner --no-group "$full_src/" "$full_dst/" || \
            ERROR_EXIT "Failed to copy folder $clean_path"
        return 0

    fi


    if [[ -f "$full_src" ]]; then
        mkdir -p "$(dirname "$full_dst")"
        LOG "Adding file $clean_path from $source"
        cp -f "$full_src" "$full_dst" || ERROR_EXIT "Copy failed: $clean_path"
        return 0
    fi


    if MERGE_SPLITS "$full_src" "$full_dst" "FILE_SUFFIX"; then
        return 0
    fi

    LOG_WARN "Path not found in source: $clean_path"
}


#
# Usage: ADD "partition_name" "source_path" "relative_dest_path" [log_label]
#
ADD() {
    local partition="$1"
    local src_path="$2"
    local dest_rel="$3"
    local label="${4:-$(basename "$src_path")}"

    local part_root full_dest
    part_root=$(GET_PARTITION_PATH "$partition") || \
        ERROR_EXIT "Add failed: partition '$partition'"

    full_dest="$part_root/$dest_rel"

    [[ "$src_path" == "$full_dest" ]] && return 0

    if [[ -d "$src_path" ]]; then


        mkdir -p "$full_dest"
        LOG "Adding folder: $label"


        rsync -a --no-owner --no-group "$src_path/" "$full_dest/" || \
            ERROR_EXIT "Failed to add $label"
        return 0
    fi


    if [[ -f "$src_path" ]]; then

        if [[ -d "$full_dest" ]]; then
            full_dest="$full_dest/$(basename "$src_path")"
        fi

        mkdir -p "$(dirname "$full_dest")"
        LOG "Adding file: $label"
        cp -f "$src_path" "$full_dest" || ERROR_EXIT "Copy failed: $label"
        return 0
    fi


    if [[ ! -e "$src_path" ]]; then
        if MERGE_SPLITS "$src_path" "$full_dest" "FILE_SUFFIX"; then
            return 0
        fi
    fi

    ERROR_EXIT "Source not found: $src_path"
}
