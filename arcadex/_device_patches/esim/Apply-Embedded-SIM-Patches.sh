
if ! GET_FEATURE DEVICE_USE_STOCK_BASE; then
    if GET_FEATURE SOURCE_HAVE_ESIM_SUPPORT; then
        if GET_FEATURE DEVICE_HAVE_ESIM_SUPPORT; then
        LOG_END "No eSIM changes required"
    else
        LOG_BEGIN "Device does NOT support eSIM, removing blobs"
            NUKE_BLOAT "EsimKeyString" "EuiccService"

            REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml"
            REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.euicc.xml"
            REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml"
            REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml"

            FF "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH" ""
        LOG_END "eSIM blobs removed"
        fi
    else
        if GET_FEATURE DEVICE_HAVE_ESIM_SUPPORT; then
        LOG_BEGIN "Device supports eSIM, adding blobs"

    ADD_FROM_FW "pa3q" "system" "priv-app/EsimKeyString"
    ADD_FROM_FW "pa3q" "system" "priv-app/EuiccService"

    ADD_FROM_FW "pa3q" "system" "etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml"
    ADD_FROM_FW "pa3q" "system" "etc/permissions/privapp-permissions-com.samsung.euicc.xml"
    ADD_FROM_FW "pa3q" "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml"
    ADD_FROM_FW "pa3q" "system" "etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml"

    FF_IF_DIFF "stock" "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH"

        LOG_END "eSIM blobs added"
    else
        LOG_END "No eSIM changes required"
        fi
    fi
fi
