# https://github.com/salvogiangri/UN1CA/blob/sixteen/unica/patches/nfc/customize.sh

LOG_BEGIN "- Patching NFC using @salvogiangri's UN1CA patchset"

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci.conf" 0 0 644 "u:object_r:system_file:s0"
else
    REMOVE "system" "etc/libnfc-nci.conf"
fi
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci_temp.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci_temp.conf" 0 0 644 "u:object_r:system_file:s0"
else
    REMOVE "system" "etc/libnfc-nci_temp.conf"
fi
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-NXP_SN100U.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-NXP_SN100U.conf" 0 0 644 "u:object_r:system_file:s0"
fi
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-NXP_PN553.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-NXP_PN553.conf" 0 0 644 "u:object_r:system_file:s0"
fi
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-SLSI.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-SLSI.conf" 0 0 644 "u:object_r:system_file:s0"
fi
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-STM_ST21.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-STM_ST21.conf" 0 0 644 "u:object_r:system_file:s0"
fi

if [ "$(GET_PROP "vendor" "ro.vendor.nfc.feature.chipname")" ] && \
        ! [[ "$(GET_PROP "vendor" "ro.vendor.nfc.feature.chipname")" =~ NXP_SN100U|SLSI|STM_ST21 ]]; then
    ABORT "Unknown NFC chip name: $(GET_PROP "vendor" "ro.vendor.nfc.feature.chipname")"
fi

# SEC_PRODUCT_FEATURE_NFC_CHIP_NAME:=NXP_SN100U
# - API 35 and below: libnfc_nxpsn_jni.so
# - API 36: libnfc_nci_jni.so
if [ -f "$WORKSPACE/system/system/lib/libnfc_nci_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib/libnfc_nci_jni.so" ] && \
            [ ! -f "$STOCK_FW/system/system/lib64/libnfc_nxpsn_jni.so" ]; then
        REMOVE "system" "lib/libnfc_nci_jni.so"
        REMOVE "system" "lib/libnfc_prop_extn.so"
        REMOVE "system" "lib/libnfc_vendor_extn.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib/libnfc_nci_jni.so" ]; then
     ADD_FROM_FW "stock" "system" "lib/libnfc_nci_jni.so"
     ADD_FROM_FW "stock" "system" "lib/libnfc_prop_extn.so"
     ADD_FROM_FW "stock" "system" "lib/libnfc_vendor_extn.so"
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_nxpsn_jni.so" ]; then
    # TODO
    ABORT "Missing prebuilt blobs for NXP_SN100U NFC chip"
fi
if [ -f "$WORKSPACE/system/system/lib64/libnfc_nci_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib64/libnfc_nci_jni.so" ] && \
            [ ! -f "$STOCK_FW/system/system/lib64/libnfc_nxpsn_jni.so" ]; then
        REMOVE "system" "lib64/libnfc_nci_jni.so"
        REMOVE "system" "lib64/libnfc_prop_extn.so"
        REMOVE "system" "lib64/libnfc_vendor_extn.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_nci_jni.so" ]; then
     ADD_FROM_FW "stock" "system" "lib64/libnfc_nci_jni.so"
     ADD_FROM_FW "stock" "system" "lib64/libnfc_prop_extn.so"
     ADD_FROM_FW "stock" "system" "lib64/libnfc_vendor_extn.so"
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_nxpsn_jni.so" ]; then
    # TODO
    ABORT "Missing prebuilt blobs for NXP_SN100U NFC chip"
fi

# SEC_PRODUCT_FEATURE_NFC_CHIP_NAME:=STM_ST21
# - API 35 and below: libnfc_st_jni.so
# - API 36: libstnfc_nci_jni.so
if [ -f "$WORKSPACE/system/system/lib/libstnfc_nci_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib/libstnfc_nci_jni.so" ] && \
            [ ! -f "$STOCK_FW/system/system/lib64/libnfc_st_jni.so" ]; then
        REMOVE "system" "lib/libnfc_vendor_extn_st.so"
        REMOVE "system" "lib/libstnfc_nci_jni.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib/libstnfc_nci_jni.so" ]; then
     ADD_FROM_FW "stock" "system" "lib/libnfc_vendor_extn_st.so"
     ADD_FROM_FW "stock" "system" "lib/libstnfc_nci_jni.so"
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_st_jni.so" ]; then
     ADD_FROM_FW "a17" "system" "lib/libnfc_vendor_extn_st.so"
     ADD_FROM_FW "a17" "system" "lib/libstnfc_nci_jni.so"
fi
if [ -f "$WORKSPACE/system/system/lib64/libstnfc_nci_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib64/libstnfc_nci_jni.so" ] && \
            [ ! -f "$STOCK_FW/system/system/lib64/libnfc_st_jni.so" ]; then
        REMOVE "system" "lib64/libnfc_vendor_extn_st.so"
        REMOVE "system" "lib64/libstnfc_nci_jni.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib64/libstnfc_nci_jni.so" ]; then
     ADD_FROM_FW "stock" "system" "lib64/libnfc_vendor_extn_st.so"
     ADD_FROM_FW "stock" "system" "lib64/libstnfc_nci_jni.so"
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_st_jni.so" ]; then
     ADD_FROM_FW "a17" "system" "lib64/libnfc_vendor_extn_st.so"
     ADD_FROM_FW "a17" "system" "lib64/libstnfc_nci_jni.so"
fi

# SEC_PRODUCT_FEATURE_NFC_CHIP_NAME:=SLSI
# - Same lib name as before, check for DEVICE_VNDK_VERSION instead
if [ -f "$WORKSPACE/system/system/lib/libnfc_sec_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib/libnfc_sec_jni.so" ] && \
            [ ! -f "$STOCK_FW/system/system/lib64/libnfc_sec_jni.so" ]; then
        REMOVE "system" "lib/libnfc_sec_jni.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib/libnfc_sec_jni.so" ] || \
        [ -f "$STOCK_FW/system/system/lib64/libnfc_sec_jni.so" ]; then
    if [ "$DEVICE_VNDK_VERSION" -ge "36" ]; then
        ADD_FROM_FW "stock" "system" "lib/libnfc_sec_jni.so"
    else
        ADD_FROM_FW "r11s" "system" "lib/libnfc_sec_jni.so"
    fi
fi
if [ -f "$WORKSPACE/system/system/lib64/libnfc_sec_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib64/libnfc_sec_jni.so" ]; then
        REMOVE "system" "lib64/libnfc_sec_jni.so"
    fi
elif [ -f "$STOCK_FW/system/system/lib64/libnfc_sec_jni.so" ]; then
    if [ "$DEVICE_VNDK_VERSION" -ge "36" ]; then
        ADD_FROM_FW "stock" "system" "lib64/libnfc_sec_jni.so"
    else
        ADD_FROM_FW "r11s" "system" "lib64/libnfc_sec_jni.so"
    fi
fi

LOG_END