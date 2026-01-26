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

# TODO: Add stock floating feature values like pen version etc

AIR_COMMAND_PKGS=(
    "AirCommand"
    "AirGlance"
    "AirReadingGlass"
    "SmartEye"
)

AIR_COMMAND_FILES=(
    "etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    "etc/sysconfig/airviewdictionaryservice.xml"
    "media/audio/pensounds"
)

SOURCE_HAS_SPEN=false
GET_FEATURE SOURCE_HAVE_SPEN_SUPPORT && SOURCE_HAS_SPEN=true

DEVICE_HAS_SPEN=false
GET_FEATURE DEVICE_HAVE_SPEN_SUPPORT && DEVICE_HAS_SPEN=true



if $DEVICE_HAS_SPEN && $SOURCE_HAS_SPEN; then
    LOG_INFO "Device and source both support SPen. Ignoring.."

elif ! $DEVICE_HAS_SPEN && $SOURCE_HAS_SPEN; then
    LOG_INFO "Removing SPen components..."

    NUKE_BLOAT "${AIR_COMMAND_PKGS[@]}"

    for file in "${AIR_COMMAND_FILES[@]}"; do
        REMOVE "system" "$file"
    done

    FF "SUPPORT_EAGLE_EYE" ""

elif $DEVICE_HAS_SPEN && ! $SOURCE_HAS_SPEN; then
    LOG_INFO "Device supports SPen, source does not. Adding..."

    for pkg in "${AIR_COMMAND_PKGS[@]}"; do
        ADD_FROM_FW "pa3q" "system" "priv-app/$pkg"
    done

    for file in "${AIR_COMMAND_FILES[@]}"; do
        ADD_FROM_FW "pa3q" "system" "$file"
    done


    FF "SUPPORT_EAGLE_EYE" "TRUE"

else
    LOG_INFO "Device and source both lack SPen support. Nothing to do."
fi
