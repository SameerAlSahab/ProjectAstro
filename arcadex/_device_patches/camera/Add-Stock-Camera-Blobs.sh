
if ! GET_FEATURE DEVICE_USE_STOCK_BASE; then
# Other Device based camera fixes can be found on objectives and platform folder
# Remove source camera props and add stock only
if ! find "$OBJECTIVE" -type f -name "floating_feature.xml" | grep -q .; then

xmlstarlet ed -L -d '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' "$SEC_FLOATING_FEATURE_FILE"

xmlstarlet sel -t \
    -m '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' \
    -v 'name()' -o '=' -v '.' -n \
    "$STOCK_SEC_FLOATING_FEATURE_FILE" | while IFS='=' read -r tag value; do
        [[ -z "$tag" ]] && continue
        SILENT FF "$tag" "$value"
    done
fi

BPROP_IF_DIFF "stock" "system" "ro.build.flavor" "system"

PATCH_CAMERA_LIBS() {
    local SYSTEM="$WORKSPACE/system/system"
    local LIB_DIRS=(
        "$SYSTEM/lib"
        "$SYSTEM/lib64"
    )

    local FILES

    FILES=$(grep -Il "ro.product.name" \
        $(find "${LIB_DIRS[@]}" -type f -iname "*.so" \
            \( -iname "*camera*" -o -iname "*livefocus*" -o -iname "*bokeh*" \)) \
        2>/dev/null
    )

    [[ -z "$FILES" ]] && return 0

    while IFS= read -r FILE; do
        sed -i "s/ro.product.name/ro.arcade.codename/g" "$FILE"
        LOG_INFO "Patched camera library ${FILE#$WORKSPACE/}"
    done <<< "$FILES"
}

LOG_BEGIN "Patching camera for portrait mode.."

PATCH_CAMERA_LIBS

fi
