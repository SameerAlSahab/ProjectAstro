#https://github.com/ShaDisNX255/NcX_Stock/commit/dc8a0872d0362dc7a1a723623558a73336193975

LOG_BEGIN "Removing Samsung Encryption"

while IFS= read -r -d '' FSTAB; do
    LOG_INFO "Patching $(basename "$FSTAB")"

    # Replace fileencryption with encryptable
    sed -i -E \
        's/^([^#].*?)fileencryption=[^,]*(.*)$/# &\n\1encryptable\2/' \
        "$FSTAB"

    # Replace forceencrypt with encryptable
    sed -i -E \
        's/^([^#].*?)forceencrypt=[^,]*(.*)$/# &\n\1encryptable\2/' \
        "$FSTAB"

done < <(
    find "$WORKSPACE/vendor/etc" \
        -type f \
        -name "fstab*" \
        -print0
)

# Disable FRP
BPROP "vendor"  "ro.frp.pst" ""
BPROP "product" "ro.frp.pst" ""

# vaultkeeper
BPROP "vendor" "ro.security.vaultkeeper.native" "0"
BPROP "vendor" "ro.security.vaultkeeper.feature" "0"

