
LOG_BEGIN "Removing Samsung Encryption"

    find "$WORKSPACE/vendor/etc" -type f -name "fstab*" | while read -r fstab; do
        
        sed -i \
            's/^\([^#].*\)fileencryption=[^,]*\(.*\)$/# &\n\1encryptable\2/' \
            "$fstab"

        
        sed -i \
            's/^\([^#].*\)forceencrypt=[^,]*\(.*\)$/# &\n\1encryptable\2/' \
            "$fstab"
    done



BPROP "vendor" "ro.frp.pst" ""
BPROP "product" "ro.frp.pst" ""


    rm -f \
        "$WORKSPACE/vendor/recovery-from-boot.p" \
        "$WORKSPACE/vendor/bin/install-recovery.sh" \
        "$WORKSPACE/vendor/etc/init/vendor_flash_recovery.rc" \
        "$WORKSPACE/vendor/etc/recovery-resource.dat" 2>/dev/null


