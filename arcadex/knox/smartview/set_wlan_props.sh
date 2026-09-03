# https://github.com/ShaDisNX255/NcX_Stock/commit/daab0463d26e9411a98a60e63ea1e73026bad0ee

LOG_INFO "Fixing SmartView on rooted phones..."

partitions=("system" "product" "odm" "system_ext" "system_dlkm" "vendor")
for partition in "${partitions[@]}"; do
    SILENT BPROP "$partition" "wlan.wfd.hdcp" "disabled"
    SILENT BPROP "$partition" "wifi.interface" "wlan0"
done
