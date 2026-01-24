
CSC_FEATURES=(
"CscFeature_Common_ConfigAllowedPackagesDuringDataSaving|com.samsung.android.smartcallprovider"
"CscFeature_Common_ConfigSvcProviderForUnknownNumber|whitepages,off"
"CscFeature_Common_EnhanceImageQuality|TRUE"
"CscFeature_Common_SupportPrivateMode|TRUE"
"CscFeature_Common_SupportZProjectFunctionInGlobal|TRUE"
"CscFeature_Contact_EnableDynCallerIdMatchingDigitWithAutoSim|TRUE"
"CscFeature_Contact_SupportDuoVideoCall|TRUE"
"CscFeature_Gallery_SupportAliveZoom|TRUE"
"CscFeature_Setting_ConfigTypeHelp|0"
"CscFeature_Setting_EnableHwVersionDisplay|TRUE"
"CscFeature_Setting_SupportELabelManufacturer|ASTROROM"
"CscFeature_Setting_SupportRegulatoryInfo|FALSE"
"CscFeature_SmartManager_ConfigDashboard|dual_dashboard"
"CscFeature_SmartManager_ConfigSubFeatures|applock|appcleanner|autolaunch|autorestart|devicesecurity|storageclean|backgroundapp|UDS|UDS2|applicationpermission|networkpowersaving|notificationmanager|trafficmanager|roguepopup|data_compression|cstyle"
"CscFeature_SmartManager_ConfigUdsSubFeatures|videocompression|uploadcompression"
"CscFeature_SmartManager_DisableAntiMalware|TRUE"
"CscFeature_SystemUI_ConfigOverrideDataIcon|LTE"
"CscFeature_SystemUI_SupportDataUsageViewOnQuickPanel|TRUE"
"CscFeature_VT_ConfigBearer|-CSVT"
"CscFeature_VoiceCall_ConfigRecording|RecordingAllowed"
"CscFeature_VoiceCall_EnableDisplaySdnNameDuringCall|TRUE"
"CscFeature_Wifi_SupportBlockSkipForSetupWizard|FALSE"
"CscFeature_Wifi_SupportNetworkConnectionsRequired|FALSE"
"CscFeature_Clock_EnableAutoPowerOnOffMenu|TRUE"
"CscFeature_Clock_SupportAlarmOptionMenuForHoliday|TRUE"
"CscFeature_Clock_SupportAlarmOptionMenuForWorkingDay|TRUE"
"CscFeature_Clock_SupportAlarmSoundMenu|TRUE"
"CscFeature_Clock_SupportAlarmSubstituteHolidayMenu|TRUE"
"CscFeature_Clock_SupportTimerResetButton|TRUE"
"CscFeature_Framework_SupportDataModeSwitchGlobalAction|TRUE"
"CscFeature_Camera_CamcorderDoNotPauseMusic|TRUE"
"CscFeature_Camera_CameraFlicker|60hz"
"CscFeature_Camera_DefaultQuality|superfine"
"CscFeature_Camera_EnableCameraDuringCall|TRUE"
"CscFeature_Message_SupportUsefulcard|TRUE"
"CscFeature_NFC_ConfigReaderModeUI|KOREA"
)


DECODE_ALL_OMC() {
    LOG_BEGIN "Starting OMC Decoding..."

    find "$WORKSPACE/optics" -type f -name "*.xml" | while read -r FILE; do


        if head -c 5 "$FILE" | grep -q "<"; then
            continue
        fi

        if grep -q "CscFeature" "$FILE" 2>/dev/null; then
            continue
        fi

        _UPDATE_LOG "Decoding OMC: ${FILE#$WORKSPACE/}" ""

        "$PREBUILTS/extras/omc-decoder/omcdecoder" \
            --decode \
            --in-place \
            "$FILE" \
            2>/dev/null

    done

    _UPDATE_LOG "Decoding finished." "DONE"
    LOG_END "Decoding finished."
}



CSC_PROP() {
    local TARGET_CSC="$1"
    local TAG="$2"
    local VALUE="$3"
    local SEARCH_PATH


    if [ "$TARGET_CSC" == "ALL" ]; then
        SEARCH_PATH="$(find "$WORKSPACE/optics/configs/carriers" -name "cscfeature.xml")"
    else
        SEARCH_PATH="$(find "$WORKSPACE/optics/configs/carriers" -path "*/$TARGET_CSC/*" -name "cscfeature.xml")"
    fi


    for FILE in $SEARCH_PATH; do
        [ -e "$FILE" ] || continue

        if [ -z "$VALUE" ]; then
            sed -i "/<$TAG>/d" "$FILE"
        else
            if grep -q "<$TAG>" "$FILE"; then
                sed -i "s|<$TAG>.*</$TAG>|<$TAG>$VALUE</$TAG>|g" "$FILE"
            else
                # ADD: Insert before </FeatureSet>
                # We use sed to insert the new line before the closing FeatureSet tag
                sed -i "/<\/FeatureSet>/i \    <$TAG>$VALUE<\/$TAG>" "$FILE"
            fi
        fi
    done
}




PROCESS_OMC_PARTITION() {
    [[ ! -d "$WORKSPACE/optics" ]] && return 0

    LOG_INFO "Patching CSC features..."

    #REMOVE "optics" "configs/carriers"

    ADD_FROM_FW "pa3q" "optics" "configs/carriers"

    # Decode OMC XMLs
    DECODE_ALL_OMC

    # Apply CSC Features
    for entry in "${CSC_FEATURES[@]}"; do
        IFS="|" read -r TAG VALUE <<< "$entry"
        CSC_PROP ALL "$TAG" "$VALUE" "$PART_DIR"
    done

    # Debloat prism
    find "$WORKSPACE/prism" -type f \
        \( -name "*.apk" -o -name "*.qmg" \
           -o -name "enforcedeletepackage.txt" \
           -o -name "enforceskippingpackages.txt" \) \
        -delete

    find "$WORKSPACE/prism" -type d -empty -delete

}
