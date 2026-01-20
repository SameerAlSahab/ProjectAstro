# Night Mode crash fix
ADD_FROM_FW "stock" "system" "lib64/libSwIsp_wrapper_v1.camera.samsung.so"
ADD_FROM_FW "stock" "system" "lib64/libSwIsp_core.camera.samsung.so" 

# Fix Single Take Video Mode
REMOVE "vendor" "etc/singletake"
ADD_FROM_FW "dm3q" "vendor" "etc/singletake"
FF "GALLERY_CONFIG_AI_EXPANSION" "AI_Timelapse"

REMOVE "vendor" "saiv/swisp_1.0"
ADD_FROM_FW "dm3q" "vendor" "saiv/swisp_1.0"
