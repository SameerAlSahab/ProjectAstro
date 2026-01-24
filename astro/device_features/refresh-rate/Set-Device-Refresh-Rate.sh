# High Refresh rate displays
# TODO: Edit SecSettings resolution string for actual hz
# TODO: Add  logic to remove high refresh rate option
# TODO As timer ms can vary upon devices , i will move them to platform for specific numbers. As of now kept this.

    FF_IF_DIFF "stock" "LCD_CONFIG_HFR_MODE"
    FF_IF_DIFF "stock" "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE"

FRAMERATE_OVERRIDE=$(GET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override")


# Use this values if not given
: "${IDLE_TIMER_MS:=250}"
: "${TOUCH_TIMER_MS:=300}"
: "${DISPLAY_POWER_TIMER_MS:=200}"


if [[ "$DEVICE_HAVE_HIGH_REFRESH_RATE" == "true" ]] && [[ "$FRAMERATE_OVERRIDE" != "true" ]]; then

    LOG_INFO "Adding Adaptive Refresh rate"
    BPROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    BPROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    BPROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"

    BPROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "$IDLE_TIMER_MS"
    BPROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "$TOUCH_TIMER_MS"
    BPROP "vendor" "ro.surface_flinger.set_display_power_timer_ms" "$DISPLAY_POWER_TIMER_MS"

    BPROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"

    # it is incomplete , required framework patches , will add soon
    if [[ -n "$DEVICE_DISPLAY_HFR_MODE" ]] && [[ -n "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ" ]]; then
        FF "LCD_CONFIG_HFR_MODE" "$DEVICE_DISPLAY_HFR_MODE"
        FF "LCD_CONFIG_HFR_SUPPORTED_REFRESH_RATE" "$DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ"
    fi
fi

if ! GET_FEAT_STATUS DEVICE_HAVE_HIGH_REFRESH_RATE; then
    ADD_PATCH "SecSettings.apk" "$SCRPATH/0/Disable-High-Refresh-Rate-Settings.smalipatch"
fi

