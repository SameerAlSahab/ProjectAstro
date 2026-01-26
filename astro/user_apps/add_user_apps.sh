# Via Browser
LOG_BEGIN "Adding Via Browser"

VIA_DIR="$WORKSPACE/system/system/preload/ViaBrowser"
VIA_APK_URL="https://res.viayoo.com/v1/via-release.apk"

mkdir -p "$VIA_DIR"

SILENT wget -O "$VIA_DIR/ViaBrowser.apk" "$VIA_APK_URL"

VPL_LIST="$WORKSPACE/system/system/etc/vpl_apks_count_list.txt"
VPL_ENTRY="system/preload/ViaBrowser/ViaBrowser.apk"

if ! grep -qx "$VPL_ENTRY" "$VPL_LIST"; then
    LOG_BEGIN "Adding \"$VPL_ENTRY\" to vpl_apks_count_list.txt"
    echo "$VPL_ENTRY" >> "$VPL_LIST"
fi
