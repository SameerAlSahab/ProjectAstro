LOG_INFO "Fixing Face Unlock Biometrics"

LOG "Removing old face unlock 2.0 HALs"

REMOVE "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@2.0-service"
REMOVE "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@2.0-service.rc"

LOG "Adding new working 3.0 HALs..."

ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service"
ADD_FROM_FW "dm3q" "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so"
ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so"
ADD_FROM_FW "dm3q" "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc"

ADD_CONTEXT "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc"	"vendor_configs_file"
ADD_CONTEXT "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so" "vendor_file"
ADD_CONTEXT "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so" "vendor_file"
ADD_CONTEXT "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service" "hal_face_default_exec"
