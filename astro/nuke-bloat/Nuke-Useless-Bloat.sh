
# App Package folders names only in app and priv-app
declare -a BLOAT_TARGETS=(

    # System Bloat
    "AuthFramework" "BCService" "CIDManager" "DeviceKeystring" "DiagMonAgent91"
    "DigitalKey" "FacAtFunction" "FactoryTestProvider" "FotaAgent" "KnoxGuard" "Rampart"
    "ModemServiceMode" "PaymentFramework" "SEMFactoryApp" "SOAgent7" "SamsungCarKeyFw"
    "SamsungPass" "SamsungPassAutofill_v1" "SilentLog" "SmartEpdgTestApp" "Ts43AuthService"
    "UnifiedTetheringProvision" "UnifiedVVM" "UsByod" "WebManual" "WlanTest" "wssyncmldm" "MyGalaxyService"
    "SsuService" "MapsAgent" "AppUpdateCenter" "LedCoverService" "LiveTranscribe"
    "OfflineLanguageModel_stub" "IpsGeofence" "SHClient" "SmartTouchCall"
    "SmartTutor" "SVoiceIME" "VoiceAccess"

    # Factory/Test
    "AutomationTest_FB" "DRParser" "FactoryCameraFB" "Cameralyzer" "FactoryAirCommandManager" "HMT"

    # Meta
    "FBAppManager_NS" "FBInstaller_NS" "FBServices"

    # TTS Voices
    "SamsungTTSVoice_de_DE_f00" "SamsungTTSVoice_en_GB_f00" "SamsungTTSVoice_en_US_l03"
    "SamsungTTSVoice_es_ES_f00" "SamsungTTSVoice_es_MX_f00" "SamsungTTSVoice_es_US_f00"
    "SamsungTTSVoice_es_US_l01" "SamsungTTSVoice_fr_FR_f00" "SamsungTTSVoice_hi_IN_f00"
    "SamsungTTSVoice_it_IT_f00" "SamsungTTSVoice_pl_PL_f00" "SamsungTTSVoice_pt_BR_f00"
    "SamsungTTSVoice_pt_BR_l01" "SamsungTTSVoice_ru_RU_f00" "SamsungTTSVoice_th_TH_f00"
    "SamsungTTSVoice_vi_VN_f00" "SamsungTTSVoice_id_ID_f00" "SamsungTTSVoice_ar_AE_m00"

    # Samsung Apps
    "AssistantShell" "Notes40" "SBrowser" "SamsungPass" "SamsungPassAutofill_v1" "SamsungWallet"
    "AREmojiEditor" "AvatarEmojiSticker" "SamsungCalendar" "MinusOnePage"

    # Google Apps
    "Chrome" "DuoStub" "Gmail2" "Maps" "Messages" "YouTube"

    # Third-Party
    "BlockchainBasicKit" "DictDiotekForSec" "HMT" "MoccaMobile" "OneDrive_Samsung_v3"
    "PlayAutoInstallConfig" "Scone" "Upday" "VzCloud"

    # Game
    "GameHome"

    # Overlays
    "GmsConfigOverlaySearchSelector.apk" "SearchSelector"
)


NUKE_BLOAT "${BLOAT_TARGETS[@]}"



# Useless dirs
declare -a SYSTEM_DIRS=(
    hidden
    preload
)

for dir in "${SYSTEM_DIRS[@]}"; do
    REMOVE "system" "$dir"
done




