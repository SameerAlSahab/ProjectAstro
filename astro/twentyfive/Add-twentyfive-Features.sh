#Thanks to samsung community on telegram for sharing most of this


# Now Brief
FF "FRAMEWORK_SUPPORT_PERSONALIZED_DATA_CORE" "TRUE"
FF "FRAMEWORK_SUPPORT_SMART_SUGGESTIONS_WIDGET" "TRUE"
FF "FRAMEWORK_SUPPORT_STACK_WIDGET_AUTO_ROTATION" "TRUE"

ADD_FROM_FW "pa3q" "system" "priv-app/SamsungSmartSuggestions" 
ADD_FROM_FW "pa3q" "system" "priv-app/Moments" 
ADD_FROM_FW "pa3q" "system" "etc/sysconfig/moments.xml"

# Environment adaptive display (Sead) + Display related
ADD_FROM_FW "pa3q" "system" "priv-app/EnvironmentAdaptiveDisplay" 
FF "SUPPORT_COLOR_LENS" "TRUE" 
# rest of patches are in services.jar 

# MFContents
ADD_FROM_FW "pa3q" "system" "etc/mfcontents"
ADD_FROM_FW "pa3q" "system" "priv-app/MFContents"

# Enable AI support
FF "COMMON_SUPPORT_AI_AGENT" "TRUE"
FF "COMMON_CONFIG_AI_VERSION" "20253"
FF "COMMON_CONFIG_AWESOME_INTELLIGENCE" "202501"

# Audio Eraser
FF "AUDIO_CONFIG_MULTISOURCE_SEPARATOR" "{FastScanning_6, SourceSeparator_4, Version_1.3.0}"
ADD_FROM_FW "pa3q" "system" "etc/fastScanner.tflite"
ADD_FROM_FW "pa3q" "system" "lib64/libmediasndk.mediacore.samsung.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmediasndk.so"

ADD_FROM_FW "pa3q" "system" "etc/audio_ae_intervals.conf"
ADD_FROM_FW "pa3q" "system" "etc/audio_effects.xml"
ADD_FROM_FW "pa3q" "system" "etc/audio_effects_common.conf"
ADD_FROM_FW "pa3q" "system" "lib64/libmultisourceseparator.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmultisourceseparator.audio.samsung.so"
ADD_FROM_FW "pa3q" "system" "etc/public.libraries-audio.samsung.txt"
ADD_FROM_FW "pa3q" "system" "etc/public.libraries-secinput.samsung.txt"

# AI Core / Language Model
ADD_FROM_FW "pa3q" "system" "priv-app/SamsungAiCore"
ADD_FROM_FW "pa3q" "system" "priv-app/OfflineLanguageModel_stub"
FF "GENAI_SUPPORT_OFFLINE_LANGUAGEMODEL" "TRUE"

# WiFi
ADD_FROM_FW "pa3q" "system" "app/WifiIntelligence"
ADD_FROM_FW "pa3q" "system" "app/WifiAiService"

# Sketchbook (edge panel)
ADD_FROM_FW "pa3q" "system" "app/SketchBook" 

# Wallpapers
ADD_FROM_FW "pa3q" "product" "priv-app/AICore" 
ADD_FROM_FW "pa3q" "product" "priv-app/AiWallpaper" 
ADD_FROM_FW "pa3q" "system" "priv-app/SpriteWallpaper"  #Used to animate Infinity wallpapers
ADD_FROM_FW "pa3q" "system" "priv-app/wallpaper-res"

# Photo Editor & Gallery
SILENT NUKE_BLOAT "PhotoEditor_Full"
ADD_FROM_FW "pa3q" "system" "priv-app/PhotoEditor_AIFull" 
ADD_FROM_FW "pa3q" "system" "priv-app/LiveEffectService" 
ADD_FROM_FW "pa3q" "system" "priv-app/VideoScan"
ADD_FROM_FW "pa3q" "system" "app/VisionModel-Stub" 
ADD_FROM_FW "pa3q" "system" "lib64/libArtifactDetector_v1.camera.samsung.so"
ADD_FROM_FW "pa3q" "system" "lib64/libphotohdr.so"
ADD_FROM_FW "pa3q" "system" "lib64/libtensorflowlite_gpu_delegate.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmediacapture.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmediacapture_jni.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmediacaptureservice.so"
ADD_FROM_FW "pa3q" "system" "lib64/libvideoframedec.so"
ADD_FROM_FW "pa3q" "system" "lib64/libvideoframedec_jni.so"
ADD_FROM_FW "pa3q" "system" "lib64/libveframework.videoeditor.samsung.so"
ADD_FROM_FW "pa3q" "system" "lib64/libsbs.so"
ADD_FROM_FW "pa3q" "system" "lib64/libsimba.media.samsung.so"
ADD_FROM_FW "pa3q" "system" "etc/mss_v0.13.0_4ch.sorione"
ADD_FROM_FW "pa3q" "system" "etc/palm_classifier.tflite"

FF "CAMERA_CONFIG_LOG_VIDEO" "V1.0"


FF "SAIV_SUPPORT_3DPHOTO" "TRUE"
FF "GALLERY_CONFIG_ZOOM_TYPE" "ZOOM_2K"
FF "GALLERY_SUPPORT_LOG_CORRECT_COLOR" "TRUE"
FF "MMFW_SUPPORT_AI_UPSCALER" "TRUE"

# Mediatek 
if [[ "$(GET_PROP system ro.product.system.device)" == "mssi" ]]; then
FF "LAUNCHER_CONFIG_ANIMATION_TYPE" "LowEnd"
else
# Live blur and launcher 
FF "LAUNCHER_CONFIG_ANIMATION_TYPE" "HighEnd"
FF "GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG" "TRUE"
FF "GRAPHICS_SUPPORT_CAPTURED_BLUR" "TRUE"
FF "GRAPHICS_SUPPORT_TOUCH_FAST_RESPONSE" "TRUE"
fi

#Permissions
ADD_FROM_FW "pa3q" "system" "etc/permissions" 
ADD_FROM_FW "pa3q" "system" "etc/default-permissions"

# Bixby 
ADD_FROM_FW "pa3q" "system" "priv-app/BixbyInterpreter" 

# Phone Packages
ADD_FROM_FW "pa3q" "system" "priv-app/SamsungInCallUI" 
ADD_FROM_FW "pa3q" "system" "priv-app/SamsungIntelliVoiceServices" 
ADD_FROM_FW "pa3q" "system" "priv-app/SamsungDialer" 

# Screenshot and Keyboard etc
ADD_FROM_FW "pa3q" "system" "app/HoneyBoard" 
ADD_FROM_FW "pa3q" "system" "app/SmartCapture" 
ADD_FROM_FW "pa3q" "system" "app/VisualCloudCore" 

# Ringtones ACH and bootanimation
ADD_FROM_FW "pa3q" "system" "media" 
BPROP "vendor" "ro.config.ringtone" "ACH_Galaxy_Bells.ogg"
BPROP "vendor" "ro.config.notification_sound" "ACH_Brightline.ogg"
BPROP "vendor" "ro.config.alarm_alert" "ACH_Morning_Xylophone.ogg"
BPROP "vendor" "ro.config.media_sound" "Media_preview_Over_the_horizon.ogg"
BPROP "vendor" "ro.config.ringtone_2" "ACH_Atomic_Bell.ogg"
BPROP "vendor" "ro.config.notification_sound_2" "ACH_Three_Star.ogg"

# Extras
FF "GENAI_CONFIG_LLM_VERSION" "0.40"
FF "GENAI_SUPPORT_C2PA" "TRUE"
FF "GENAI_CONFIG_FOUNDATION_MODEL" "3B"

# REMOVE useless packages
FF "COMMON_CONFIG_SMARTTUTOR_PACKAGES_NAME" ""
FF "COMMON_CONFIG_SMARTTUTOR_PACKAGES_PATH" ""

#add useful features
FF "COMMON_SUPPORT_ULTRA_POWER_SAVING" "TRUE"

#Media Context
ADD_FROM_FW "pa3q" "system" "etc/mediacontextanalyzer"
FF "MMFW_SUPPORT_MEDIA_CONTEXT_ANALYZER" "TRUE"
ADD_FROM_FW "pa3q" "system" "lib64/libcontextanalyzer_jni.media.samsung.so"
ADD_FROM_FW "pa3q" "system" "lib64/libvideo-highlight-arm64-v8a.so"
ADD_FROM_FW "pa3q" "system" "lib64/libmediacontextanalyzer.so"

local feature_xml="$WORKSPACE/system/system/etc/floating_feature.xml"

# TODO : a way for check device has NPU or not. Usually flagship device have NPU related props in the xml.
# We use this method until a new way found. For example : dm3q
if grep -q "NPU" "$feature_xml"; then
FF "MMFW_CONFIG_MEDIA_CONTEXT_ANALYZER_CORE" "NPU"
else
FF "MMFW_CONFIG_MEDIA_CONTEXT_ANALYZER_CORE" "GPU"
fi


# Semantic Search Core
FF "MSCH_SUPPORT_NLSEARCH" "TRUE"
ADD_FROM_FW "pa3q" "system" "etc/mediasearch"
ADD_FROM_FW "pa3q" "system" "priv-app/MediaSearch/MediaSearch.apk"
ADD_FROM_FW "pa3q" "system" "priv-app/SemanticSearchCore/SemanticSearchCore.apk"

# PhotoHDR (Will not work without 64bit only surfaceflinger)
# FF "MMFW_SUPPORT_PHOTOHDR" "TRUE"
# and other HDR* related lines

# S23 Ultra have same HFR modes and features S25U have
if [ "$CODENAME" = "dm3q" ]; then
    ADD_FROM_FW "pa3q" "system" "priv-app/SecSettings"
    ADD_FROM_FW "pa3q" "system" "priv-app/SettingsProvider"
fi
    ADD_FROM_FW "pa3q" "system" "priv-app/SecSettingsIntelligence"



# Basic features
FF "SUPPORT_SCREEN_RECORDER" "TRUE"
FF "VOICERECORDER_CONFIG_DEF_MODE" "normal,interview,voicememo"
FF "SUPPORT_LOW_HEAT_MODE" "TRUE"

