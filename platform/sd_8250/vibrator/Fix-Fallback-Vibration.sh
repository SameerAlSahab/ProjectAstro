LOG_INFO "Fixing Vibration.."

# Remove old boys
REMOVE "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
REMOVE "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"

ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so"
ADD_FROM_FW "dm3q" "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc"
ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service"
ADD_FROM_FW "dm3q" "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml"

ADD_CONTEXT "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so" "vendor_file"
ADD_CONTEXT "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml" "vendor_configs_file"
ADD_CONTEXT "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc" "vendor_configs_file"
ADD_CONTEXT "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service" "hal_vibrator_default_exec"

