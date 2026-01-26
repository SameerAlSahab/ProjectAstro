#https://github.com/ExtremeXT/ExtremeROM/blob/fifteen/unica/patches/_desixtification/customize.sh

if [[ "$SOURCE_SINGLE_SYSTEM_IMAGE" == "$DEVICE_SINGLE_SYSTEM_IMAGE" ]]; then
    return 0
fi


if [[ "$SOURCE_SINGLE_SYSTEM_IMAGE" == *64* ]]; then
    if [[ "$DEVICE_SINGLE_SYSTEM_IMAGE" == qssi* || "$DEVICE_SINGLE_SYSTEM_IMAGE" == essi* ]] && [[ "$DEVICE_SINGLE_SYSTEM_IMAGE" != *64* ]]; then
        LOG_INFO "Applying 64 bit patches.."

        # Set 64-bit only props
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
        bin/bootstrap/linker64
        bin/bootstrap/linker_asan
        bin/bootstrap/linker_asan64
        "

        for blob in $BLOBS_LIST; do
            ADD_FROM_FW "dm3q" "system" "$blob"
        done

        SOURCE_SDK="$(GET_PROP system ro.build.version.sdk)"
        TARGET_SDK="$(GET_PROP system ro.build.version.sdk stock)"


        if [[ "$SOURCE_SDK" == "$TARGET_SDK" ]]; then
            LOG_INFO "Using stock 32 bit libraries.."
            ADD_FROM_FW "stock" "system" "lib"

            # Downgrade engmode libraries
            ADD_FROM_FW "stock" "system" "lib64/lib.engmode.samsung.so"
            ADD_FROM_FW "stock" "system" "lib64/lib.engmodejni.samsung.so"
            ADD_FROM_FW "stock" "system" "lib64/vendor.samsung.hardware.security.engmode@1.0.so"
        else

            LOG_INFO "Using 32 bit prebuilts libraries.."

    if [[ "$DEVICE_SINGLE_SYSTEM_IMAGE" == qssi* ]]; then
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

ADD_CONTEXT system "lib/libc.so" "system_lib_file"
ADD_CONTEXT system "lib/libdl.so" "system_lib_file"

ADD_CONTEXT system "lib/libdl_android.so" "system_lib_file"
ADD_CONTEXT system "lib/libm.so" "system_lib_file"
ADD_CONTEXT system "bin/linker" "system_file"
ADD_CONTEXT system "bin/linker_asan" "system_file"

ADD_CONTEXT system "apex/com.android.i18n.apex" "system_file"
ADD_CONTEXT system "apex/com.android.runtime.apex" "system_file"
ADD_CONTEXT system "apex/com.google.android.tzdata6.apex" "system_file"

ADD_CONTEXT system "bin/linker" "system_linker_exec"
ADD_CONTEXT system "bin/linker_asan" "system_file"
ADD_CONTEXT system "bin/bootstrap/linker" "system_linker_exec"
ADD_CONTEXT system "bin/bootstrap/linker_asan" "system_file"

ADD_CONTEXT system "lib/bootstrap" "system_bootstrap_lib_file"
ADD_CONTEXT system "lib/bootstrap/libc.so" "system_bootstrap_lib_file"
ADD_CONTEXT system "lib/bootstrap/libdl_android.so" "system_bootstrap_lib_file"
ADD_CONTEXT system "lib/bootstrap/libdl.so" "system_bootstrap_lib_file"
ADD_CONTEXT system "lib/bootstrap/libm.so" "system_bootstrap_lib_file"


        LOG_END "64-bit desixtification applied"
    else
        LOG_INFO "64-bit firmware detected ($DEVICE_SINGLE_SYSTEM_IMAGE), nothing to do!"
    fi
fi
