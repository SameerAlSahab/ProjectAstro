# ==============================================================================
#
# MOD_NAME="Add Camera features"
# MOD_AUTHOR="Sameer Al Sahab"
# MOD_DESC="Add some camera features."
#
# ==============================================================================


LOG_BEGIN "Adding camera assistant features.."

CF "SUPPORT_CAMERA_ASSISTANT" "value=true"

LOG_BEGIN "Adding extra camera features.."
CF "SUPPORT_VIDEO_MODE_ZOOM_ROCKER" "value=true"
CF "SUPPORT_LOG_VIDEO" "value=true"
CF "SUPPORT_DEFAULT_HEVC" "value=true"
CF "SUPPORT_VIDEO_HIGH_BITRATE" "value=true"
CF "SUPPORT_VIDEO_AUTO_FPS_OPTION" "value=true"
CF "SUPPORT_ADVANCED_ZERO_SHUTTER_LAG" "value=true"

FF "CAMERA_CONFIG_LOG_VIDEO" "V1.0"
FF "GALLERY_SUPPORT_LOG_CORRECT_COLOR" "TRUE"

# Gallery
FF "MMFW_SUPPORT_AI_UPSCALER" "TRUE"

LOG_END "Camera features added."
