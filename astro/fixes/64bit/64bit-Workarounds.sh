#https://github.com/ExtremeXT/ExtremeROM/blob/fifteen/unica/patches/_desixtification/customize.sh

SOURCE_DEVICE="$(GET_PROP system ro.product.system.device)"
SYSTEM_DEVICE="$(GET_PROP system ro.product.system.device stock)"


if [[ "$SOURCE_DEVICE" == "$SYSTEM_DEVICE" ]]; then
    return 0
fi


if [[ "$SYSTEM_DEVICE" == qssi* || "$SYSTEM_DEVICE" == essi* ]] &&
   [[ "$SYSTEM_DEVICE" != *64 ]]; then
    LOG_INFO "32/64-bit firmware detected ($SYSTEM_DEVICE), Applying 64 bit patches.."

    BPROP "vendor" "ro.vendor.product.cpu.abilist" "arm64-v8a"
    BPROP "vendor" "ro.vendor.product.cpu.abilist32" ""
    BPROP "vendor" "ro.vendor.product.cpu.abilist64" "arm64-v8a"
    BPROP "vendor" "ro.zygote" "zygote64"
    BPROP "vendor" "dalvik.vm.dex2oat64.enabled" "true"

    # Required 64-bit runtime blobs
    BLOBS_LIST="
    apex/com.android.i18n.apex
    apex/com.android.runtime.apex
    apex/com.google.android.tzdata6.apex
    bin/bootstrap/linker
    bin/bootstrap/linker_asan
    "

    for blob in $BLOBS_LIST; do
        ADD_FROM_FW "stock" "system" "$blob"
    done


SOURCE_SDK="$(GET_PROP system ro.build.version.sdk)"
TARGET_SDK="$(GET_PROP system ro.build.version.sdk stock)"

if [[ "$SOURCE_SDK" == "$TARGET_SDK" ]]; then
    LOG_INFO "Using stock 32 bit libraries.."
    ADD_FROM_FW "stock" "system" "lib"
    ADD_FROM_FW "stock" "system" "lib64/lib.engmode.samsung.so"
    ADD_FROM_FW "stock" "system" "lib64/lib.engmodejni.samsung.so"
    ADD_FROM_FW "stock" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so"
else
    LOG_INFO "Using 32 bit prebuilts libraries.."
    if [[ "$SYSTEM_DEVICE" == qssi* ]]; then
        ADD_FROM_FW "dm3q" "system" "lib"
        ADD_FROM_FW "dm3q" "system" "lib64/lib.engmode.samsung.so"
        ADD_FROM_FW "dm3q" "system" "lib64/lib.engmodejni.samsung.so"
        ADD_FROM_FW "dm3q" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so"
    else
        ADD_FROM_FW "r11s" "system" "lib"
        ADD_FROM_FW "r11s" "system" "lib64/lib.engmode.samsung.so"
        ADD_FROM_FW "r11s" "system" "lib64/lib.engmodejni.samsung.so"
        ADD_FROM_FW "r11s" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so"
    fi
fi


    LOG_BEGIN "Creating runtime symlinks"

    ln -sf "/apex/com.android.runtime/bin/linker" \
        "$WORKSPACE/system/system/bin/linker"

    ln -sf "/apex/com.android.runtime/bin/linker_asan" \
        "$WORKSPACE/system/system/bin/linker_asan"

    ln -sf "/apex/com.android.runtime/lib/bionic/libc.so" \
        "$WORKSPACE/system/system/lib/libc.so"

    ln -sf "/apex/com.android.runtime/lib/bionic/libdl.so" \
        "$WORKSPACE/system/system/lib/libdl.so"

    ln -sf "/apex/com.android.runtime/lib/bionic/libdl_android.so" \
        "$WORKSPACE/system/system/lib/libdl_android.so"

    ln -sf "/apex/com.android.runtime/lib/bionic/libm.so" \
        "$WORKSPACE/system/system/lib/libm.so"


        LOG_BEGIN "Adding metadata"

ADD_CONTEXT system lib/libc.so system_lib_file
ADD_CONTEXT system lib/libdl.so system_lib_file

ADD_CONTEXT system lib/libdl_android.so system_lib_file
ADD_CONTEXT system lib/libm.so system_lib_file
ADD_CONTEXT system bin/linker system_file
ADD_CONTEXT system bin/linker_asan system_file


    LOG_END "64-bit desixtification applied"

else
    LOG_INFO "64-bit firmware detected ($SYSTEM_DEVICE), nothing to do!"
fi
