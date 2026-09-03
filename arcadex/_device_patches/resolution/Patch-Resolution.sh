
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
