GENERATE_CONFIG() {
    # Usage: "XML_TAG_NAME" or "XML_TAG_NAME:CUSTOM_VARIABLE_SUFFIX"
    local FLOATING_FEATURE_VALUES=(
        "LCD_CONFIG_HFR_MODE:DISPLAY_HFR_MODE"
        "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH"
        "COMMON_CONFIG_MDNIE_MODE:MDNIE_MODE"
        "LCD_SUPPORT_AMOLED_DISPLAY:HAVE_AMOLED_DISPLAY"
        "AUDIO_SUPPORT_DUAL_SPEAKER:HAVE_DUAL_SPEAKER"
        "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE:DISPLAY_REFRESH_RATE_VALUES_HZ"
        "LCD_CONFIG_CONTROL_AUTO_BRIGHTNESS:AUTO_BRIGHTNESS_LEVEL"
        "LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE:DEFAULT_REFRESH_RATE"
    )

    local entry
    local tag
    local custom_suffix
    local val_source
    local val_device
    local var_name_source
    local var_name_device

    for entry in "${FLOATING_FEATURE_VALUES[@]}"; do
        # Split string by ':' delimiter.
        tag="${entry%%:*}"

        if [[ "$entry" == *":"* ]]; then
            custom_suffix="${entry#*:}"
        else
            custom_suffix="$tag"
        fi


        var_name_source="SOURCE_${custom_suffix}"
        var_name_device="DEVICE_${custom_suffix}"


        if [[ -n "${!var_name_source}" ]]; then
            val_source="${!var_name_source}"
        else
            val_source=$(GET_FF_VAL "main" "$tag")
        fi

        if [[ -z "$val_source" ]]; then
            ERROR_EXIT "Floating Feature '${tag}' missing in source firmware. Please add variable: ${var_name_source}=\"value\" to objectives/$CODENAME/$CODENAME.sh. Use blank "" as value if unavailable."
        fi


        if [[ -n "${!var_name_device}" ]]; then
            val_device="${!var_name_device}"
        else
            val_device=$(GET_FF_VAL "stock" "$tag")
        fi

        if [[ -z "$val_device" ]]; then
            ERROR_EXIT "Floating Feature '${tag}' missing in target firmware. Please add variable: ${var_name_device}=\"value\" to objectives/$CODENAME/$CODENAME.sh. Use blank "" as value if unavailable."
        fi


        if [[ "$val_source" == "TRUE" ]]; then val_source="true"; fi
        if [[ "$val_source" == "FALSE" ]]; then val_source="false"; fi

        if [[ "$val_device" == "TRUE" ]]; then val_device="true"; fi
        if [[ "$val_device" == "FALSE" ]]; then val_device="false"; fi


        declare -g "$var_name_source"="$val_source"
        declare -g "$var_name_device"="$val_device"

        LOG "Mapped $tag -> $var_name_source = $val_source"
    done

        if [[ -n "$DEVICE_ACTUAL_MODEL" ]]; then
    STOCK_MODEL="$DEVICE_ACTUAL_MODEL"
}
