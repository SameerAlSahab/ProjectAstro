
# App Package folders names only in app and priv-app

declare -a BLOAT_TARGETS=(
    # Basic
    BCService
    CIDManager
    DeviceKeystring
    DiagMonAgent91
    FacAtFunction
    FactoryTestProvider
    FotaAgent
    KnoxGuard
    ModemServiceMode
    MyGalaxyService
    PaymentFramework
    Rampart
    SEMFactoryApp
    SHClient
    SilentLog
    SmartEpdgTestApp
    SmartTutor
    SmartTouchCall
    SOAgent7
    SsuService
    Ts43AuthService
    UnifiedTetheringProvision
    UnifiedVVM
    UsByod
    WebManual
    WlanTest
    wssyncmldm
    MapsAgent
    AppUpdateCenter
    LedCoverService
    LiveTranscribe
    IpsGeofence
    VoiceAccess
    SVoiceIME

    # Factory / Test
    AutomationTest_FB
    Cameralyzer
    DRParser
    FactoryAirCommandManager
    FactoryCameraFB
    HMT

    # Meta
    FBAppManager_NS
    FBInstaller_NS
    FBServices

    # Samsung Apps
    AREmojiEditor
    AvatarEmojiSticker
    MinusOnePage
    Notes40
    Routines
    SamsungCalendar
    SBrowser

    # Samsung TTS Voices
    SamsungTTSVoice_ar_AE_m00
    SamsungTTSVoice_de_DE_f00
    SamsungTTSVoice_en_GB_f00
    SamsungTTSVoice_en_US_l03
    SamsungTTSVoice_es_ES_f00
    SamsungTTSVoice_es_MX_f00
    SamsungTTSVoice_es_US_f00
    SamsungTTSVoice_es_US_l01
    SamsungTTSVoice_fr_FR_f00
    SamsungTTSVoice_hi_IN_f00
    SamsungTTSVoice_id_ID_f00
    SamsungTTSVoice_it_IT_f00
    SamsungTTSVoice_pl_PL_f00
    SamsungTTSVoice_pt_BR_f00
    SamsungTTSVoice_pt_BR_l01
    SamsungTTSVoice_ru_RU_f00
    SamsungTTSVoice_th_TH_f00
    SamsungTTSVoice_vi_VN_f00

    # Google Apps
    AssistantShell
    Chrome
    DuoStub
    Gmail2
    Maps
    Messages
    YouTube
    PlayAutoInstallConfig

    # Microsoft
    OneDrive_Samsung_v3

    # Third-party
    DictDiotekForSec
    MoccaMobile
    Scone
    Upday
    VzCloud

    # Gaming
    GameHome

    # Extras
    DsmsAPK
    SearchSelector
    GmsConfigOverlaySearchSelector.apk

    # Data
    DeviceQualityAgent36
    SOAgent76
    DiagMonAgent95

    # Not gonna work
    BlockchainBasicKit
    SamsungCarKeyFw
    SamsungPass
    SamsungPassAutofill_v1
    SamsungWallet
    DigitalKey
    AuthFramework
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



# Do not declare system/etc
declare -a PERM_TO_REMOVE=(
    # Digital Key / Wallet
    permissions/org.carconnectivity.android.digitalkey.rangingintent.xml
    permissions/org.carconnectivity.android.digitalkey.secureelement.xml
    permissions/privapp-permissions-com.samsung.android.carkey.xml
    permissions/privapp-permissions-com.samsung.android.dkey.xml
    permissions/privapp-permissions-com.samsung.android.spayfw.xml
    permissions/signature-permissions-com.samsung.android.spay.xml
    permissions/signature-permissions-com.samsung.android.spayfw.xml
    sysconfig/digitalkey.xml
    sysconfig/preinstalled-packages-com.samsung.android.dkey.xml
    sysconfig/preinstalled-packages-com.samsung.android.spayfw.xml

    # Samsung Auth/ Pass
    permissions/authfw.xml
    permissions/privapp-permissions-com.samsung.android.authfw.xml
    permissions/privapp-permissions-com.samsung.android.samsungpass.xml
    permissions/signature-permissions-com.samsung.android.samsungpass.xml
    permissions/signature-permissions-com.samsung.android.samsungpassautofill.xml
    sysconfig/samsungauthframework.xml
    sysconfig/samsungpassapp.xml

    #  AR / Emoji
    default-permissions/default-permissions-com.sec.android.mimage.avatarstickers.xml
    permissions/privapp-permissions-com.samsung.android.aremojieditor.xml
    permissions/privapp-permissions-com.sec.android.mimage.avatarstickers.xml
    permissions/signature-permissions-com.sec.android.mimage.avatarstickers.xml

    # OneDrive
    permissions/privapp-permissions-com.microsoft.skydrive.xml

    # Meta
    default-permissions/default-permissions-meta.xml
    permissions/privapp-permissions-meta.xml
    sysconfig/meta-hiddenapi-package-allowlist.xml

    # Update center and etc
    sysconfig/feature-a11y-preload.xml
    permissions/privapp-permissions-com.samsung.android.app.updatecenter.xml

    # My Galaxy
    permissions/privapp-permissions-com.mygalaxy.service.xml
    sysconfig/preinstalled-packages-com.mygalaxy.service.xml

    # Samsung Data gathering
    permissions/privapp-permissions-com.samsung.android.dqagent.xml
    permissions/privapp-permissions-com.sec.android.diagmonagent.xml
    permissions/privapp-permissions-com.sec.android.soagent.xml

    # Factory / Test
    default-permissions/default-permissions-com.sec.factory.cameralyzer.xml
    permissions/privapp-permissions-com.samsung.android.providers.factory.xml
    permissions/privapp-permissions-com.sec.facatfunction.xml
)

LOG_INFO "Removing permisson files..."

for file in "${PERM_TO_REMOVE[@]}"; do
    REMOVE "system" "etc/$file" >/dev/null 2>&1
done

