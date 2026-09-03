
if ! GET_FEATURE DEVICE_USE_STOCK_BASE; then

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

FLOATING_FEATURE_LINES()
{
FF_IF_DIFF "stock" "COMMON_CONFIG_BLE_SPEN_SPEC"
FF_IF_DIFF "stock" "COMMON_SUPPORT_BLE_SPEN"
FF_IF_DIFF "stock" "COMMON_CONFIG_SPEN_SENSITIVITY_ADJUSTMENT"
FF_IF_DIFF "stock" "FACTORY_SUPPORT_FTL_SPEN_TYPE"
FF_IF_DIFF "stock" "FRAMEWORK_CONFIG_SPEN_GARAGE_SPEC"
FF_IF_DIFF "stock" "FRAMEWORK_CONFIG_SPEN_VERSION"
FF_IF_DIFF "stock" "SETTINGS_CONFIG_SPEN_FCC_ID"
FF_IF_DIFF "stock" "SUPPORT_EAGLE_EYE"
}

if GET_FEATURE SOURCE_HAVE_SPEN_SUPPORT; then
    if GET_FEATURE DEVICE_HAVE_SPEN_SUPPORT; then
        LOG_INFO "Device and source both support SPen. Ignoring.."
    else
        LOG_INFO "Removing SPen components..."

        NUKE_BLOAT "${AIR_COMMAND_PKGS[@]}"

        for file in "${AIR_COMMAND_FILES[@]}"; do
            REMOVE "system" "$file"
        done

        FLOATING_FEATURE_LINES

        FF "SUPPORT_EAGLE_EYE" ""
        FF "COMMON_SUPPORT_BLE_SPEN" "FALSE"
    fi
else
    if GET_FEATURE DEVICE_HAVE_SPEN_SUPPORT; then
        LOG_INFO "Device supports SPen, source does not. Adding..."

        for pkg in "${AIR_COMMAND_PKGS[@]}"; do
            ADD_FROM_FW "pa3q" "system" "priv-app/$pkg"
        done

        for file in "${AIR_COMMAND_FILES[@]}"; do
            ADD_FROM_FW "pa3q" "system" "$file"
        done

        FLOATING_FEATURE_LINES

        FF "SUPPORT_EAGLE_EYE" "TRUE"
        FF "COMMON_SUPPORT_BLE_SPEN" "TRUE"
    else
        LOG_INFO "Device and source both lack SPen support. Nothing to do."
    fi
fi

fi
