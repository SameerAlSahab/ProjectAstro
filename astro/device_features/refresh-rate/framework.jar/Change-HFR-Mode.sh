# Thanks ExtremeXT for explaining me that


#0 is 60Hz only
#1 is forced 60 or forced 120
#2 is adaptive between 60 and 120 depending on usage
#3 is adaptive with LTPO technology, between 1 and 120Hz

# TODO: Add SecSettings HFR in CoreRune too soon

if [ -n "$DEVICE_DISPLAY_HFR_MODE" ]; then
    TARGET_HFR="$DEVICE_DISPLAY_HFR_MODE"
else
    TARGET_HFR=$(GET_FF_VAL "stock" "LCD_CONFIG_HFR_MODE")
fi



SMALI_FILE=$(find . -name "RefreshRateConfig.smali" 2>/dev/null | head -n1)
[ -z "$SMALI_FILE" ] && ERROR_EXIT "RefreshRateConfig.smali not found"


SOURCE_HFR=$(GET_FF_VAL "LCD_CONFIG_HFR_MODE")
[ -z "$SOURCE_HFR" ] && ERROR_EXIT "Failed to detect source HFR from smali"



if [ "$SOURCE_HFR" != "$TARGET_HFR" ]; then
    sed -i "/getMainInstance/,/createRefreshRateConfig/ {
        s/\"$SOURCE_HFR\"/\"$TARGET_HFR\"/
    }" "$SMALI_FILE"

else
    LOG_INFO "Skipping Refresh rate HFR Patch"
fi



# Refresh Rate Values
if [ -n "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ" ]; then
    TARGET_RATES="$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ"
else
    TARGET_RATES=$(GET_FF_VAL "stock" "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE")
fi

# Common format
echo "$TARGET_RATES" | grep -Eq '^[0-9]+(,[0-9]+)*$' \
    || ERROR_EXIT "Invalid refresh-rate format: $TARGET_RATES"

# Ensure 60Hz is included as its universal
echo "$TARGET_RATES" | grep -q '\b60\b' \
    || ERROR_EXIT "Refresh-rate list must include 60Hz"

SOURCE_RATES=$(GET_FF_VAL "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE")
[ -z "$SOURCE_RATES" ] && ERROR_EXIT "Failed to fetch source refresh rates values"

if [ "$SOURCE_RATES" != "$TARGET_RATES" ]; then

    sed -i "/getMainInstance/,/createRefreshRateConfig/ {
        s/\"$SOURCE_RATES_ESCAPED\"/\"$TARGET_RATES_ESCAPED\"/
    }" "$SMALI_FILE"

fi



