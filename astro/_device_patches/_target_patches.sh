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
FF_IF_DIFF "stock" "SETTINGS_CONFIG_BRAND_NAME"
FF_IF_DIFF "stock" "SYSTEM_CONFIG_SIOP_POLICY_FILENAME"


ASTRO_CODENAME="$(GET_PROP "system" "ro.product.system.name" "stock")"

if [[ -n "$ASTRO_CODENAME" ]]; then
    BPROP "system" "ro.astro.codename" "$ASTRO_CODENAME"
 else
    BPROP "system" "ro.astro.codename" "$CODENAME"
fi


    # Set source model as new prop
    BPROP "system" "ro.product.astro.model" "$STOCK_MODEL"

    # Edge lighting target corner radius
    BPROP "system" "ro.factory.model" "$STOCK_MODEL"


# Display
FF_IF_DIFF "stock" "COMMON_CONFIG_MDNIE_MODE"
FF_IF_DIFF "stock" "LCD_SUPPORT_AMOLED_DISPLAY"



