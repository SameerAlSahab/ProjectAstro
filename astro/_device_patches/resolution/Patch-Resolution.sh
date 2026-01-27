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




if GET_FEATURE DEVICE_HAVE_QHD_PANEL; then
    if GET_FEATURE SOURCE_HAVE_QHD_PANEL; then
        LOG_INFO "Device and source both have QHD res. Ignoring..."
    else
        LOG_INFO "Enabling QHD resolution support ..."

        FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" "WQHD,FHD,HD"

        ADD_PATCH "SecSettings.apk" \
            "$SCRPATH/patches/Enable-QHD-Resolution-Settings.smalipatch"

        ADD_PATCH "framework.jar" \
            "$SCRPATH/patches/Enable-QHD-Resolution-Support.sh"

        ADD_FROM_FW "dm3q" "system" "bin/bootanimation"
        ADD_FROM_FW "dm3q" "system" "bin/surfaceflinger"

        ADD_FROM_FW "pa3q" "system" "framework/gamemanager.jar"
        ADD_PATCH "framework.jar" "$SCRPATH/patches/Add-Dynamic-Resolution-Control.sh"
    fi
else
    if GET_FEATURE SOURCE_HAVE_QHD_PANEL; then
        LOG_INFO "Source has QHD but device does not. Removing QHD features..."

        FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" ""

        ADD_PATCH "SecSettings.apk" \
            "$SCRPATH/patches/Disable-QHD-Resolution-Settings.smalipatch"

        ADD_PATCH "framework.jar" \
            "$SCRPATH/patches/Disable-QHD-Resolution-Support.sh"

        ADD_FROM_FW "dm1q" "system" "bin/bootanimation"
        ADD_FROM_FW "dm1q" "system" "bin/surfaceflinger"
    else
        LOG_INFO "Device and source both do not support QHD res. Ignoring..."
    fi
fi
