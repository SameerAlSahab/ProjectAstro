LOG_BEGIN "- Adding wpa_supplicant from a73xq"
ADD_FROM_FW "a73xq" "vendor" "bin/hw/wpa_supplicant"
LOG_END

LOG_BEGIN "- Adding FM radio blobs from stock"
ADD_FROM_FW "stock" "system" "etc/permissions/privapp-permissions-com.sec.android.app.fm.xml"
ADD_FROM_FW "stock" "system" "etc/sysconfig/preinstalled-packages-com.sec.android.app.fm.xml"
ADD_FROM_FW "stock" "system" "priv-app/HybridRadio/HybridRadio.apk"
ADD_FROM_FW "stock" "system" "lib/libfmradio_jni.so"
ADD_FROM_FW "stock" "system" "lib64/libfmradio_jni.so"
ADD_FROM_FW "stock" "system_ext" "lib/fm_helium.so"
ADD_FROM_FW "stock" "system_ext" "lib/libbeluga.so"
ADD_FROM_FW "stock" "system_ext" "lib/libfm-hci.so"
ADD_FROM_FW "stock" "system_ext" "lib/vendor.qti.hardware.fm@1.0.so"
ADD_FROM_FW "stock" "system_ext" "lib64/fm_helium.so"
ADD_FROM_FW "stock" "system_ext" "lib64/libbeluga.so"
ADD_FROM_FW "stock" "system_ext" "lib64/libfm-hci.so"
ADD_FROM_FW "stock" "system_ext" "lib64/vendor.qti.hardware.fm@1.0.so"
LOG_END

LOG_BEGIN "- Replacing radio HAL with 1.5"
sed -i "s/1.4::IRadio/1.5::IRadio/g" "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_END