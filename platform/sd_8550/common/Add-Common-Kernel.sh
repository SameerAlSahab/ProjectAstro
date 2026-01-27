#https://github.com/samsung-sm8550/kernel_samsung_sm8550-common
    KERNEL_ZIP="$SCRPATH/common_kernel.zip"

    [[ -f "$KERNEL_ZIP" ]] || ERROR_EXIT "Kernel zip not found"

    mkdir -p "$DIROUT"

    LOG_INFO "Extracting boot.img from zip.."
    7z x -y "$KERNEL_ZIP" boot.img -o"$DIROUT" >/dev/null

    [[ -f "$DIROUT/boot.img" ]] || ERROR_EXIT "boot.img extraction failed"

    LOG_INFO "Added common kernel."
