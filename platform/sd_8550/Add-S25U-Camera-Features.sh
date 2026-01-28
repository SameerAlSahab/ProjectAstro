LOG_BEGIN "Adding 4k 120FPS On Pro Video..."

CF "BACK_CAMCORDER_RESOLUTION_FEATURE_MAP_3840X2160_120FPS" \
   "value=true" \
   "hdr=true" \
   "hdr10=false" \
   "snapshot-support=false" \
   "vdis=false" \
   "super-vdis=false" \
   "effect=false" \
   "object-tracking=false" \
   "seamless-zoom-support=false" \
   "physical-zoom-supported=false" \
   "external-storage-support=false" \
   "supported-mode=pro_video,slow_motion"

LOG_BEGIN "Adding Camera Assistant advanced features"

CF "SUPPORT_CAMERA_ASSISTANT_ADAPTIVE_PIXEL" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_ANAMORPHIC_LENS" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_ANAMORPHIC_LENS_HW_SCALER" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_AUDIO_MONITORING" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_AUTO_LENS_SWITCHING" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_CROP_ZOOM_X2" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_CROP_ZOOM_X10" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_DIGITAL_ZOOM_UPSCALE" "value=true"
CF "SUPPORT_CAMERA_ASSISTANT_DOF_ADAPTER" "value=true"
