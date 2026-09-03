# ==============================================================================
#
# MOD_NAME="Target devices patches"
# MOD_AUTHOR="Salvo Giangreco , ExtremeXT , ShaDisNX255"
# MOD_DESC="Apply device related features on source firmware."
#
# ==============================================================================

# NOTE This is not completed yet.

# Set target model name
FF_IF_DIFF "stock" "SETTINGS_CONFIG_BRAND_NAME"
FF_IF_DIFF "stock" "SYSTEM_CONFIG_SIOP_POLICY_FILENAME"

BPROP "system" "ro.product.system.model" "$DEVICE_MODEL"
BPROP "system" "ro.product.product.model" "$DEVICE_MODEL"

ARCADE_CODENAME="$(GET_PROP "system" "ro.product.system.name" "stock")"

if [[ -n "$ARCADE_CODENAME" ]]; then
    BPROP "system" "ro.arcade.codename" "$ARCADE_CODENAME"
else
    BPROP "system" "ro.arcade.codename" "$CODENAME"
fi

# Set source model as new prop
BPROP "system" "ro.product.arcade.model" "$DEVICE_MODEL"

# Edge lighting target corner radius
BPROP "system" "ro.factory.model" "$DEVICE_MODEL"

# Display
FF_IF_DIFF "stock" "COMMON_CONFIG_MDNIE_MODE"
FF_IF_DIFF "stock" "LCD_SUPPORT_AMOLED_DISPLAY"

# Netflix props
BPROP_IF_DIFF "stock" "system" "ro.netflix.bsp_rev"
