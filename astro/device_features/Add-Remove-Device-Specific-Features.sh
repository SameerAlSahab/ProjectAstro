
# NOTE This is not completed yet.

# Basic
FF "SETTINGS_CONFIG_BRAND_NAME" "$MODEL_NAME"
FF "SYSTEM_CONFIG_SIOP_POLICY_FILENAME" "$SIOP_POLICY_NAME"

BPROP "system" "ro.product.astro.model" "$STOCK_MODEL"

# Edge lighting corner radius
BPROP "system" "ro.factory.model" "$STOCK_MODEL"
##

ASTRO_CODENAME="$(GET_PROP "system" "ro.product.system.name" "stock")"

if [[ -n "$ASTRO_CODENAME" ]]; then
    BPROP "system" "ro.astro.codename" "$ASTRO_CODENAME"
 else
    BPROP "system" "ro.astro.codename" "$CODENAME"
fi


if [[ "$MODEL" == "$STOCK_MODEL" ]] || [[ "${DEVICE_HAVE_DONOR_SOURCE,,}" == "true" ]]; then
    LOG_INFO "Ignoring device feature patching..."

else
FF_FILE="$WORKSPACE/system/system/etc/floating_feature.xml"
STOCK_FF_FILE="$STOCK_FW/system/system/etc/floating_feature.xml"


## Camera
# Other Device based camera fixes can be found on objectives and platform folder
REMOVE "system" "cameradata/portrait_data"

#BPROP_IF_DIFF "stock" "system" "ro.product.system.name"

REMOVE "system" "cameradata/singletake"


LOG_INFO "Adding stock camera properties.."

ADD_FROM_FW "stock" "system" "cameradata"

# Remove source camera props and add stock only
xmlstarlet ed -L -d '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' "$FF_FILE"


xmlstarlet sel -t \
    -m '//*[starts-with(name(), "SEC_FLOATING_FEATURE_CAMERA")]' \
    -v 'name()' -o '=' -v '.' -n \
    "$STOCK_FF_FILE" | while IFS='=' read -r tag value; do
        [[ -z "$tag" ]] && continue
        SILENT FF "$tag" "$value"
    done



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
        sed -i "s/ro.product.name/ro.astro.codename/g" "$FILE"
        LOG_INFO "Patched camera library ${FILE#$WORKSPACE/}"
    done <<< "$FILES"
}

LOG_INFO "Patching camera for portrait mode.."

PATCH_CAMERA_LIBS

##

# Display MDNIE
    FF_IF_DIFF "stock" "COMMON_CONFIG_MDNIE_MODE"


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
fi





