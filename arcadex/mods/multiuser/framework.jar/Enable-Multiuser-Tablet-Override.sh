
DEVICE_CHARACTERISTICS="$(GET_PROP system ro.build.characteristics)"
SINGLE_DEVICE_CHARACTERISTICS="${DEVICE_CHARACTERISTICS%%,*}"

SMALI_FILE="$(find . -name "MultiUserSupportsHelper.smali" -type f 2>/dev/null)"

LOG_BEGIN "Enabling Multiuser patch..."

# The bomb
if ! sed -i "s/\"tablet\"/\"$SINGLE_DEVICE_CHARACTERISTICS\"/g" "$SMALI_FILE"; then
    ERROR_EXIT "Failed to apply multiuser patch."
fi

# Set props
BPROP "system" "persist.sys.show_multiuserui" "1"
BPROP "system" "fw.max_users" "5"
BPROP "system" "fw.show_multiuserui" "1"
BPROP "system" "fw.showhiddenusers" "1"

LOG_END "Multiuser patch applied"
