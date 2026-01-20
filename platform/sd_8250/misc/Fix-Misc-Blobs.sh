LOG_INFO "Fixing Random Reboot..."

	REMOVE "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0.so"
	REMOVE "vendor" "bin/hw/vendor.samsung.hardware.tlc.iccc@1.0-service"
	REMOVE "vendor" "etc/init/vendor.samsung.hardware.tlc.iccc@1.0-service.rc"
	REMOVE "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0-impl.so"

ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0.so"
ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.tlc.iccc@1.0-service"
ADD_FROM_FW "dm3q" "vendor" "etc/init/vendor.samsung.hardware.tlc.iccc@1.0-service.rc"
ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0-impl.so"
