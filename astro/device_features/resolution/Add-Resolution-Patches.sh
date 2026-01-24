
# QHD and FHD displays
# TODO: Modify HFR mode on SecSettings and framework otherwise refresh rate control will be broken
# TODO: Add framework and surfaceflinger patches too in future

if [[ "$DEVICE_HAVE_QHD_PANEL" == "true" ]]; then

    if grep -q "QHD" "$FF_FILE"; then
        LOG_INFO "Device and source both have QHD res. Ignoring..."
    else
        LOG_INFO "Enabling QHD resolution support ..."
        FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" "WQHD,FHD,HD"
        ADD_PATCH "SecSettings.apk" "$SCRPATH/patches/qhd"
    fi

else
    # Device does NOT support QHD
    if ! grep -q "QHD" "$FF_FILE"; then
        LOG_INFO "Device and source both do not support QHD res. Ignoring..."
    else
        LOG_INFO "Source has QHD but device does not. Removing QHD features..."

        FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" ""
        ADD_PATCH "SecSettings.apk" "$SCRPATH/patches/fhd"
    fi
fi
