local NETFLIX=$(GET_PROP "system" "ro.netflix.bsp_rev" "stock")

BPROP "system" "ro.netflix.bsp_rev" "$NETFLIX"