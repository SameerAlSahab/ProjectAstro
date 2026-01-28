# https://github.com/pascua28/UN1CA/tree/sixteen/target/a71/patches/display

LOG_BEGIN "- Removing legacy display composer"
REMOVE "vendor" "bin/hw/android.hardware.graphics.composer@2.4-service"
REMOVE "vendor" "etc/init/android.hardware.graphics.composer@2.4-service.rc"
REMOVE "vendor" "etc/vintf/manifest/android.hardware.graphics.composer-qti-display.xml"
LOG_END

LOG_BEGIN "- Adding AIDL display composer from r8q"
BLOBS_LIST=$(find $BLOBS_DIR/r8q/vendor -type f -printf '%P\n')

for blob in $BLOBS_LIST; do
   ADD_FROM_FW "r8q" "vendor" "$blob"
done

mv "$WORKSPACE/vendor/lib64/hw/lights.kona.so" "$WORKSPACE/vendor/lib64/hw/lights.sm6150.so"
mv "$WORKSPACE/vendor/lib64/hw/memtrack.kona.so" "$WORKSPACE/vendor/lib64/hw/memtrack.sm6150.so"

HEX_EDIT "vendor/lib64/libsdmutils.so" "40F9F303012A3401" "40F9130080523401"

# Workaround getMetaData() return path to fix GetCustomDimensions() error (from r9q).
# Un-inline pixel format checks from:
# if (format != HAL_PIXEL_FORMAT_YCbCr_420_SP_VENUS_UBWC || format != HAL_PIXEL_FORMAT_YCbCr_420_TP10_UBWC ||
#      format != HAL_PIXEL_FORMAT_YCbCr_420_P010_UBWC)
# to:
# if (!IsUBwcFormat())
# to retain padding and file size
HEX_EDIT "vendor/lib64/libgrallocutils.so" "60040035a8c35eb828040034a82e40b9" "e803002ae0031f2a28040035a8c35eb8"
HEX_EDIT "vendor/lib64/libgrallocutils.so" "1f910471200100542981815269f4af72" "e8030034a82e40b9e003082a75feff97"
HEX_EDIT "vendor/lib64/libgrallocutils.so" "1f01096ba0000054c980815269f4af72" "e803002ae0031f2a280300341f2003d5"
HEX_EDIT "vendor/lib64/libgrallocutils.so" "1f01096bc1020054bf431ef8a9aa4329" "1f2003d51f2003d5bf431ef8a9aa4329"
LOG_END

LOG_BEGIN "- Fixing display composer props"
BPROP "vendor" "debug.sf.latch_unsignaled" "1"
BPROP "vendor" "debug.sf.auto_latch_unsignaled" "1"
BPROP "vendor" "debug.sf.enable_advanced_sf_phase_offset" "1"
BPROP "vendor" "debug.sf.disable_client_composition_cache" "0"
BPROP "vendor" "debug.sf.treat_170m_as_sRGB" "1"
BPROP "vendor" "debug.sf.enable_advanced_sf_phase_offset" "1"
BPROP "vendor" "debug.sf.gpu_freq_index" "6"
BPROP "vendor" "debug.graphics.game_default_frame_rate.disabled" "1"
BPROP "vendor" "vendor.display.disable_excl_rect_partial_fb" "1"
BPROP "vendor" "vendor.display.use_smooth_motion" "0"
BPROP "vendor" "vendor.display.disable_offline_rotator" "1"
BPROP "vendor" "vendor.display.enable_async_powermode" "0"
BPROP "vendor" "vendor.display.enable_early_wakeup" "0"
LOG_END