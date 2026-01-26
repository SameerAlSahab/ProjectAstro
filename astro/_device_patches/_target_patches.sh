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



# NOTE This is not completed yet.

# Set target model name
FF "SETTINGS_CONFIG_BRAND_NAME" "$MODEL_NAME"
FF "SYSTEM_CONFIG_SIOP_POLICY_FILENAME" "$SIOP_POLICY_NAME"


ASTRO_CODENAME="$(GET_PROP "system" "ro.product.system.name" "stock")"

if [[ -n "$ASTRO_CODENAME" ]]; then
    BPROP "system" "ro.astro.codename" "$ASTRO_CODENAME"
 else
    BPROP "system" "ro.astro.codename" "$CODENAME"
fi


if [[ "$MODEL" == "$STOCK_MODEL" ]]; then
    if GET_FEATURE DEVICE_HAVE_QHD_PANEL; then
     ADD_PATCH "framework.jar" "$SCRPATH/resolution/patches/Add-Dynamic-Resolution-Control.sh"
     ADD_FROM_FW "pa3q" "system" "framework/gamemanager.jar"
    fi

else
    for f in */*.sh; do [ -f "$f" ] && source "$f"; done
    # Set source model as new prop
    BPROP "system" "ro.product.astro.model" "$STOCK_MODEL"

    # Edge lighting target corner radius
    BPROP "system" "ro.factory.model" "$STOCK_MODEL"
fi





