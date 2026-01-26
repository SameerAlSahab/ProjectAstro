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


if ! find "$OBJECTIVE" -type f -name "camera-feature*.xml" | grep -q .; then
FF_FILE="$WORKSPACE/system/system/etc/floating_feature.xml"
STOCK_FF_FILE="$STOCK_FW/system/system/etc/floating_feature.xml"


# Other Device based camera fixes can be found on objectives and platform folder
REMOVE "system" "cameradata/portrait_data"
REMOVE "system" "cameradata/singletake"

LOG_INFO "Adding stock camera properties.."
ADD_FROM_FW "stock" "system" "cameradata"

# Remove source camera props and add stock only
xmlstarlet ed -L -d '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' "$FF_FILE"


xmlstarlet sel -t \
    -m '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' \
    -v 'name()' -o '=' -v '.' -n \
    "$STOCK_FF_FILE" | while IFS='=' read -r tag value; do
        [[ -z "$tag" ]] && continue
        SILENT FF "$tag" "$value"
    done


BPROP_IF_DIFF "stock" "system" "ro.build.flavor" "system"
fi

PATCH_CAMERA_LIBS() {
    local SYSTEM="$WORKSPACE/system/system"
    local LIB_DIRS=(
        "$SYSTEM/lib"
        "$SYSTEM/lib64"
    )

    local FILES

    FILES=$(grep -Il "ro.product.name" \
        $(find "${LIB_DIRS[@]}" -type f -iname "*.so" \
            \( -iname "*camera*" -o -iname "*livefocus*" -o -iname "*bokeh*" \)) \
        2>/dev/null
    )

    [[ -z "$FILES" ]] && return 0

    while IFS= read -r FILE; do
        sed -i "s/ro.product.name/ro.astro.codename/g" "$FILE"
        LOG_INFO "Patched camera library ${FILE#$WORKSPACE/}"
    done <<< "$FILES"
}

LOG_INFO "Patching camera for portrait mode.."

PATCH_CAMERA_LIBS
