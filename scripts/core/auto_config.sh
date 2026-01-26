#
# The following environment variables are automatically generated or
# consumed during device configuration generation.
#
# These variables describe hardware capabilities and firmware properties
# of the TARGET (stock) device.
#
# Unless explicitly overridden by a device configuration file, all values
# are detected automatically from the stock firmware and the given source firmware.
# If variables are already declared in config file , it will not overwrite them.
#

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


#
# ----------------------------------------------------------------------
#
#   DEVICE_DISPLAY_HFR_MODE
#     Integer describing the display High Frame Rate (HFR) mode supported
#     by the device panel.
#
#     A value greater than zero indicates that the display supports refresh
#     rates higher than 60Hz (e.g. 90Hz, 120Hz, or adaptive).
#
#     This value is usually read from floating_feature.xml and serves as the
#     base indicator for high refresh rate capability.
#
#
#   DEVICE_HAVE_HIGH_REFRESH_RATE
#     Boolean flag derived from DEVICE_DISPLAY_HFR_MODE.
#
#     Set to true when DEVICE_DISPLAY_HFR_MODE is greater than zero,
#     indicating that the device supports smooth / high refresh rate modes.
#
#     This variable is commonly used to enable or disable display-related
#     features such as adaptive refresh rate, smooth animations.
#
#   DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ
#     String containing a comma-separated list of refresh rates (in Hz)
#     supported by the device display.
#
#
#
#   DEVICE_DEFAULT_REFRESH_RATE
#     Integer specifying the default refresh rate (in Hz) selected by the
#     system at boot or after a factory reset.
#
#     This value does not restrict the maximum refresh rate but defines the
#     initial operating mode of the display.
#
#
#   DEVICE_HAVE_QHD_PANEL
#     Boolean flag indicating whether the device uses a QHD (1440p) display
#     panel.
#
#     The value is determined by scanning the stock floating_feature.xml
#     for QHD-related configuration entries.
#
#     This variable is used to adjust rendering scale, performance profiles,
#     and resolution-dependent system behavior.
#
#
#   DEVICE_HAVE_AMOLED_DISPLAY
#     Boolean flag indicating whether the device is equipped with an AMOLED
#     or OLED display panel.
#
#     This flag affects display color calibration, power optimizations, and
#     feature availability such as Always-On Display.
#
#
#   DEVICE_HAVE_DUAL_SPEAKER
#     Boolean flag describing the audio speaker configuration of the device.
#
#     Set to true when the device features a dual-speaker (stereo) setup,
#     otherwise false for single-speaker (mono) configurations.
#
#     Used by audio services and sound effect frameworks.
#
#
#   DEVICE_AUTO_BRIGHTNESS_LEVEL
#     Integer or enumerated value describing the auto-brightness control
#     behavior supported by the device.
#
#     This variable influences how the system reacts to ambient light
#     changes via sensor-based brightness adjustment.
#
#
#   DEVICE_HAVE_SPEN_SUPPORT
#     Boolean flag indicating Samsung S-Pen support.
#
#     Detection is based on the presence of the AirCommand system application
#     in the stock firmware.
#
#     When set to true, stylus-related frameworks and features are enabled.
#
#
#   DEVICE_HAVE_ESIM_SUPPORT
#     Boolean flag indicating embedded SIM (eSIM) support on the device.
#
#     Detection is based on the presence of eSIM-related system components
#     in the stock firmware.
#
#     When false, the device is assumed to support physical SIM cards only.
#
#
#   DEVICE_ANDROID_VERSION
#     String containing the Android version of the stock device firmware.
#
#
#
#   DEVICE_SDK_VERSION
#     Integer containing the Android SDK (API) level of the stock firmware.
#
#
#
#
#   DEVICE_VNDK_VERSION
#     Integer or string identifying the Vendor Native Development Kit (VNDK)
#     version used by the stock firmware.
#
#     This value is critical for maintaining compatibility between system
#     and vendor partitions under Project Treble.
#
# ----------------------------------------------------------------------


