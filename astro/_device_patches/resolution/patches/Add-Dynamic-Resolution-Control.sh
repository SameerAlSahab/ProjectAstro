
CORE_RUNE_SMALI=$(find . -type f -path "*/com/samsung/android/rune/CoreRune.smali" | head -n 1)

REPLACE_LINE \
    "sput-boolean v5, Lcom/samsung/android/rune/CoreRune;->FW_DYNAMIC_RESOLUTION_CONTROL:Z" \
    "sput-boolean v4, Lcom/samsung/android/rune/CoreRune;->FW_DYNAMIC_RESOLUTION_CONTROL:Z" \
    "$CORE_RUNE_SMALI"


REPLACE_LINE \
    "sput-boolean v5, Lcom/samsung/android/rune/CoreRune;->FW_VRR_RESOLUTION_POLICY:Z" \
    "sput-boolean v3, Lcom/samsung/android/rune/CoreRune;->FW_VRR_RESOLUTION_POLICY:Z" \
    "$CORE_RUNE_SMALI"


REPLACE_LINE \
    "sput-boolean v5, Lcom/samsung/android/rune/CoreRune;->FW_VRR_RESOLUTION_POLICY_FOR_SHELL_TRANSITION:Z" \
    "sput-boolean v3, Lcom/samsung/android/rune/CoreRune;->FW_VRR_RESOLUTION_POLICY_FOR_SHELL_TRANSITION:Z" \
    "$CORE_RUNE_SMALI"
