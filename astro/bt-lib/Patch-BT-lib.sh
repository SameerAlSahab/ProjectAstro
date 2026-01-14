
BT_LIB_PATCH() {
APEX_FILE=$(find "$WORKSPACE/system/system/apex" -name "com.android.bt*.apex" | head -1)
if [[ -n "$APEX_FILE" ]]; then
    APEX_REL="${APEX_FILE#$WORKSPACE/}"
    EXTRACT_FROM_APEX_PAYLOAD "$APEX_REL" \
        "lib64/libbluetooth_jni.so" \
        "system/system/lib64/libbluetooth_jni.so"
else
    ERROR_EXIT "No Bluetooth APEX found"
fi

SDK_VERSION="$(GET_PROP "system" "ro.build.version.sdk")"



case "$SDK_VERSION" in
    33)
        HEX_EDIT "system/system/lib64/libbluetooth_jni.so" \
            "6804003528008052" "2a00001428008052"
        ;;
    34)
        HEX_EDIT "system/system/lib64/libbluetooth_jni.so" \
            "6804003528008052" "2b00001428008052"
        ;;
    35)
        HEX_EDIT "system/system/lib64/libbluetooth_jni.so" \
            "480500352800805228" "530100142800805228"
        ;;
    36)
        HEX_EDIT "system/system/lib64/libbluetooth_jni.so" \
            "00122a0140395f01086b00020054" "00122a0140395f01086bde030014"
        ;;
    *)
        LOG_WARN "Unknown API level ($SDK_VERSION)"
        ;;
esac

BPROP "system" "ro.security.bt.ver" ""
BPROP "system" "ro.security.bt.release" ""

}


if ! EXISTS "system" "lib64/libbluetooth_jni.so"; then


LOG_BEGIN "Applying bluetooth patches for forget issue"

if ! BT_LIB_PATCH; then
  ERROR_EXIT "Cannot apply bluetooth patches."
fi

LOG_END "Bluetooth device forget patch applied successfully"

fi
