find "$(pwd)" -type f -name "PowerManagerUtil.smali" -exec \
    sed -i -E "s/\"${SOURCE_AUTO_BRIGHTNESS_LEVEL}\"/\"${DEVICE_AUTO_BRIGHTNESS_LEVEL}\"/g" {} + \
|| ERROR_EXIT "Failed to patch PowerManagerUtil.smali"
