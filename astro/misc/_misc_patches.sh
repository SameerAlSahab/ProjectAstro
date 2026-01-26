#!/usr/bin/env bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#



# ADB
BPROP "system" "ro.adb.secure" "0"
BPROP "vendor" "ro.adb.secure" "0"
						   					   

ROM_BUILD_ID="$(GET_PROP "system" "ro.build.display.id")"


if [[ "$ROM_BUILD_ID" == *Astro* ]]; then
    ASTROROM_PROP="$ROM_BUILD_ID"
else
    ASTROROM_PROP="AstroROM ${ROM_VERSION} [${ROM_BUILD_ID}]"
fi

BPROP "system" "ro.build.display.id" "$ASTROROM_PROP"					  
					

# Remove samsung data gather
FF "CONTEXTSERVICE_ENABLE_SURVEY_MODE" ""
