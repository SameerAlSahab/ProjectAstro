BT_LIB_PATCH() {
    local APEX_FILE APEX_REL SDK_VERSION PATCH_APPLIED=false
    local LIB_PATH="system/system/lib64/libbluetooth_jni.so"


    APEX_FILE=$(find "$WORKSPACE/system/system/apex" -name "com.android.bt*.apex" 2>/dev/null | head -n1)
    [[ -z "$APEX_FILE" ]] && ERROR_EXIT "No Bluetooth APEX found"

    APEX_REL="${APEX_FILE#$WORKSPACE/}"


    EXTRACT_FROM_APEX_PAYLOAD "$APEX_REL" \
        "lib64/libbluetooth_jni.so" \
        "$LIB_PATH"


    [[ ! -f "$WORKSPACE/$LIB_PATH" ]] && ERROR_EXIT "Bluetooth JNI library not extracted"

    SDK_VERSION="$(GET_PROP "system" "ro.build.version.sdk")"

    LOG_INFO "Detected SDK version: $SDK_VERSION"

    case "$SDK_VERSION" in
        33)
            HEX_EDIT "$LIB_PATH" \
                "6804003528008052" \
                "2a00001428008052" \
                && PATCH_APPLIED=true
            ;;
        34)
            HEX_EDIT "$LIB_PATH" \
                "6804003528008052" \
                "2b00001428008052" \
                && PATCH_APPLIED=true
            ;;
        35)
            HEX_EDIT "$LIB_PATH" \
                "480500352800805228" \
                "530100142800805228" \
                && PATCH_APPLIED=true
            ;;
        36)
            if xxd -p -c 0 "$WORKSPACE/$LIB_PATH" | grep -q "2897773948050037"; then
                HEX_EDIT "$LIB_PATH" \
                    "2897773948050037" \
                    "289777392a000014" \
                    && PATCH_APPLIED=true
            elif xxd -p -c 0 "$WORKSPACE/$LIB_PATH" | grep -q "183a009048050037"; then
                HEX_EDIT "$LIB_PATH" \
                    "183a009048050037" \
                    "183a00902a000014" \
                    && PATCH_APPLIED=true
            fi
            ;;
        *)
            ERROR_EXIT "Unsupported SDK version: $SDK_VERSION"
            ;;
    esac

    [[ "$PATCH_APPLIED" != true ]] && \
        ERROR_EXIT "No patch available for Bluetooth library (SDK $SDK_VERSION)"
    return 0
}



if ! EXISTS "system" "lib64/libbluetooth_jni.so"; then
    LOG_BEGIN "Applying Bluetooth library patch"

    BT_LIB_PATCH || ERROR_EXIT "Bluetooth patching failed"

    LOG_END "Bluetooth library patch applied successfully"
fi
