
WMS_SMALI=$(find . -type f -path "*/com/android/server/wm/WindowManagerService.smali" | head -n 1)

REPLACE_LINE \
    "const/high16 v4, 0x3f800000" \
    "const v4, 0x3f59999a    # 0.85f" \
    "$WMS_SMALI"


