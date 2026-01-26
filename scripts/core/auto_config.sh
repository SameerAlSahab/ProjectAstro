GENERATE_CONFIG() {
    # Format: "XML_TAG_NAME" or "XML_TAG_NAME:CUSTOM_VAR_SUFFIX"
    local CONFIG_FEATURES=(
        "LCD_CONFIG_HFR_MODE:DISPLAY_HFR_MODE"
        "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH"
        "COMMON_CONFIG_MDNIE_MODE:MDNIE_MODE"
        "LCD_SUPPORT_AMOLED_DISPLAY:HAVE_AMOLED_DISPLAY"
        "AUDIO_SUPPORT_DUAL_SPEAKER:HAVE_DUAL_SPEAKER"
        "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE:DISPLAY_REFRESH_RATE_VALUES_HZ"
        "LCD_CONFIG_CONTROL_AUTO_BRIGHTNESS:AUTO_BRIGHTNESS_LEVEL"
        "LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE:DEFAULT_REFRESH_RATE"
    )


    # Format: "partition:property_name:CUSTOM_VAR_SUFFIX"
    local CONFIG_PROPS=(
        "vendor:ro.vendor.build.version.release:ANDROID_VERSION"
        "vendor:ro.vendor.build.version.sdk:SDK_VERSION"
        "vendor:ro.vndk.version:VNDK_VERSION"
    )

   # Format: "partition:path/to/file:CUSTOM_VAR_SUFFIX"
    local CONFIG_FILES=(
        "system:priv-app/AirCommand:HAVE_SPEN_SUPPORT"
        "system:priv-app/EsimKeyString:HAVE_ESIM_SUPPORT"
    )



    local entry part key suffix
    local var_source var_device val_source val_device
    local src_dir stock_dir

    for entry in "${CONFIG_FEATURES[@]}"; do
        key="${entry%%:*}"
        suffix="${entry#*:}"
        [[ "$entry" != *":"* ]] && suffix="$key"

        var_source="SOURCE_${suffix}"
        var_device="DEVICE_${suffix}"

        if [[ -z "${!var_source}" ]]; then
            val_source=$(GET_FF_VAL "main" "$key")
            # Convert Booleans
            [[ "$val_source" == "TRUE" ]] && val_source="true"
            [[ "$val_source" == "FALSE" ]] && val_source="false"
            declare -g "$var_source"="$val_source"
        fi


        if [[ -z "${!var_device}" ]]; then
            val_device=$(GET_FF_VAL "stock" "$key")
            # Convert Booleans
            [[ "$val_device" == "TRUE" ]] && val_device="true"
            [[ "$val_device" == "FALSE" ]] && val_device="false"
            declare -g "$var_device"="$val_device"
        fi


    done


    for entry in "${CONFIG_PROPS[@]}"; do
        part=$(echo "$entry" | cut -d':' -f1)
        key=$(echo "$entry" | cut -d':' -f2)
        suffix=$(echo "$entry" | cut -d':' -f3)

        var_source="SOURCE_${suffix}"
        var_device="DEVICE_${suffix}"

        if [[ -z "${!var_source}" ]]; then
            val_source=$(GET_PROP "$part" "$key")
            declare -g "$var_source"="$val_source"
        fi

        if [[ -z "${!var_device}" ]]; then
            val_device=$(GET_PROP "$part" "$key" "stock")
            declare -g "$var_device"="$val_device"
        fi

    done


    local main_fw_dir=$(GET_FW_DIR "main")
    local stock_fw_dir="$WORKSPACE"

for entry in "${CONFIG_FILES[@]}"; do
    part="${entry%%:*}"
    key="${entry#*:}"
    key="${key%%:*}"
    suffix="${entry##*:}"

    [[ "$entry" != *":"* ]] && suffix="$key"

    var_source="SOURCE_${suffix}"
    var_device="DEVICE_${suffix}"

    if [[ -z "${!var_source}" ]]; then
        if EXISTS "main" "$part" "$key"; then
            declare -g "$var_source"="true"
        else
            declare -g "$var_source"="false"
        fi
    fi


    if [[ -z "${!var_device}" ]]; then
        if EXISTS "stock" "$part" "$key"; then
            declare -g "$var_device"="true"
        else
            declare -g "$var_device"="false"
        fi
    fi

done



    if [[ -n "$DEVICE_ACTUAL_MODEL" ]]; then
        STOCK_MODEL="$DEVICE_ACTUAL_MODEL"
    fi

export SEC_FLOATING_FEATURE_FILE="$WORKSPACE/system/system/etc/floating_feature.xml"
export STOCK_SEC_FLOATING_FEATURE_FILE="$STOCK_FW/system/system/etc/floating_feature.xml"


if [[ -z "${SOURCE_HAVE_QHD_PANEL+x}" ]]; then
    if grep -q "QHD" "$SEC_FLOATING_FEATURE_FILE"; then
        SOURCE_HAVE_QHD_PANEL=true
    else
        SOURCE_HAVE_QHD_PANEL=false
    fi
fi


if [[ -z "${DEVICE_HAVE_QHD_PANEL+x}" ]]; then
    if grep -q "QHD" "$STOCK_SEC_FLOATING_FEATURE_FILE"; then
        DEVICE_HAVE_QHD_PANEL=true
    else
        DEVICE_HAVE_QHD_PANEL=false
    fi
fi


if [[ -z "${DEVICE_HAVE_HIGH_REFRESH_RATE+x}" ]]; then
    if (( ${DEVICE_DISPLAY_HFR_MODE:-0} > 0 )); then
        DEVICE_HAVE_HIGH_REFRESH_RATE=true
    else
        DEVICE_HAVE_HIGH_REFRESH_RATE=false
    fi
fi

LOG_INFO "Automatic generated config-"

for var in $(compgen -v DEVICE_ | sort); do
    printf '  %s=%s\n' "$var" "${!var}"
done


}
