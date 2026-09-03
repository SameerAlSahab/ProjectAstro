# ==============================================================================
#
# MOD_NAME="Add speaker features from paradigm."
# MOD_AUTHOR="Sameer Al Sahab"
# MOD_DESC="Add some special effects and voice booster from paradigm."
#
# ==============================================================================

if GET_FEATURE DEVICE_HAVE_DUAL_SPEAKER; then

APPEND_FF_VALUE() {
    local FEATURE_TAG="$1"
    local APPEND_VALUE="$2"

    local CURRENT_VAL
    CURRENT_VAL=$(GET_FF_VAL "$FEATURE_TAG")


    if [[ -z "$CURRENT_VAL" ]]; then
        FF "$FEATURE_TAG" "$APPEND_VALUE"
    elif [[ ",$CURRENT_VAL," == *",$APPEND_VALUE,"* ]]; then
        LOG_INFO "Skipping appending ${APPEND_VALUE} already exists in ${FEATURE_TAG}"
    else
        # Append with a comma
        local NEW_VAL="${CURRENT_VAL},${APPEND_VALUE}"
        FF "$FEATURE_TAG" "$NEW_VAL"
    fi
}

APPEND_FF_VALUE "AUDIO_CONFIG_SOUNDALIVE_VERSION" "voice_boost"

ADD_FROM_FW "pa3q" "system" "lib64/libvoice_booster.so"
ADD_FROM_FW "pa3q" "system" "lib64/lib_sag_ai_sound_sep_v1.00.so"
ADD_FROM_FW "pa3q" "system" "lib64/lib_SAG_EQ_ver2060.so"
ADD_FROM_FW "pa3q" "system" "lib64/libSAG_VM_Energy_v300.so"
ADD_FROM_FW "pa3q" "system" "lib64/libSAG_VM_Score_V300.so"
ADD_FROM_FW "pa3q" "system" "lib64/lib_SoundAlive_play_plus_ver900.so"
ADD_FROM_FW "pa3q" "system" "etc/audio_effects_common.conf"

echo "/system/lib64/lib_sag_ai_sound_sep_v1.00.so" >> "$WORKSPACE/system/system/etc/irremovable_list.txt"

fi
