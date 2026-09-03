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



SEC_FLOATING_FEATURE_PREFIX="SEC_FLOATING_FEATURE_"

APPLY_FF_PREFIX()
{
    local -n TAG_REFERENCE="$1"

    if [[ "$TAG_REFERENCE" != ${SEC_FLOATING_FEATURE_PREFIX}* ]]; then
        TAG_REFERENCE="${SEC_FLOATING_FEATURE_PREFIX}${TAG_REFERENCE}"
    fi
}

FF()
{
    local FEATURE_TAG="$1"
    local FEATURE_VALUE="$2"
    local FLOATING_FEATURE_FILE="${WORKSPACE}/system/system/etc/floating_feature.xml"

    if ! command -v xmlstarlet &> /dev/null; then
        ERROR_EXIT "xmlstarlet not found."
        return 1
    fi

    APPLY_FF_PREFIX FEATURE_TAG

    if [[ -z "$FEATURE_VALUE" ]]; then
        if xmlstarlet sel -t -v "//${FEATURE_TAG}" "$FLOATING_FEATURE_FILE" &>/dev/null; then
            xmlstarlet ed -L -d "//${FEATURE_TAG}" "$FLOATING_FEATURE_FILE"
            LOG_INFO "Deleted floating feature: ${COLOR_GRAY}<${FEATURE_TAG}>${COLOR_RESET}"
        fi
        return
    fi

    local CURRENT_FEATURE_VALUE
    CURRENT_FEATURE_VALUE=$(xmlstarlet sel -t -v "//${FEATURE_TAG}" "$FLOATING_FEATURE_FILE" 2>/dev/null || true)

    if [[ -n "$CURRENT_FEATURE_VALUE" ]]; then
        if [[ "$CURRENT_FEATURE_VALUE" != "$FEATURE_VALUE" ]]; then
            xmlstarlet ed -L -u "//${FEATURE_TAG}" -v "$FEATURE_VALUE" "$FLOATING_FEATURE_FILE"
            LOG_INFO "Updated: ${COLOR_CYAN}${FEATURE_TAG}${COLOR_RESET} = ${COLOR_GREEN}${FEATURE_VALUE}${COLOR_RESET}"
        else
            LOG_INFO "Unchanged: ${COLOR_GRAY}${FEATURE_TAG}${COLOR_RESET} already set to ${FEATURE_VALUE}"
        fi
    else
        xmlstarlet ed -L -s '/SecFloatingFeatureSet' -t elem -n "$FEATURE_TAG" -v "$FEATURE_VALUE" "$FLOATING_FEATURE_FILE"
        LOG_INFO "Added: ${COLOR_CYAN}${FEATURE_TAG}${COLOR_RESET} = ${COLOR_GREEN}${FEATURE_VALUE}${COLOR_RESET}"
    fi
}

FF_IF_DIFF()
{
    local SOURCE_FIRMWARE_TYPE="$1"
    local FEATURE_TAG="$2"

    local SOURCE_FEATURE_VALUE
    SOURCE_FEATURE_VALUE=$(GET_FF_VAL "$SOURCE_FIRMWARE_TYPE" "$FEATURE_TAG")

    local CURRENT_FEATURE_VALUE
    CURRENT_FEATURE_VALUE=$(GET_FF_VAL "$FEATURE_TAG")

    if [[ "$SOURCE_FEATURE_VALUE" != "$CURRENT_FEATURE_VALUE" ]]; then
        FF "$FEATURE_TAG" "$SOURCE_FEATURE_VALUE"
    else
        LOG_INFO "No changes needed for ${COLOR_GRAY}${FEATURE_TAG}${COLOR_RESET}"
    fi
}

GET_FF_VAL()
{
    local FIRMWARE_TYPE="main"
    local FEATURE_TAG

    if [[ $# -eq 1 ]]; then
        FEATURE_TAG="$1"
    elif [[ $# -eq 2 ]]; then
        FIRMWARE_TYPE="$1"
        FEATURE_TAG="$2"
    else
        LOG_WARN "Invalid number of arguments. Usage: GET_FF_VAL [source] 'TAG'" >&2
        return 1
    fi

    local FIRMWARE_WORKSPACE_DIR
    FIRMWARE_WORKSPACE_DIR=$(GET_FW_DIR "$FIRMWARE_TYPE") || return 1

    local FLOATING_FEATURE_FILE="${FIRMWARE_WORKSPACE_DIR}/system/system/etc/floating_feature.xml"
    [[ ! -f "$FLOATING_FEATURE_FILE" ]] && return 1

    APPLY_FF_PREFIX FEATURE_TAG
    xmlstarlet sel -t -v "//${FEATURE_TAG}" "$FLOATING_FEATURE_FILE" 2>/dev/null || true
}



CF()
{
    local CAMERA_TAG="$1"
    shift
    local CAMERA_FEATURE_FILE="${WORKSPACE}/system/system/cameradata/camera-feature.xml"

    local TAG_EXISTS
    TAG_EXISTS=$(xmlstarlet sel -t -c "//local[@name='$CAMERA_TAG']" "$CAMERA_FEATURE_FILE" 2>/dev/null || true)

    if [[ $# -eq 0 ]] || [[ -z "$1" ]]; then
        if [[ -n "$TAG_EXISTS" ]]; then
            xmlstarlet ed -L -d "//local[@name='$CAMERA_TAG']" "$CAMERA_FEATURE_FILE"
            LOG_INFO "Deleted camera feature: ${COLOR_GRAY}${CAMERA_TAG}${COLOR_RESET}"
        else
            LOG_INFO "Tag ${COLOR_GRAY}${CAMERA_TAG}${COLOR_RESET} doesn't exist, nothing to delete"
        fi
        return
    fi

    declare -A CAMERA_ATTRIBUTES
    local DELETE_MODE=false

    for ATTRIBUTE_ARG in "$@"; do
        if [[ "$ATTRIBUTE_ARG" == *"="* ]]; then
            local ATTRIBUTE_NAME="${ATTRIBUTE_ARG%%=*}"
            local ATTRIBUTE_VALUE="${ATTRIBUTE_ARG#*=}"

            if [[ -z "$ATTRIBUTE_VALUE" ]]; then
                CAMERA_ATTRIBUTES["$ATTRIBUTE_NAME"]="__DELETE__"
            else
                CAMERA_ATTRIBUTES["$ATTRIBUTE_NAME"]="$ATTRIBUTE_VALUE"
            fi
        fi
    done

    if [[ -z "$TAG_EXISTS" ]]; then
        local ATTRIBUTE_STRING=""
        for ATTRIBUTE_NAME in "${!CAMERA_ATTRIBUTES[@]}"; do
            if [[ "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" != "__DELETE__" ]]; then
                ATTRIBUTE_STRING+=" $ATTRIBUTE_NAME=\"${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}\""
            fi
        done

        xmlstarlet ed -L \
            -s '/resources' -t elem -n "local" \
            -i '//local[not(@name)]' -t attr -n "name" -v "$CAMERA_TAG" \
            "$CAMERA_FEATURE_FILE"

        for ATTRIBUTE_NAME in "${!CAMERA_ATTRIBUTES[@]}"; do
            if [[ "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" != "__DELETE__" ]]; then
                xmlstarlet ed -L \
                    -i "//local[@name='$CAMERA_TAG']" -t attr -n "$ATTRIBUTE_NAME" -v "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" \
                    "$CAMERA_FEATURE_FILE"
            fi
        done

        LOG_INFO "Added camera feature: ${COLOR_CYAN}${CAMERA_TAG}${COLOR_RESET}"
    else
        for ATTRIBUTE_NAME in "${!CAMERA_ATTRIBUTES[@]}"; do
            local CURRENT_ATTRIBUTE_VALUE
            CURRENT_ATTRIBUTE_VALUE=$(xmlstarlet sel -t -v "//local[@name='$CAMERA_TAG']/@$ATTRIBUTE_NAME" "$CAMERA_FEATURE_FILE" 2>/dev/null || true)

            if [[ "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" == "__DELETE__" ]]; then
                if [[ -n "$CURRENT_ATTRIBUTE_VALUE" ]]; then
                    xmlstarlet ed -L -d "//local[@name='$CAMERA_TAG']/@$ATTRIBUTE_NAME" "$CAMERA_FEATURE_FILE"
                    LOG_INFO "Deleted attribute ${COLOR_YELLOW}${ATTRIBUTE_NAME}${COLOR_RESET} from ${COLOR_CYAN}${CAMERA_TAG}${COLOR_RESET}"
                fi
            else
                if [[ -n "$CURRENT_ATTRIBUTE_VALUE" ]]; then
                    if [[ "$CURRENT_ATTRIBUTE_VALUE" != "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" ]]; then
                        xmlstarlet ed -L -u "//local[@name='$CAMERA_TAG']/@$ATTRIBUTE_NAME" -v "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" "$CAMERA_FEATURE_FILE"
                        LOG_INFO "Updated ${COLOR_CYAN}${CAMERA_TAG}${COLOR_RESET}: ${ATTRIBUTE_NAME}=${COLOR_GREEN}${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}${COLOR_RESET}"
                    else
                        LOG_INFO "Unchanged: ${COLOR_GRAY}${CAMERA_TAG}${COLOR_RESET} ${ATTRIBUTE_NAME} already set to ${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}"
                    fi
                else
                    xmlstarlet ed -L -i "//local[@name='$CAMERA_TAG']" -t attr -n "$ATTRIBUTE_NAME" -v "${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}" "$CAMERA_FEATURE_FILE"
                    LOG_INFO "Added attribute to ${COLOR_CYAN}${CAMERA_TAG}${COLOR_RESET}: ${ATTRIBUTE_NAME}=${COLOR_GREEN}${CAMERA_ATTRIBUTES[$ATTRIBUTE_NAME]}${COLOR_RESET}"
                fi
            fi
        done
    fi
}

alias CAMERA_FEATURE=CF


GET_PROP_PATHS()
{
    local FIRMWARE_DIRECTORY="$1"
    local PARTITION_NAME="$2"

    case "$PARTITION_NAME" in
        "system")
            echo "${FIRMWARE_DIRECTORY}/system/system/build.prop"
            ;;
        "vendor")
            echo "${FIRMWARE_DIRECTORY}/vendor/build.prop"
            echo "${FIRMWARE_DIRECTORY}/vendor/etc/build.prop"
            echo "${FIRMWARE_DIRECTORY}/vendor/default.prop"
            ;;
        "product")
            echo "${FIRMWARE_DIRECTORY}/product/etc/build.prop"
            echo "${FIRMWARE_DIRECTORY}/product/build.prop"
            ;;
        "system_ext")
            echo "${FIRMWARE_DIRECTORY}/system_ext/etc/build.prop"
            echo "${FIRMWARE_DIRECTORY}/system/system/system_ext/etc/build.prop"
            ;;
        "odm")
            echo "${FIRMWARE_DIRECTORY}/odm/etc/build.prop"
            ;;
        "vendor_dlkm")
            echo "${FIRMWARE_DIRECTORY}/vendor_dlkm/etc/build.prop"
            echo "${FIRMWARE_DIRECTORY}/vendor/vendor_dlkm/etc/build.prop"
            ;;
        "odm_dlkm")
            echo "${FIRMWARE_DIRECTORY}/vendor/odm_dlkm/etc/build.prop"
            ;;
        "system_dlkm")
            echo "${FIRMWARE_DIRECTORY}/system_dlkm/etc/build.prop"
            echo "${FIRMWARE_DIRECTORY}/system/system/system_dlkm/etc/build.prop"
            ;;
    esac
}

RESOLVE_PROP_FILE()
{
    local FIRMWARE_DIRECTORY="$1"
    local PARTITION_NAME="$2"

    for PROP_FILE_PATH in $(GET_PROP_PATHS "$FIRMWARE_DIRECTORY" "$PARTITION_NAME"); do
        if [[ -f "$PROP_FILE_PATH" ]]; then
            echo "$PROP_FILE_PATH"
            return 0
        fi
    done
    return 1
}

FIND_PROP_IN_PARTITION()
{
    local FIRMWARE_DIRECTORY="$1"
    local PARTITION_NAME="$2"
    local PROPERTY_NAME="$3"

    for PROP_FILE_PATH in $(GET_PROP_PATHS "$FIRMWARE_DIRECTORY" "$PARTITION_NAME"); do
        if [[ -f "$PROP_FILE_PATH" ]] && grep -q -E "^${PROPERTY_NAME}=" "$PROP_FILE_PATH"; then
            echo "$PROP_FILE_PATH"
            return 0
        fi
    done
    return 1
}

BPROP()
{
    local PARTITION_NAME="$1"
    local PROPERTY_TAG="$2"
    local PROPERTY_VALUE="$3"

    local ARCADEROM_MARKER="# Added by AstroROM [scripts/Internal/props.sh]"
    local END_OF_FILE_MARKER="# end of file"
    local RESOLVED_PROP_FILE

    if [[ -z "$PARTITION_NAME" || -z "$PROPERTY_TAG" ]]; then
        ERROR_EXIT "BPROP: Partition and Tag are required."
        return 1
    fi

    if ! RESOLVED_PROP_FILE=$(FIND_PROP_IN_PARTITION "$WORKSPACE" "$PARTITION_NAME" "$PROPERTY_TAG"); then
        RESOLVED_PROP_FILE=$(RESOLVE_PROP_FILE "$WORKSPACE" "$PARTITION_NAME")
    fi

    if [[ -z "$RESOLVED_PROP_FILE" || ! -f "$RESOLVED_PROP_FILE" ]]; then
        LOG_INFO "Cannot set property. No build.prop found for partition '${COLOR_YELLOW}${PARTITION_NAME}${COLOR_RESET}'. Skipping ${COLOR_GRAY}${PROPERTY_TAG}${COLOR_RESET}"
        return 0
    fi

    local TEMP_PROP_FILE
    TEMP_PROP_FILE=$(mktemp)
    cp "$RESOLVED_PROP_FILE" "$TEMP_PROP_FILE"

    if [[ -z "$PROPERTY_VALUE" ]]; then
        if grep -q "^${PROPERTY_TAG}=" "$TEMP_PROP_FILE"; then
            sed -i "/^${PROPERTY_TAG}=/d" "$TEMP_PROP_FILE"
            LOG_INFO "Deleted property from ${COLOR_YELLOW}${PARTITION_NAME}${COLOR_RESET}: ${COLOR_GRAY}${PROPERTY_TAG}${COLOR_RESET}"
        else
            LOG_INFO "Property not found in ${COLOR_YELLOW}${PARTITION_NAME}${COLOR_RESET}: ${COLOR_GRAY}${PROPERTY_TAG}${COLOR_RESET} (Nothing to delete)"
        fi

    elif grep -q "^${PROPERTY_TAG}=" "$TEMP_PROP_FILE"; then
        sed -i "s|^${PROPERTY_TAG}=.*|${PROPERTY_TAG}=${PROPERTY_VALUE}|" "$TEMP_PROP_FILE"
        LOG_INFO "Updated property in ${COLOR_YELLOW}${PARTITION_NAME}${COLOR_RESET}: ${COLOR_CYAN}${PROPERTY_TAG}${COLOR_RESET}=${COLOR_GREEN}${PROPERTY_VALUE}${COLOR_RESET}"

    else
        local INSERT_CONTENT=""

        if ! grep -Fq "$ARCADEROM_MARKER" "$TEMP_PROP_FILE"; then
            INSERT_CONTENT="${ARCADEROM_MARKER}\n"
        fi

        INSERT_CONTENT="${INSERT_CONTENT}${PROPERTY_TAG}=${PROPERTY_VALUE}"

        if grep -Fq "$END_OF_FILE_MARKER" "$TEMP_PROP_FILE"; then
            local ESCAPED_MARKER
            ESCAPED_MARKER=$(echo "$END_OF_FILE_MARKER" | sed 's/[]\/$*.^[]/\\&/g')
            sed -i "/$ESCAPED_MARKER/i $INSERT_CONTENT" "$TEMP_PROP_FILE"
        else
            echo -e "$INSERT_CONTENT" >> "$TEMP_PROP_FILE"
        fi

        LOG_INFO "Added new property to ${COLOR_YELLOW}${PARTITION_NAME}${COLOR_RESET}: ${COLOR_CYAN}${PROPERTY_TAG}${COLOR_RESET}=${COLOR_GREEN}${PROPERTY_VALUE}${COLOR_RESET}"
    fi

    if ! mv -f "$TEMP_PROP_FILE" "$RESOLVED_PROP_FILE"; then
        rm -f "$TEMP_PROP_FILE"
        ERROR_EXIT "Failed to write changes to $RESOLVED_PROP_FILE"
        return 1
    fi
}

BPROP_IF_DIFF()
{
    local SOURCE_FIRMWARE_TYPE="$1"
    local SOURCE_PARTITION_NAME="$2"
    local PROPERTY_TAG="$3"
    local TARGET_PARTITION_NAME="${4:-$SOURCE_PARTITION_NAME}"

    local SOURCE_FIRMWARE_DIR
    SOURCE_FIRMWARE_DIR=$(GET_FW_DIR "$SOURCE_FIRMWARE_TYPE") || return 1

    local SOURCE_PROP_FILE_PATH
    SOURCE_PROP_FILE_PATH=$(RESOLVE_PROP_FILE "$SOURCE_FIRMWARE_DIR" "$SOURCE_PARTITION_NAME")

    if [[ -z "$SOURCE_PROP_FILE_PATH" ]]; then
        LOG_WARN "Source prop file not found for partition '${COLOR_YELLOW}${SOURCE_PARTITION_NAME}${COLOR_RESET}' in '${SOURCE_FIRMWARE_TYPE}'."
        return 0
    fi

    local PROPERTY_VALUE
    PROPERTY_VALUE=$(grep -m 1 -E "^${PROPERTY_TAG}=" "$SOURCE_PROP_FILE_PATH" | cut -d '=' -f2- | tr -d '\r')

    if [[ -z "$PROPERTY_VALUE" ]]; then
        LOG_WARN "Property '${COLOR_CYAN}${PROPERTY_TAG}${COLOR_RESET}' not found in '${SOURCE_PROP_FILE_PATH}'."
        return 0
    fi

    BPROP "$TARGET_PARTITION_NAME" "$PROPERTY_TAG" "$PROPERTY_VALUE"
}

GET_PROP()
{
    local PARTITION_NAME="$1"
    local PROPERTY_NAME="$2"
    local SOURCE_FIRMWARE_TYPE="${3:-}"

    local RESOLVED_PROP_FILE
    if [[ -n "$SOURCE_FIRMWARE_TYPE" ]]; then
        local FIRMWARE_WORKSPACE_PATH
        FIRMWARE_WORKSPACE_PATH=$(GET_FW_DIR "$SOURCE_FIRMWARE_TYPE") || return 1
        RESOLVED_PROP_FILE=$(RESOLVE_PROP_FILE "$FIRMWARE_WORKSPACE_PATH" "$PARTITION_NAME") || return 1
    else
        RESOLVED_PROP_FILE=$(RESOLVE_PROP_FILE "$WORKSPACE" "$PARTITION_NAME")
        [[ -z "$RESOLVED_PROP_FILE" ]] && return 1
    fi

    if ! grep -q "^${PROPERTY_NAME}=" "$RESOLVED_PROP_FILE"; then
        return 1
    fi

    grep "^${PROPERTY_NAME}=" "$RESOLVED_PROP_FILE" | cut -d'=' -f2- | tr -d '\r'
}
# ]
