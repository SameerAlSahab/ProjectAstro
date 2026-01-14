
# NOTE This is not completed yet.

# Basic 
FF "SETTINGS_CONFIG_BRAND_NAME" "$MODEL_NAME"
FF "CONFIG_SIOP_POLICY_FILENAME" "$SIOP_POLICY_NAME"
BPROP "system" "ro.factory.model" "$STOCK_MODEL"
##



local FF_FILE="$WORKSPACE/system/system/etc/floating_feature.xml"
local STOCK_FF_FILE="$STOCK_FW/system/system/etc/floating_feature.xml"


## Camera
# Other Device based camera fixes can be found on objectives and platform folder
REMOVE "system" "cameradata/portrait_data"
BPROP "system" "ro.product.system.name" "$CODENAME"
REMOVE "system" "cameradata/singletake"

# Add from stock
ADD_FROM_FW "stock" "system" "cameradata"

# Remove source camera props and add stock only
xmlstarlet ed -L -d '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' "$FF_FILE"

if [[ ! -f "$STOCK_FF_FILE" ]]; then
    ERROR_EXIT "Stock floating_feature.xml not found"
    return 1
fi


xmlstarlet sel -t \
    -m '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' \
    -v 'name()' -o '=' -v '.' -n \
    "$STOCK_FF_FILE" | while IFS='=' read -r tag value; do
        [[ -z "$tag" ]] && continue
        FF "$tag" "$value"
    done
##


# SPen
AIR_COMMAND_PKGS=(
    "AirCommand"
    "AirGlance"
    "AirReadingGlass"
    "SmartEye"
)

AIR_COMMAND_FILES=(
    "etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    "etc/sysconfig/airviewdictionaryservice.xml"
    "media/audio/pensounds"
)


if [[ "$DEVICE_HAVE_SPEN_SUPPORT" == "true" ]] && EXISTS "system" "priv-app/AirCommand"; then
    LOG_INFO "Device and source both have SPen support. Ignoring..."

elif [[ "$DEVICE_HAVE_SPEN_SUPPORT" == "false" ]] && EXISTS "system" "priv-app/AirCommand"; then
    LOG_INFO "Device has no SPen but Source does. Removing bloat..."
    
    # Remove Packages
    SILENT NUKE_BLOAT "${AIR_COMMAND_PKGS[@]}"
    
    # Remove Permission Files and Sounds
    for file in "${AIR_COMMAND_FILES[@]}"; do
        REMOVE "system" "$file"
    done
    
    FF "SUPPORT_EAGLE_EYE" ""

elif [[ "$DEVICE_HAVE_SPEN_SUPPORT" == "true" ]] && ! EXISTS "system" "priv-app/AirCommand"; then
    LOG_INFO "Device has SPen but Source does not. Adding from Firmware..."

  
    for pkg in "${AIR_COMMAND_PKGS[@]}"; do
        ADD_FROM_FW "pa3q" "system" "priv-app/$pkg"
    done


    for file in "${AIR_COMMAND_FILES[@]}"; do
        ADD_FROM_FW "pa3q" "system" "$file"
    done

    FF "SUPPORT_EAGLE_EYE" "TRUE"

else
    : 
fi

##

##

# QHD and FHD displays
# TODO: Modify HFR mode on SecSettings and framework otherwise refresh rate control will be broken
# TODO: Add framework and surfaceflinger patches too in future 

if [[ "$DEVICE_HAVE_QHD_PANEL" == "true" ]]; then

    if grep -q "QHD" "$FF_FILE"; then
        LOG_INFO "Device and source both have QHD res. Ignoring..."
    else
        LOG_INFO "Enabling QHD Support (Adding QHD Resolution support)..."
        FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" "WQHD,FHD,HD"
        
        # Add high-res Settings app from pa3q
        ADD_FROM_FW "pa3q" "system" "priv-app/SecSettings"
    fi

else  
    LOG_INFO "Device does not support QHD. Disabling QHD features..."
    
    FF "SEC_FLOATING_FEATURE_COMMON_CONFIG_DYN_RESOLUTION_CONTROL" ""
    # Replace Settings app with non-QHD version from dm1q
    ADD_FROM_FW "dm1q" "system" "priv-app/SecSettings"
fi


##


# High Refresh rate displays
# TODO: Edit SecSettings resolution string for actual hz 
# TODO: Add  logic to remove high refresh rate option
# TODO As timer ms can vary upon devices , i will move them to platform for specific numbers. As of now kept this.
FRAMERATE_OVERRIDE=$(GET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override")

if [[ "$DEVICE_HAVE_HIGH_REFRESH_RATE" == "true" ]] && [[ "$FRAMERATE_OVERRIDE" != "true" ]]; then

    LOG_INFO "Adding Adaptive Refresh rate"
    BPROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    BPROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    BPROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"
    BPROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "250"
    BPROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "300"
    BPROP "vendor" "ro.surface_flinger.set_display_power_timer_ms" "200"
    BPROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"

    # it is incomplete , required framework patches , will add soon
    if [[ -n "$DEVICE_DISPLAY_HFR_MODE" ]] && [[ -n "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ" ]]; then
        FF "LCD_CONFIG_HFR_MODE" "$DEVICE_DISPLAY_HFR_MODE"
        FF "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE" "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ"
    fi
fi

##


