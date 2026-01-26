#!/bin/bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#


# Nuke odex files
find $WORKSPACE/system/system/ -type f \( -name "*.odex" -o -name "*.vdex" -o -name "*.art" -o -name "*.oat" \) -delete

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
BLOAT_TARGETS+=(
    "IntelligentDynamicFpsService"  #Adaptive refresh rate service
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
)

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.app.updatecenter.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.sec.bcservice.xml"

# GAME HUB
BLOAT_TARGETS+=("GameHome")

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.game.gamehome.xml"
# Note: Signature permissions usually handled by PackageManager, but removing file works too
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.game.gamehome.xml"


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

REMOVE "product" "overlay/GmsConfigOverlaySearchSelector.apk"


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

REMOVE "system" "etc/default-permissions/default-permissions-com.sec.factory.cameralyzer.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.providers.factory.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.sec.facatfunction.xml"


#  COVER SERVICES
BLOAT_TARGETS+=(
    "LedCoverService"
)

REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.cover.ledcover.xml"


#  ACCESSIBILITY (Live Transcribe, Voice Access)
BLOAT_TARGETS+=(
    "LiveTranscribe"
    "VoiceAccess"
)

REMOVE "system" "etc/sysconfig/feature-a11y-preload.xml"
REMOVE "system" "etc/sysconfig/feature-a11y-preload-voacc.xml"


#  META
BLOAT_TARGETS+=(
    "FBAppManager_NS"
    "FBInstaller_NS"
    "FBServices"
)

REMOVE "system" "etc/default-permissions/default-permissions-meta.xml"
REMOVE "system" "etc/permissions/privapp-permissions-meta.xml"
REMOVE "system" "etc/sysconfig/meta-hiddenapi-package-allowlist.xml"


#  MICROSOFT
BLOAT_TARGETS+=("OneDrive_Samsung_v3")

REMOVE "system" "etc/permissions/privapp-permissions-com.microsoft.skydrive.xml"


#  SAMSUNG ANALYTICS & MY GALAXY
BLOAT_TARGETS+=(
    "MyGalaxyService"
    "DsmsAPK"
    "DeviceQualityAgent36"
    "DiagMonAgent95"
    "DiagMonAgent91"
    "SOAgent76"
)

REMOVE "system" "etc/permissions/privapp-permissions-com.mygalaxy.service.xml"
REMOVE "system" "etc/sysconfig/preinstalled-packages-com.mygalaxy.service.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.dqagent.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.diagmonagent.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.soagent.xml"


#  SAMSUNG AR EMOJI
BLOAT_TARGETS+=(
    "AREmojiEditor"
    "AvatarEmojiSticker"
)

REMOVE "system" "etc/default-permissions/default-permissions-com.sec.android.mimage.avatarstickers.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.aremojieditor.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.sec.android.mimage.avatarstickers.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.sec.android.mimage.avatarstickers.xml"


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

REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.offline.languagemodel.xml"
REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.android.messaging.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.messaging.xml"


#  SAMSUNG PASS & AUTH
BLOAT_TARGETS+=(
    "SamsungPassAutofill_v1"
    "AuthFramework"
    "SamsungPass"
)

REMOVE "system" "etc/init/samsung_pass_authenticator_service.rc"
REMOVE "system" "etc/permissions/authfw.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.authfw.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.samsungpass.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.samsungpass.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.samsungpassautofill.xml"
REMOVE "system" "etc/sysconfig/samsungauthframework.xml"
REMOVE "system" "etc/sysconfig/samsungpassapp.xml"


#  SAMSUNG WALLET & DIGITAL KEY
BLOAT_TARGETS+=(
    "IpsGeofence" # Visit In
    "DigitalKey"
    "PaymentFramework"
    "SamsungCarKeyFw"
    "SamsungWallet"
    "BlockchainBasicKit"
)

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.ipsgeofence.xml"
REMOVE "system" "etc/init/digitalkey_init_ble_tss2.rc"
REMOVE "system" "etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml"
REMOVE "system" "etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.carkey.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.dkey.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.spayfw.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.spay.xml"
REMOVE "system" "etc/permissions/signature-permissions-com.samsung.android.spayfw.xml"
REMOVE "system" "etc/sysconfig/digitalkey.xml"
REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.dkey.xml"
REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.spayfw.xml"

# System EXT jars
REMOVE "system_ext" "framework/org.carconnectivity.android.digitalkey.rangingintent.jar"
REMOVE "system_ext" "framework/org.carconnectivity.android.digitalkey.secureelement.jar"


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

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.settingshelper.xml"
REMOVE "system" "etc/sysconfig/settingshelper.xml"
REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.android.visualars.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.visualars.xml"
REMOVE "system" "hidden/SmartTutor"
REMOVE "system" "etc/permissions/privapp-permissions-com.wssyncmldm.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.svcagent.xml"

# SIM UNLOCK SERVICE
BLOAT_TARGETS+=("SsuService")

REMOVE "system" "bin/ssud"
REMOVE "system" "etc/init/ssu.rc"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.ssu.xml"
REMOVE "system" "etc/sysconfig/samsungsimunlock.xml"
REMOVE "system" "lib64/android.security.securekeygeneration-ndk.so"
REMOVE "system" "lib64/libssu_keystore2.so"



NUKE_BLOAT "${BLOAT_TARGETS[@]}"



LOG_END "Debloated successfully"
