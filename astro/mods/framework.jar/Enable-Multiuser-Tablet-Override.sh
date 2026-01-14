CHAR_RAW="$(GET_PROP system ro.build.characteristics)"
CHAR_VALUE="${CHAR_RAW%%,*}"

if [[ -z "$CHAR_VALUE" ]]; then
    exit 0
fi

SMALI_FILE="$(find . -name "MultiUserSupportsHelper.smali" -type f 2>/dev/null)"

if [[ ! -f "$SMALI_FILE" ]]; then
    ERROR_EXIT "Target smali file not found."
fi

LOG_BEGIN "Enabling Multiuser patch..."


if ! sed -i "s/\"tablet\"/\"$CHAR_VALUE\"/g" "$SMALI_FILE"; then
    ERROR_EXIT "Failed to apply multiuser patch."
fi


BPROP "system" "persist.sys.show_multiuserui" "1"
BPROP "system" "fw.max_users" "5"
BPROP "system" "fw.show_multiuserui" "1"
BPROP "system" "fw.showhiddenusers" "1"

LOG_END "Multiuser patch applied"