ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.light-service"
ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"

# Try to use from source if exist
ADD_FROM_FW "main" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"

