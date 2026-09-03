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


# TODO: Edit SecSettings resolution string for actual hz


FRAMERATE_OVERRIDE=$(GET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override")


# Use this values if not given
: "${IDLE_TIMER_MS:=250}"
: "${TOUCH_TIMER_MS:=300}"
: "${DISPLAY_POWER_TIMER_MS:=200}"


if GET_FEATURE DEVICE_HAVE_HIGH_REFRESH_RATE && [[ "$FRAMERATE_OVERRIDE" != "true" ]]; then

    LOG_BEGIN "Adding Adaptive Refresh rate"

    BPROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    BPROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    BPROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"

    BPROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "$IDLE_TIMER_MS"
    BPROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "$TOUCH_TIMER_MS"
    BPROP "vendor" "ro.surface_flinger.set_display_power_timer_ms" "$DISPLAY_POWER_TIMER_MS"

    BPROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"

# If device have custom hfr support , use it
if (( DEVICE_DISPLAY_HFR_MODE < 2 )); then
    HFR_VALUE=2
fi
        FF "LCD_CONFIG_HFR_MODE" "$HFR_VALUE"
        FF "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE" "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ"
fi

if ! GET_FEATURE DEVICE_HAVE_HIGH_REFRESH_RATE; then
    ADD_PATCH "SecSettings.apk" "$SCRPATH/patches/Disable-High-Refresh-Rate-Settings.smalipatch"
fi
