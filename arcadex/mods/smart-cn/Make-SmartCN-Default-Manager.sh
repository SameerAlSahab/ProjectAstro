# ==============================================================================
#
# MOD_NAME="SmartManager China"
# MOD_AUTHOR="saadelasfur and Samuel"
# MOD_DESC="Adds Smart Manager China and removes default global device care."
#
# ==============================================================================

LOG_BEGIN "Installing Smart Manager China.."

FF "SMARTMANAGER_CONFIG_PACKAGE_NAME" "com.samsung.android.sm_cn"
FF "SECURITY_CONFIG_DEVICEMONITOR_PACKAGE_NAME" "com.samsung.android.sm.devicesecurity.tcm"

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.lool.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.lool.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml"

REMOVE "system" "priv-app/SmartManager_v5"
REMOVE "system" "app/SmartManager_v6_DeviceSecurity"
REMOVE "system" "priv-app/SmartManager_v6_DeviceSecurity"

# Some Indian or asian galaxy devices have AppLock on SSecure app without china manager , and paths might differ.
REMOVE "system" "app/AppLock"
REMOVE "system" "priv-app/SAppLock"

LOG_END "Successfully installed Smart Manager China"
