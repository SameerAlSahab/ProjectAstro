# Thanks ExtremeXT for explaining that
#0 is 60Hz only
#1 is forced 60 or forced 120
#2 is adaptive between 60 and 120 depending on usage
#3 is adaptive with LTPO technology, between 1 and 120Hz


SMALI_FILE=$(find . -name "RefreshRateConfig.smali" 2>/dev/null | head -n1)
[ -z "$SMALI_FILE" ] && ERROR_EXIT "RefreshRateConfig.smali not found"




if [ "$SOURCE_DISPLAY_HFR_MODE" != "$DEVICE_DISPLAY_HFR_MODE" ]; then
    sed -i "/getMainInstance/,/createRefreshRateConfig/ {
        s/\"$SOURCE_DISPLAY_HFR_MODE\"/\"$DEVICE_DISPLAY_HFR_MODE\"/
    }" "$SMALI_FILE"

fi




if [ "$SOURCE_DISPLAY_REFRESH_RATE_VALUES_HZ" != "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ" ]; then

    sed -i "/getMainInstance/,/createRefreshRateConfig/ {
        s/\"$SOURCE_DISPLAY_REFRESH_RATE_VALUES_HZ\"/\"$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ\"/
    }" "$SMALI_FILE"

fi



