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



# Usage: FF "TAG" "VALUE"
# FF "TAG" "" ->> means deletion of line
# Modifies /system/system/etc/floating_feature.xml for Samsung-specific features
FF() {
    local TAG="$1"
    local TAG_VALUE="$2"
    local FF_XML_FILE="${WORKSPACE}/system/system/etc/floating_feature.xml"

    if ! command -v xmlstarlet &> /dev/null; then
        ERROR_EXIT "xmlstarlet not found."
        return 1
    fi

    _SEC_FF_PREFIX TAG

    if [[ -z "$TAG_VALUE" ]]; then
        if xmlstarlet sel -t -v "//${TAG}" "$FF_XML_FILE" &>/dev/null; then
            xmlstarlet ed -L -d "//${TAG}" "$FF_XML_FILE"
            LOG "Deleted floating feature: <${TAG}>"
        fi
        return
    fi

    if [[ ! -f "$FF_XML_FILE" ]]; then
        mkdir -p "$(dirname "$FF_XML_FILE")"
        cat > "$FF_XML_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<SecFloatingFeatureSet>
</SecFloatingFeatureSet>
EOF
        LOG_INFO "Created new floating_feature.xml"
    fi

    local current_value
    current_value=$(xmlstarlet sel -t -v "//${TAG}" "$FF_XML_FILE" 2>/dev/null || true)

    if [[ -n "$current_value" ]]; then
        if [[ "$current_value" != "$TAG_VALUE" ]]; then
            xmlstarlet ed -L -u "//${TAG}" -v "$TAG_VALUE" "$FF_XML_FILE"
            LOG "Updated : <${TAG}>${TAG_VALUE}</${TAG}>"
        else
            LOG_INFO "Unchanged : <${TAG}> already set to ${TAG_VALUE}"
        fi
    else
        # Add new tag
        xmlstarlet ed -L -s '/SecFloatingFeatureSet' -t elem -n "$TAG" -v "$TAG_VALUE" "$FF_XML_FILE"
        LOG "Added : <${TAG}>${TAG_VALUE}</${TAG}>"
    fi
}


#
# Samsung floating feature have a common prefix at tag starting. [SEC_FLOATING_FEATURE_]
#
_SEC_FF_PREFIX() {
    local -n TAG_REFERANCE="$1"
    local REQUIRED_PREFIX="SEC_FLOATING_FEATURE_"
    if [[ "$TAG_REFERANCE" != ${REQUIRED_PREFIX}* ]]; then
        TAG_REFERANCE="${REQUIRED_PREFIX}${TAG_REFERANCE}"
    fi
}


#
# Usage: FF_IF_DIFF "fw_type" "TAG" "VALUE"
# Sets floating feature only if value differs from existing one
# If absent in the fw which we are comparing delete the line
#

FF_IF_DIFF() {
    local SOURCE_TYPE="$1"
    local TAG="$2"


    local SOURCE_VAL
    SOURCE_VAL=$(GET_FF_VAL "$SOURCE_TYPE" "$TAG")


    local CURRENT_VAL
    CURRENT_VAL=$(GET_FF_VAL "$TAG")


    if [[ "$SOURCE_VAL" != "$CURRENT_VAL" ]]; then
        FF "$TAG" "$SOURCE_VAL"
    else
        LOG_INFO "No changes needed for $TAG"
    fi
}


#
# Usage: GET_FF_VAL [source] "TAG_NAME"
# Retrieves the value of a specified floating feature tag from the XML file.
#
GET_FF_VAL() {
    local FW_TYPE="main"
    local TAG

    if [[ $# -eq 1 ]]; then
        TAG="$1"
    elif [[ $# -eq 2 ]]; then
        FW_TYPE="$1"
        TAG="$2"
    else
        LOG_WARN "Invalid number of arguments. Usage: GET_FF_VAL [source] 'TAG'" >&2
        return 1
    fi

    local workspace_dir
    workspace_dir=$(GET_FW_DIR "$FW_TYPE") || return 1

    local FF_XML_FILE="${workspace_dir}/system/system/etc/floating_feature.xml"
    [[ ! -f "$FF_XML_FILE" ]] && return 1

    _SEC_FF_PREFIX TAG
    xmlstarlet sel -t -v "//${TAG}" "$FF_XML_FILE" 2>/dev/null || true
}



#
# Usage: _GET_PROP_PATHS <DIRECTORY> <partition>
# Internal helper function to generate possible property file paths for a specific partition.
#
_GET_PROP_PATHS() {
    local DIRECTORY="$1"
    local partition="$2"

    case "$partition" in
        "system")      echo "${DIRECTORY}/system/system/build.prop" ;;
        "vendor")      echo "${DIRECTORY}/vendor/build.prop" "${DIRECTORY}/vendor/etc/build.prop" "${DIRECTORY}/vendor/default.prop" ;;
        "product")     echo "${DIRECTORY}/product/etc/build.prop" "${DIRECTORY}/product/build.prop" ;;
        "system_ext")  echo "${DIRECTORY}/system_ext/etc/build.prop" "${DIRECTORY}/system/system/system_ext/etc/build.prop" ;;
        "odm")         echo "${DIRECTORY}/odm/etc/build.prop" ;;
        "vendor_dlkm") echo "${DIRECTORY}/vendor_dlkm/etc/build.prop" "${DIRECTORY}/vendor/vendor_dlkm/etc/build.prop" ;;
        "odm_dlkm")    echo "${DIRECTORY}/vendor/odm_dlkm/etc/build.prop" ;;
        "system_dlkm") echo "${DIRECTORY}/system_dlkm/etc/build.prop" "${DIRECTORY}/system/system/system_dlkm/etc/build.prop" ;;
    esac
}

#
# Usage: _RESOLVE_PROP_FILE <DIRECTORY> <partition>
# Internal helper function to locate and return the high potential `build.prop` file in a specific partition.
#
_RESOLVE_PROP_FILE() {
    local DIRECTORY="$1"
    local partition="$2"

    for file in $(_GET_PROP_PATHS "$DIRECTORY" "$partition"); do
        if [[ -f "$file" ]]; then
            echo "$file"
            return 0
        fi
    done
    return 1
}

#
# Usage: _FIND_PROP_IN_PARTITION <DIRECTORY> <partition> <prop_name>
# Internal helper function to locate and return the high potential `build.prop` file in a selected partition.
#
_FIND_PROP_IN_PARTITION() {
    local DIRECTORY="$1"
    local partition="$2"
    local prop_name="$3"

    for file in $(_GET_PROP_PATHS "$DIRECTORY" "$partition"); do
        if [[ -f "$file" ]] && grep -q -E "^${prop_name}=" "$file"; then
            echo "$file"
            return 0
        fi
    done
    return 1
}

#
# Adds, updates, or deletes entries in a `build.prop` file from a specific partition.
# Usage: BPROP <partition> <tag> <value>
# To delete a property: BPROP <partition> <tag> ""
#

BPROP() {
    local partition="$1"
    local tag="$2"
    local value="$3"


    local ASTRO_MARKER="# Added by AstroROM [utils/props.sh]"
    local END_MARKER="# end of file"
    local prop_file

    if [[ -z "$partition" || -z "$tag" ]]; then
        ERROR_EXIT "BPROP: Partition and Tag are required."
        return 1
    fi


    if ! prop_file=$(_FIND_PROP_IN_PARTITION "$WORKSPACE" "$partition" "$tag"); then

        prop_file=$(_RESOLVE_PROP_FILE "$WORKSPACE" "$partition")
    fi


    if [[ -z "$prop_file" || ! -f "$prop_file" ]]; then
        LOG_INFO "Cannot set property.No build.prop found for partition '$partition' . Skipping ${tag}."
        return 0
    fi


    local tmp_file
    tmp_file=$(mktemp)
    cp "$prop_file" "$tmp_file"


    if [[ -z "$value" ]]; then
        if grep -q "^${tag}=" "$tmp_file"; then
            sed -i "/^${tag}=/d" "$tmp_file"
            LOG "Deleted property from ${partition}: ${tag}"
        else
            LOG_INFO "Property not found in ${partition}: ${tag} (Nothing to delete)."
        fi


    elif grep -q "^${tag}=" "$tmp_file"; then

        sed -i "s|^${tag}=.*|${tag}=${value}|" "$tmp_file"
        LOG_INFO "Updated existing property in ${partition}: ${tag}=${value}"

    else

        local insert_content=""


        if ! grep -Fq "$ASTRO_MARKER" "$tmp_file"; then
            insert_content="${ASTRO_MARKER}\n"
        fi

        insert_content="${insert_content}${tag}=${value}"


        if grep -Fq "$END_MARKER" "$tmp_file"; then

            local end_footer
            end_footer=$(echo "$END_MARKER" | sed 's/[]\/$*.^[]/\\&/g')


            sed -i "/$end_footer/i $insert_content" "$tmp_file"
        else

            echo -e "$insert_content" >> "$tmp_file"
        fi

        LOG "Added new property to ${partition}: ${tag}=${value}"
    fi


if ! mv -f "$tmp_file" "$prop_file"; then
    rm -f "$tmp_file"
       ERROR_EXIT "Failed to write changes to $prop_file"
    return 1
fi

}

#
# Usage: DIFF_UPDATE_PROP <FW_TYPE> <SOURCE_PARTITION> <tag> <TARGET_PARTITION>
# Add property value from one firmware to another
# If the property already exists in workspace, it will be updated.
#
DIFF_UPDATE_PROP() {
    local FW_TYPE="$1"
    local SOURCE_PARTITION="$2"
    local PROP_TAG="$3"
    local TARGET_PARTITION="$4"

    local source_fs_dir
    source_fs_dir=$(GET_PARTITION_PATH "$FW_TYPE") || return 1

    local src_prop_path
    src_prop_path=$(_RESOLVE_PROP_FILE "$source_fs_dir" "$SOURCE_PARTITION")

    if [[ -z "$src_prop_path" ]]; then
        LOG_WARN "Source prop file not found for partition '$SOURCE_PARTITION' in '$FW_TYPE'."
        return 0
    fi

    local prop_value
    prop_value=$(grep -m 1 -E "^${PROP_TAG}=" "$src_prop_path" | cut -d '=' -f2- | tr -d '\r')

    if [[ -z "$prop_value" ]]; then
        LOG_WARN "Property '$PROP_TAG' not found in '$src_prop_path'."
        return 0
    fi

    BPROP "$TARGET_PARTITION" "$PROP_TAG" "$prop_value"
}



#
# Usage: GET_PROP <partition> <prop_name>
# Retrieves the value of a specified property from the specified partition's `build.prop` file. Returns if not found.
#
GET_PROP() {
    local partition="$1"
    local prop_name="$2"
    local source_type="${3:-}"

    local prop_file
    if [[ -n "$source_type" ]]; then

        local workdir_path
        workdir_path=$(GET_FW_DIR "$source_type") || return 1
        prop_file=$(_RESOLVE_PROP_FILE "$workdir_path" "$partition") || return 1
    else

        prop_file=$(_RESOLVE_PROP_FILE "$WORKSPACE" "$partition")
        [[ -z "$prop_file" ]] && return 1
    fi

    # Check if the property exists in the file
    if ! grep -q "^${prop_name}=" "$prop_file"; then
        return 1
    fi

    grep "^${prop_name}=" "$prop_file" | cut -d'=' -f2- | tr -d '\r'
}




