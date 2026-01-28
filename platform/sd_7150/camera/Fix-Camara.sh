LOG_BEGIN "- Adding Polarr libs from a73xq"
ADD_FROM_FW "a73xq" "system" "etc/public.libraries-polarr.txt"
ADD_FROM_FW "a73xq" "system" "lib64/libBestComposition.polarr.so"
ADD_FROM_FW "a73xq" "system" "lib64/libFeature.polarr.so"
ADD_FROM_FW "a73xq" "system" "lib64/libPolarrSnap.polarr.so"
ADD_FROM_FW "a73xq" "system" "lib64/libTracking.polarr.so"
ADD_FROM_FW "a73xq" "system" "lib64/libYuv.polarr.so"
LOG_END

LOG_BEGIN "- Adding FunModeSDK from a73xq"
ADD_FROM_FW "a73xq" "system" "app/FunModeSDK"
LOG_END

LOG_BEGIN "- Replacing MIDAS config files with source"
REMOVE "vendor" "etc/midas"
ADD_FROM_FW "main" "vendor" "etc/midas"
sed -i "s/a73xq/$CODENAME/g" "$WORKSPACE/vendor/etc/midas/midas_config.json"
LOG_END

LOG_BEGIN "- Replacing singletake config files with source"
REMOVE "vendor" "etc/singletake"
ADD_FROM_FW "main" "vendor" "etc/singletake"
LOG_END