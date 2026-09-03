
if ! GET_FEATURE DEVICE_USE_STOCK_BASE; then
[[ -z "$SOURCE_AUTO_BRIGHTNESS_LEVEL" || -z "$DEVICE_AUTO_BRIGHTNESS_LEVEL" ]] && ERROR_EXIT "Missing auto brightness var"

find "$(pwd)" -type f -name "PowerManagerUtil.smali" -exec \
    sed -i -E "s/\"${SOURCE_AUTO_BRIGHTNESS_LEVEL}\"/\"${DEVICE_AUTO_BRIGHTNESS_LEVEL}\"/g" {} + \
|| ERROR_EXIT "Failed to patch PowerManagerUtil.smali"
fi
