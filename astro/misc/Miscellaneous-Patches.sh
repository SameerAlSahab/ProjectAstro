
# ADB
BPROP "system" "ro.adb.secure" "0"
BPROP "vendor" "ro.adb.secure" "0"
						   					   
		

# AstroROM props		
ROM_BUILD_ID="$(GET_PROP "system" "ro.build.display.id")"


if [[ "$ROM_BUILD_ID" == *Astro* ]]; then
    ASTROROM_PROP="$ROM_BUILD_ID"
else
    ASTROROM_PROP="AstroROM ${ROM_VERSION} [${ROM_BUILD_ID}]"
fi

BPROP "system" "ro.build.display.id" "$ASTROROM_PROP"					  
					

# Remove samsung data gather
FF "CONTEXTSERVICE_ENABLE_SURVEY_MODE" ""
