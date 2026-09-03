
CORE_RUNE_SMALI=$(find . -type f -path "*/com/samsung/android/rune/CoreRune.smali" | head -n 1)

REPLACE_LINE \
    "sput-boolean v4, Lcom/samsung/android/rune/CoreRune;->FW_SUPPORT_MULTI_RESOLUTION:Z" \
    "sput-boolean v5, Lcom/samsung/android/rune/CoreRune;->FW_SUPPORT_MULTI_RESOLUTION:Z" \
    "$CORE_RUNE_SMALI"

REPLACE_LINE \
    "sput-boolean v4, Lcom/samsung/android/rune/CoreRune;->FW_MULTI_RESOLUTION_POLICY:Z" \
    "sput-boolean v5, Lcom/samsung/android/rune/CoreRune;->FW_MULTI_RESOLUTION_POLICY:Z" \
    "$CORE_RUNE_SMALI"
