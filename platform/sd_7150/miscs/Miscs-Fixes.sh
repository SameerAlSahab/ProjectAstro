LOG_BEGIN "- Removing media.extractor.sec.pcm-32bit"
BPROP "system" "media.extractor.sec.pcm-32bit" ""
LOG_END 

LOG_BEGIN "- Increasing audio buffer size to 1024"
BPROP "vendor" "vendor.audio.offload.buffer.size.kb" "1024"
LOG_END 

LOG_BEGIN "- Fixing Random Reboot..."
ADD_FROM_FW "main" "vendor" "bin/hw/vendor.samsung.hardware.tlc.iccc@1.0-service"
ADD_FROM_FW "main" "vendor" "etc/init/vendor.samsung.hardware.tlc.iccc@1.0-service.rc"
ADD_FROM_FW "main" "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0.so"
ADD_FROM_FW "main" "vendor" "lib64/vendor.samsung.hardware.tlc.iccc@1.0-impl.so"
LOG_END