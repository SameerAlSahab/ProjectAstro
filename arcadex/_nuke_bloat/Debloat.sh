# ==============================================================================
#
# MOD_NAME="Debloat useless apps"
# MOD_AUTHOR="ShaDisNX255"
# MOD_DESC="Debloats non needed apps and files from ROM."
#
# ==============================================================================


# Nuke odex files
find $WORKSPACE/system/system/ -type f \( -name "*.odex" -o -name "*.vdex" -o -name "*.art" -o -name "*.oat" \) -delete

# Remove folders
SILENT REMOVE "system" "hidden"
SILENT REMOVE "system" "preload"

declare -a BLOAT_TARGETS=()

# TTS VOICE PACKS
BLOAT_TARGETS+=(
    "SamsungTTSVoice_de_DE_f00" "SamsungTTSVoice_en_GB_f00" "SamsungTTSVoice_en_US_l03"
    "SamsungTTSVoice_es_ES_f00" "SamsungTTSVoice_es_MX_f00" "SamsungTTSVoice_es_US_f00"
    "SamsungTTSVoice_es_US_l01" "SamsungTTSVoice_fr_FR_f00" "SamsungTTSVoice_hi_IN_f00"
    "SamsungTTSVoice_it_IT_f00" "SamsungTTSVoice_pl_PL_f00" "SamsungTTSVoice_pt_BR_f00"
    "SamsungTTSVoice_pt_BR_l01" "SamsungTTSVoice_ru_RU_f00" "SamsungTTSVoice_th_TH_f00"
    "SamsungTTSVoice_vi_VN_f00" "SamsungTTSVoice_id_ID_f00" "SamsungTTSVoice_ar_AE_m00"
)


# KNOX APPS
BLOAT_TARGETS+=(
    "KnoxFrameBufferProvider"
    "KnoxGuard"
    "Rampart" # Auto Blocker
)

#  SYSTEM SERVICES & AGENTS
if [[ "${DEVICE_DISPLAY_HFR_MODE:-1}" -eq 0 ]]; then
    BLOAT_TARGETS+=(
        "IntelligentDynamicFpsService"  # Adaptive refresh rate service
    )
fi

BLOAT_TARGETS+=(
    "MAPSAgent"
    "AppUpdateCenter"
    "BCService"
    "UnifiedVVM"
    "UnifiedTetheringProvision"
    "UsByod"
    "WebManual"
    "DictDiotekForSec"
    "MoccaMobile"
    "Scone"
    "Upday"
    "VzCloud"
    "OmcAgent5" # App Recommendations
)

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.app.updatecenter.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.bcservice.xml"

# GAME HUB
BLOAT_TARGETS+=("GameHome")

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.game.gamehome.xml"
# Note: Signature permissions usually handled by PackageManager, but removing file works too
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.game.gamehome.xml"


#  GOOGLE APPS & OVERLAYS
BLOAT_TARGETS+=(
    "BardShell"           # Gemini App
    "Gmail2"
    "AssistantShell"
    "Chrome"
    "DuoStub"
    "Maps"
    "PlayAutoInstallConfig" # PAI
    "YouTube"
    "Messages"
)

SILENT REMOVE "product" "overlay/GmsConfigOverlaySearchSelector.apk"


#  FACTORY & TEST TOOLS (HwModuleTest)
BLOAT_TARGETS+=(
    "Cameralyzer"
    "FactoryAirCommandManager"
    "FactoryCameraFB"
    "HMT"
    "WlanTest"
    "FacAtFunction"
    "FactoryTestProvider"
    "AutomationTest_FB"
    "DRParser"
)

SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.sec.factory.cameralyzer.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.providers.factory.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.facatfunction.xml"


#  COVER SERVICES
BLOAT_TARGETS+=(
    "LedCoverService"
)

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.cover.ledcover.xml"


#  ACCESSIBILITY (Live Transcribe, Voice Access)
BLOAT_TARGETS+=(
    "LiveTranscribe"
    "VoiceAccess"
)

SILENT REMOVE "system" "etc/sysconfig/feature-a11y-preload.xml"
SILENT REMOVE "system" "etc/sysconfig/feature-a11y-preload-voacc.xml"


#  META
BLOAT_TARGETS+=(
    "FBAppManager_NS"
    "FBInstaller_NS"
    "FBServices"
)

SILENT REMOVE "system" "etc/default-permissions/default-permissions-meta.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-meta.xml"
SILENT REMOVE "system" "etc/sysconfig/meta-hiddenapi-package-allowlist.xml"


#  MICROSOFT
BLOAT_TARGETS+=("OneDrive_Samsung_v3")

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.microsoft.skydrive.xml"


#  SAMSUNG ANALYTICS & MY GALAXY
BLOAT_TARGETS+=(
    "MyGalaxyService"
    "DsmsAPK"
    "DeviceQualityAgent36"
    "DiagMonAgent95"
    "DiagMonAgent91"
    "SOAgent76"
)

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.mygalaxy.service.xml"
SILENT REMOVE "system" "etc/sysconfig/preinstalled-packages-com.mygalaxy.service.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.dqagent.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.diagmonagent.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.soagent.xml"


#  SAMSUNG AR EMOJI
BLOAT_TARGETS+=(
    "AREmojiEditor"
    "AvatarEmojiSticker"
)

SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.sec.android.mimage.avatarstickers.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.aremojieditor.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.mimage.avatarstickers.xml"
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.sec.android.mimage.avatarstickers.xml"


#  SAMSUNG APPS (Calendar, Clock, Free, Notes, Browser & Reminder)
BLOAT_TARGETS+=(
    "SamsungCalendar"
    "ClockPackage"
    "MinusOnePage"            # Samsung Free
    "SmartReminder"
    "OfflineLanguageModel_stub"
    "Notes40"
    "SBrowser"
)

SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.offline.languagemodel.xml"
SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.android.messaging.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.messaging.xml"


#  SAMSUNG PASS & AUTH
BLOAT_TARGETS+=(
    "SamsungPassAutofill_v1"
    "AuthFramework"
    "SamsungPass"
)

SILENT REMOVE "system" "etc/init/samsung_pass_authenticator_service.rc"
SILENT REMOVE "system" "etc/permissions/authfw.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.authfw.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.samsungpass.xml"
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.samsungpass.xml"
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.samsungpassautofill.xml"
SILENT REMOVE "system" "etc/sysconfig/samsungauthframework.xml"
SILENT REMOVE "system" "etc/sysconfig/samsungpassapp.xml"


#  SAMSUNG WALLET & DIGITAL KEY
BLOAT_TARGETS+=(
    "IpsGeofence" # Visit In
    "DigitalKey"
    "PaymentFramework"
    "SamsungCarKeyFw"
    "SamsungWallet"
    "BlockchainBasicKit"
)

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.ipsgeofence.xml"
SILENT REMOVE "system" "etc/init/digitalkey_init_ble_tss2.rc"
SILENT REMOVE "system" "etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml"
SILENT REMOVE "system" "etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.carkey.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.dkey.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.spayfw.xml"
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.spay.xml"
SILENT REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.spayfw.xml"
SILENT REMOVE "system" "etc/sysconfig/digitalkey.xml"
SILENT REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.dkey.xml"
SILENT REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.spayfw.xml"

# System EXT jars
SILENT REMOVE "system_ext" "framework/org.carconnectivity.android.digitalkey.rangingintent.jar"
SILENT REMOVE "system_ext" "framework/org.carconnectivity.android.digitalkey.secureelement.jar"


BLOAT_TARGETS+=(
    "SearchSelector"
    "SHClient"           # SettingsHelper
    "SmartTouchCall"
    "SmartTutor"
    "FotaAgent"          # Software Update
    "SVCAgent"
    "SVoiceIME"
    "wssyncmldm"
)

SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.settingshelper.xml"
SILENT REMOVE "system" "etc/sysconfig/settingshelper.xml"
SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.android.visualars.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.visualars.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.wssyncmldm.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.svcagent.xml"

# SIM UNLOCK SERVICE
BLOAT_TARGETS+=("SsuService")

SILENT REMOVE "system" "bin/ssud"
SILENT REMOVE "system" "etc/init/ssu.rc"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.ssu.xml"
SILENT REMOVE "system" "etc/sysconfig/samsungsimunlock.xml"
SILENT REMOVE "system" "lib64/android.security.securekeygeneration-ndk.so"
SILENT REMOVE "system" "lib64/libssu_keystore2.so"


NUKE_BLOAT "${BLOAT_TARGETS[@]}"

# Remove stock recovery scripts
    SILENT REMOVE \
        "vendor" "recovery-from-boot.p" \
        "vendor" "bin/install-recovery.sh" \
        "vendor" "etc/init/vendor_flash_recovery.rc" \
        "vendor" "etc/recovery-resource.dat"


LOG_END "Debloated successfully"
