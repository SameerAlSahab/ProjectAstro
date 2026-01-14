.class public final Lcom/samsung/android/displaysolution/EyeComfortSolutionService;
.super Ljava/lang/Object;
.source "qb/103929649 219d93a284d1fff4b5709e5ce2b5a222211f6ba2ee96a17027c5dc5683cbd672"


# instance fields
.field public final ACTION_GET_BOPR_VALUE_DEBOUNCE_MILLIS:I

.field public final BOPR_MAX_VALUE:I

.field public BOPR_VALUE_STEP:I

.field public final GET_SYSTEM_SERVICES_MILLIS:I

.field public app_weighting_factor:F

.field public bopr_cumulative_count:I

.field public cal_value_sum:F

.field public defaultBedTime:I

.field public defaultWakeupTime:I

.field public final mAdaptiveBlueLightFilterSupported:Z

.field public mBedtime_friday:I

.field public mBedtime_monday:I

.field public mBedtime_saturday:I

.field public mBedtime_sunday:I

.field public mBedtime_thursday:I

.field public mBedtime_tuesday:I

.field public mBedtime_wednesday:I

.field public mBlfIndexEadOffset:I

.field public mBlueLightFilterAdaptiveModeEnabled:Z

.field public mBlueLightFilterCustomAlwaysOn:Z

.field public mBlueLightFilterEnableTime:Z

.field public mBlueLightFilterModeEnabled:Z

.field public mBlueLightFilterScheduledTime:Z

.field public mBoprSensor:Landroid/hardware/Sensor;

.field public final mBoprSensorListener:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;

.field public final mColorOnPixelRatioSupported:Z

.field public final mContext:Landroid/content/Context;

.field public mCurrentStateSleep:Z

.field public mCurrentStateWakeup:Z

.field public mDefaultThemeEnabled:Z

.field public mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

.field public final mEnvironmentAdaptiveDisplaySupported:Z

.field public final mHandler:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

.field public mLastBoprBlueLightFilterIndex:I

.field public mLastDayBlueLightFilterIndex:I

.field public mLastTotalBlueLightFilterIndex:I

.field public mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

.field public final mNaturalGammaScreenModeSupported:Z

.field public final mNaturalModeVersion:I

.field public mNightDimFontConfigValue:I

.field public mNightDimFontConfigValuePrev:I

.field public mNightDimModeEnabled:Z

.field public mPrevClutValue:I

.field public mPrevmDNIeMode:Ljava/lang/String;

.field public mScreenModeSetting:I

.field public mScreenOn:Z

.field public mSemHqmManager:Landroid/os/SemHqmManager;

.field public mSensorManager:Landroid/hardware/SensorManager;

.field public final mSupportAPmDNIe:Z

.field public mWakeupTime_friday:I

.field public mWakeupTime_monday:I

.field public mWakeupTime_saturday:I

.field public mWakeupTime_sunday:I

.field public mWakeupTime_thursday:I

.field public mWakeupTime_tuesday:I

.field public mWakeupTime_wednesday:I

.field public prevTotalStep:I


# direct methods
.method public static -$$Nest$mgetBoprValue(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;Z)V
    .locals 5

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mSupportAPmDNIe:Z

    if-eqz p1, :cond_46

    iget-object p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mHandler:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

    if-eqz v1, :cond_37

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v2}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->getCoprValue()I

    move-result v2

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    add-int/lit8 v3, v3, 0x1

    iput v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    iget-boolean v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    if-eqz v4, :cond_21

    invoke-virtual {p0, v2, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->blue_light_filter_setting_bopr(II)V

    :cond_21
    iget v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    const/16 v3, 0x36

    if-ge v2, v3, :cond_53

    iget-boolean v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    if-eqz v2, :cond_53

    const/4 v2, 0x2

    invoke-virtual {p1, v2}, Landroid/os/Handler;->removeMessages(I)V

    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->ACTION_GET_BOPR_VALUE_DEBOUNCE_MILLIS:I

    int-to-long v3, p0

    add-long/2addr v0, v3

    invoke-virtual {p1, v2, v0, v1}, Landroid/os/Handler;->sendEmptyMessageAtTime(IJ)Z

    return-void

    :cond_37
    iget-object v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mSensorManager:Landroid/hardware/SensorManager;

    if-eqz v1, :cond_53

    if-eqz v0, :cond_53

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBoprSensorListener:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;

    iget-object p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBoprSensor:Landroid/hardware/Sensor;

    const/4 v2, 0x3

    invoke-virtual {v1, v0, p0, v2, p1}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;ILandroid/os/Handler;)Z

    return-void

    :cond_46
    if-nez v1, :cond_53

    iget-object p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mSensorManager:Landroid/hardware/SensorManager;

    if-eqz p1, :cond_53

    if-eqz v0, :cond_53

    iget-object p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBoprSensorListener:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;

    invoke-virtual {p1, p0}, Landroid/hardware/SensorManager;->unregisterListener(Landroid/hardware/SensorEventListener;)V

    :cond_53
    return-void
.end method

.method public static -$$Nest$msetting_is_changed(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;)V
    .locals 8

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    const-string/jumbo v3, "blue_light_filter"

    const/4 v4, 0x0

    const/4 v5, -0x2

    invoke-static {v0, v3, v4, v5}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v3

    const/4 v6, 0x1

    if-ne v3, v6, :cond_18

    move v3, v6

    goto :goto_19

    :cond_18
    move v3, v4

    :goto_19
    iput-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    const-string/jumbo v3, "blue_light_filter_night_dim"

    invoke-static {v0, v3, v4, v5}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v3

    if-ne v3, v6, :cond_26

    move v3, v6

    goto :goto_27

    :cond_26
    move v3, v4

    :goto_27
    iput-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimModeEnabled:Z

    const-string/jumbo v3, "blue_light_filter_adaptive_mode"

    invoke-static {v0, v3, v4, v5}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v3

    if-ne v3, v6, :cond_34

    move v3, v6

    goto :goto_35

    :cond_34
    move v3, v4

    :goto_35
    iput-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    const-string/jumbo v3, "current_sec_active_themepackage"

    invoke-static {v0, v3, v5}, Landroid/provider/Settings$System;->getStringForUser(Landroid/content/ContentResolver;Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_42

    move v3, v6

    goto :goto_43

    :cond_42
    move v3, v4

    :goto_43
    iput-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDefaultThemeEnabled:Z

    const-string/jumbo v3, "blue_light_filter_type"

    invoke-static {v0, v3, v4, v5}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    if-nez v0, :cond_50

    move v0, v6

    goto :goto_51

    :cond_50
    move v0, v4

    :goto_51
    iput-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterCustomAlwaysOn:Z

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v3, "screen_mode_setting"

    const/4 v7, 0x4

    invoke-static {v0, v3, v7, v5}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenModeSetting:I

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v3, "mBlueLightFilterModeEnabled : "

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , mNightDimModeEnabled : "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimModeEnabled:Z

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , mBlueLightFilterAdaptiveModeEnabled : "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , mDefaultThemeEnabled : "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDefaultThemeEnabled:Z

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , mBlueLightFilterCustomAlwaysOn : "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterCustomAlwaysOn:Z

    const-string v5, "EyeComfortSolutionService"

    invoke-static {v5, v0, v3}, Lcom/android/server/AnyMotionDetector$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/StringBuilder;Z)V

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    iget-object v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mHandler:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

    const/4 v7, 0x2

    if-eqz v0, :cond_c0

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    if-eqz v0, :cond_c0

    const-string v0, "All"

    invoke-virtual {p0, v0}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    invoke-virtual {p0, v6}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->blue_light_filter_setting_day(Z)V

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenOn:Z

    if-eqz v0, :cond_e0

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    if-eqz v0, :cond_e0

    invoke-virtual {v3, v7}, Landroid/os/Handler;->removeMessages(I)V

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->ACTION_GET_BOPR_VALUE_DEBOUNCE_MILLIS:I

    int-to-long v4, v0

    add-long/2addr v1, v4

    invoke-virtual {v3, v7, v1, v2}, Landroid/os/Handler;->sendEmptyMessageAtTime(IJ)Z

    goto :goto_e0

    :cond_c0
    invoke-virtual {p0, v4}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->blue_light_filter_setting_day(Z)V

    invoke-virtual {v3, v7}, Landroid/os/Handler;->removeMessages(I)V

    const/4 v0, 0x3

    invoke-virtual {v3, v0}, Landroid/os/Handler;->removeMessages(I)V

    invoke-virtual {v3, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    const-string/jumbo v0, "reset blue_light_filter_data_reset"

    invoke-static {v5, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    const/4 v0, 0x0

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    :cond_e0
    :goto_e0
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    invoke-virtual {p0, v0}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateNightDimSettings(I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 16

    move-object/from16 v0, p0

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    const/4 v1, 0x0

    iput-object v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevmDNIeMode:Ljava/lang/String;

    const-string/jumbo v2, "eng"

    sget-object v3, Landroid/os/Build;->TYPE:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    const/16 v2, 0xfa0

    iput v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->GET_SYSTEM_SERVICES_MILLIS:I

    const/16 v3, 0x2710

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->ACTION_GET_BOPR_VALUE_DEBOUNCE_MILLIS:I

    const/4 v3, 0x0

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_MAX_VALUE:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    const/4 v4, 0x4

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenModeSetting:I

    const/4 v4, -0x1

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    const/high16 v5, 0x3f800000    # 1.0f

    iput v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->app_weighting_factor:F

    const/4 v5, 0x0

    iput v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValuePrev:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    const/16 v5, 0x168

    iput v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_sunday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_monday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_tuesday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_wednesday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_thursday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_friday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_saturday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_sunday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_monday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_tuesday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_wednesday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_thursday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_friday:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_saturday:I

    iput v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalModeVersion:I

    iput-object v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBoprSensor:Landroid/hardware/Sensor;

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mSupportAPmDNIe:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenOn:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimModeEnabled:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDefaultThemeEnabled:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mAdaptiveBlueLightFilterSupported:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterScheduledTime:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterCustomAlwaysOn:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mEnvironmentAdaptiveDisplaySupported:Z

    iput-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalGammaScreenModeSupported:Z

    new-instance v1, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;

    invoke-direct {v1, v0}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;-><init>(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;)V

    iput-object v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBoprSensorListener:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$1;

    move-object/from16 v5, p1

    iput-object v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    const-string v1, "EyeComfortSolutionServiceThread"

    invoke-static {v1}, Lcom/android/server/KnoxCaptureInputFilter$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Landroid/os/HandlerThread;

    move-result-object v1

    new-instance v11, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v11, v0, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;-><init>(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;Landroid/os/Looper;)V

    iput-object v11, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mHandler:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v6, 0x11101b0

    invoke-virtual {v1, v6}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v1

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v6

    const v7, 0x10e0020

    invoke-virtual {v6, v7}, Landroid/content/res/Resources;->getInteger(I)I

    move-result v6

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_MAX_VALUE:I

    const/4 v12, 0x1

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mEnvironmentAdaptiveDisplaySupported:Z

    const-string v13, "EyeComfortSolutionService"

    const-string/jumbo v6, "mEnvironmentAdaptiveDisplaySupported true"

    invoke-static {v13, v6}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v6, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$SettingsObserver;

    invoke-direct {v6, v0, v11}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$SettingsObserver;-><init>(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;)V

    invoke-virtual {v5}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v14

    const-string/jumbo v8, "blue_light_filter"

    invoke-static {v8}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v7, v8, v3, v6, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v8, "blue_light_filter_night_dim"

    invoke-static {v8}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v7, v8, v3, v6, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v8, "blue_light_filter_adaptive_mode"

    invoke-static {v8}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v7, v8, v3, v6, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v8, "current_sec_active_themepackage"

    invoke-static {v8}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v7, v8, v3, v6, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v8, "blue_light_filter_type"

    invoke-static {v8}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    invoke-virtual {v7, v8, v3, v6, v4}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "screen_mode_setting"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    const/4 v8, -0x2

    invoke-virtual {v7, v4, v3, v6, v8}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    new-instance v8, Landroid/content/IntentFilter;

    invoke-direct {v8}, Landroid/content/IntentFilter;-><init>()V

    const-string/jumbo v4, "android.intent.action.BOOT_COMPLETED"

    const-string/jumbo v6, "android.intent.action.USER_SWITCHED"

    const-string/jumbo v7, "android.intent.action.SCREEN_ON"

    const-string/jumbo v9, "android.intent.action.SCREEN_OFF"

    invoke-static {v8, v4, v6, v7, v9}, Lcom/android/server/am/ActivityManagerService$$ExternalSyntheticOutline0;->m(Landroid/content/IntentFilter;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v4, "android.intent.action.USER_PRESENT"

    const-string/jumbo v6, "android.intent.action.TIME_TICK"

    const-string/jumbo v7, "android.intent.action.TIME_SET"

    const-string/jumbo v9, "android.intent.action.TIMEZONE_CHANGED"

    invoke-static {v8, v4, v6, v7, v9}, Lcom/android/server/am/ActivityManagerService$$ExternalSyntheticOutline0;->m(Landroid/content/IntentFilter;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v4, "com.sec.android.intent.action.HQM_UPDATE_REQ"

    invoke-virtual {v8, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    new-instance v6, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ScreenWatchingReceiver;

    invoke-direct {v6, v0}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ScreenWatchingReceiver;-><init>(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;)V

    sget-object v7, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    const/4 v9, 0x0

    const/4 v10, 0x0

    invoke-virtual/range {v5 .. v10}, Landroid/content/Context;->registerReceiverAsUser(Landroid/content/BroadcastReceiver;Landroid/os/UserHandle;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    invoke-virtual {v11, v12}, Landroid/os/Handler;->removeMessages(I)V

    int-to-long v4, v2

    add-long/2addr v14, v4

    invoke-virtual {v11, v12, v14, v15}, Landroid/os/Handler;->sendEmptyMessageAtTime(IJ)Z

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v2

    const-string/jumbo v4, "SEC_FLOATING_FEATURE_LCD_SUPPORT_BLUE_FILTER_ADAPTIVE_MODE"

    invoke-virtual {v2, v4, v3}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v2

    if-lez v2, :cond_153

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mAdaptiveBlueLightFilterSupported:Z

    :cond_153
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v2

    invoke-virtual {v2, v4, v3}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v2

    if-ne v2, v12, :cond_15f

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    :cond_15f
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v2

    const-string/jumbo v4, "SEC_FLOATING_FEATURE_LCD_CONFIG_NATURAL_MODE_TYPE"

    invoke-virtual {v2, v4, v3}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v2

    if-lez v2, :cond_178

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalGammaScreenModeSupported:Z

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v2

    invoke-virtual {v2, v4, v3}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v2

    iput v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalModeVersion:I

    :cond_178
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v2

    const-string/jumbo v3, "SEC_FLOATING_FEATURE_LCD_CONFIG_HW_MDNIE"

    invoke-virtual {v2, v3}, Lcom/samsung/android/feature/SemFloatingFeature;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "DDI"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_18d

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mSupportAPmDNIe:Z

    :cond_18d
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "A_BLF : "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mAdaptiveBlueLightFilterSupported:Z

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , COPR_IP : "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v0, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v13, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string/jumbo v0, "sys.eyecomfortsolution.ecson"

    const-string/jumbo v2, "false"

    invoke-static {v0, v2}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz v1, :cond_1bb

    const-string/jumbo v1, "true"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1bb
    const-string v0, "EyeComfortSolutionService Enabled"

    invoke-static {v13, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static sysfsWrite(ILjava/lang/String;)V
    .locals 2

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result p1

    if-eqz p1, :cond_35

    const/4 p1, 0x0

    :try_start_c
    new-instance v1, Ljava/io/FileOutputStream;

    invoke-direct {v1, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_11
    .catch Ljava/io/FileNotFoundException; {:try_start_c .. :try_end_11} :catch_25
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_11} :catch_23

    :try_start_11
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_1f
    .catch Ljava/io/IOException; {:try_start_11 .. :try_end_1f} :catch_20

    return-void

    :catch_20
    move-exception p0

    move-object p1, v1

    goto :goto_2a

    :catch_23
    move-exception p0

    goto :goto_2a

    :catch_25
    move-exception p0

    :try_start_26
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V
    :try_end_29
    .catch Ljava/io/IOException; {:try_start_26 .. :try_end_29} :catch_23

    goto :goto_35

    :goto_2a
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :try_start_2d
    invoke-virtual {p1}, Ljava/io/FileOutputStream;->close()V
    :try_end_30
    .catch Ljava/lang/Exception; {:try_start_2d .. :try_end_30} :catch_31

    goto :goto_35

    :catch_31
    move-exception p0

    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_35
    :goto_35
    return-void
.end method


# virtual methods
.method public final blue_light_filter_setting_bopr(II)V
    .locals 7

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v1, "screen_brightness"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    int-to-float v0, v0

    int-to-float p1, p1

    const/high16 v1, 0x43800000    # 256.0f

    div-float v1, p1, v1

    float-to-double v3, v1

    const-wide v5, 0x40019999a0000000L    # 2.200000047683716

    invoke-static {v3, v4, v5, v6}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v3

    iget v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->app_weighting_factor:F

    mul-float/2addr v1, v0

    float-to-double v5, v1

    mul-double/2addr v3, v5

    double-to-float v1, v3

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    add-float/2addr v3, v1

    iput v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    new-instance v3, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "count : "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " , bopr_value : "

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p1, ", platform_value : "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p1, " , app_weighting : "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->app_weighting_factor:F

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p1, " , cal_value : "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p1, " , sum_value : "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p1, " , BOPR_MAX_VALUE : "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_MAX_VALUE:I

    const-string p2, "EyeComfortSolutionService"

    invoke-static {v3, p1, p2}, Lcom/android/server/alarm/GmsAlarmManager$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    const/16 v1, 0x36

    if-ge v0, v1, :cond_b8

    :goto_77
    if-ge v2, v1, :cond_b8

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    div-int/lit8 v3, p1, 0x36

    iget v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    add-int/lit8 v5, v4, 0x1

    mul-int/2addr v3, v5

    int-to-float v3, v3

    cmpl-float v0, v0, v3

    if-ltz v0, :cond_b5

    if-ne v4, v2, :cond_b5

    iput v5, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "Change BLF step by B-opr, BLF dayIndex : ["

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string/jumbo v3, "] , boprIndex : ["

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    const-string/jumbo v4, "]"

    invoke-static {v3, v4, p2, v0}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    add-int/2addr v0, v3

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/4 v3, 0x1

    invoke-virtual {p0, v0, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    add-int/2addr v0, v3

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    :cond_b5
    add-int/lit8 v2, v2, 0x1

    goto :goto_77

    :cond_b8
    return-void
.end method

.method public final blue_light_filter_setting_day(Z)V
    .locals 19

    move-object/from16 v0, p0

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    new-instance v3, Ljava/text/SimpleDateFormat;

    const-string v4, "EE"

    sget-object v5, Ljava/util/Locale;->ENGLISH:Ljava/util/Locale;

    invoke-direct {v3, v4, v5}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v4, Ljava/text/SimpleDateFormat;

    const-string v5, "HH"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v6

    invoke-direct {v4, v5, v6}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v5, Ljava/text/SimpleDateFormat;

    const-string/jumbo v6, "mm"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v7

    invoke-direct {v5, v6, v7}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v6, Ljava/util/Date;

    invoke-direct {v6}, Ljava/util/Date;-><init>()V

    invoke-virtual {v3, v6}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v3

    new-instance v6, Ljava/util/Date;

    invoke-direct {v6}, Ljava/util/Date;-><init>()V

    invoke-virtual {v4, v6}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v4

    new-instance v6, Ljava/util/Date;

    invoke-direct {v6}, Ljava/util/Date;-><init>()V

    invoke-virtual {v5, v6}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    mul-int/lit8 v6, v6, 0x3c

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    add-int/2addr v7, v6

    const-string v8, "EyeComfortSolutionService"

    const/4 v9, 0x0

    if-eqz p1, :cond_2f2

    iget v10, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v11, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    const/4 v12, 0x1

    if-lt v10, v11, :cond_66

    if-le v7, v11, :cond_61

    if-gt v7, v10, :cond_61

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    iput-boolean v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    goto :goto_73

    :cond_61
    iput-boolean v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    goto :goto_73

    :cond_66
    if-le v7, v10, :cond_6f

    if-gt v7, v11, :cond_6f

    iput-boolean v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    goto :goto_73

    :cond_6f
    iput-boolean v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    iput-boolean v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    :goto_73
    iget-boolean v10, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    const-string v13, " , TimeValue : "

    const-string v14, " , Minute : "

    const-string v15, " , Hour : "

    const-string/jumbo v6, "Week : "

    if-eqz v10, :cond_132

    invoke-static {v6, v3, v15, v4, v14}, Landroid/net/shared/InitialConfiguration$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v9, " , wakeup state, defaultBedTime : "

    invoke-static {v7, v5, v13, v9, v10}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " , start sleep : "

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    add-int/lit16 v9, v9, -0x168

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v8, v9}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    add-int/lit16 v10, v9, -0x168

    iget v12, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->ACTION_GET_BOPR_VALUE_DEBOUNCE_MILLIS:I

    iget-object v11, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mHandler:Lcom/samsung/android/displaysolution/EyeComfortSolutionService$ECSControlHandler;

    if-gez v10, :cond_f3

    add-int/lit16 v10, v9, 0x438

    if-lt v7, v10, :cond_d3

    move-wide/from16 v17, v1

    const/16 v1, 0x5a0

    if-ge v7, v1, :cond_d3

    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    if-ne v7, v10, :cond_c8

    iget-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenOn:Z

    if-eqz v1, :cond_c8

    const/4 v1, 0x2

    invoke-virtual {v11, v1}, Landroid/os/Handler;->removeMessages(I)V

    int-to-long v9, v12

    add-long v9, v17, v9

    invoke-virtual {v11, v1, v9, v10}, Landroid/os/Handler;->sendEmptyMessageAtTime(IJ)Z

    :cond_c8
    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    add-int/lit16 v1, v1, 0x438

    sub-int v1, v7, v1

    div-int/lit8 v1, v1, 0xa

    const/4 v2, 0x1

    :goto_d1
    add-int/2addr v1, v2

    goto :goto_12b

    :cond_d3
    const/4 v2, 0x1

    if-ltz v7, :cond_e0

    if-ge v7, v9, :cond_e0

    iput-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v9, v7

    rsub-int v1, v9, 0x168

    div-int/lit8 v1, v1, 0xa

    goto :goto_d1

    :cond_e0
    if-ne v7, v9, :cond_ee

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    const-string/jumbo v2, "WakeupTime"

    invoke-virtual {v0, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    :goto_eb
    const/16 v1, 0x24

    goto :goto_12b

    :cond_ee
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    :cond_f1
    :goto_f1
    const/4 v1, 0x0

    goto :goto_12b

    :cond_f3
    move-wide/from16 v17, v1

    if-ltz v10, :cond_f1

    if-lt v7, v10, :cond_11b

    if-ge v7, v9, :cond_11b

    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    if-ne v7, v10, :cond_10e

    iget-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenOn:Z

    if-eqz v1, :cond_10e

    const/4 v1, 0x2

    invoke-virtual {v11, v1}, Landroid/os/Handler;->removeMessages(I)V

    int-to-long v9, v12

    add-long v9, v17, v9

    invoke-virtual {v11, v1, v9, v10}, Landroid/os/Handler;->sendEmptyMessageAtTime(IJ)Z

    :cond_10e
    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    add-int/lit16 v1, v1, -0x168

    sub-int v1, v7, v1

    div-int/lit8 v1, v1, 0xa

    const/16 v16, 0x1

    add-int/lit8 v1, v1, 0x1

    goto :goto_12b

    :cond_11b
    if-ne v7, v9, :cond_127

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    const-string/jumbo v2, "NextWakeupTime"

    invoke-virtual {v0, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    goto :goto_eb

    :cond_127
    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    goto :goto_f1

    :goto_12b
    const-string/jumbo v2, "currentWakeupStep : "

    invoke-static {v1, v2, v8}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_133

    :cond_132
    const/4 v1, 0x0

    :goto_133
    iget-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    if-eqz v2, :cond_250

    iget-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    const-string v9, " , start wakeup : "

    const-string v10, " , sleep state, defaultWakeupTime : "

    const-string v11, "BedTime"

    if-eqz v2, :cond_1dc

    invoke-static {v6, v3, v15, v4, v14}, Landroid/net/shared/InitialConfiguration$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v7, v5, v13, v10, v2}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    add-int/lit16 v3, v3, -0xb4

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v8, v2}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    add-int/lit16 v3, v2, -0xb4

    const/4 v4, 0x0

    const-string/jumbo v5, "reset blue_light_filter_data_reset"

    if-gez v3, :cond_1af

    add-int/lit16 v3, v2, 0x4ec

    if-lt v7, v3, :cond_17a

    const/16 v6, 0x5a0

    if-ge v7, v6, :cond_17a

    const/4 v6, 0x0

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v7, v3

    const/4 v3, 0x2

    div-int/2addr v7, v3

    :goto_176
    rsub-int/lit8 v9, v7, 0x59

    goto/16 :goto_249

    :cond_17a
    const/4 v3, 0x2

    const/4 v6, 0x0

    if-ltz v7, :cond_18a

    if-ge v7, v2, :cond_18a

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v2, v7

    rsub-int v2, v2, 0xb4

    div-int/2addr v2, v3

    rsub-int/lit8 v9, v2, 0x59

    goto/16 :goto_249

    :cond_18a
    if-ne v7, v2, :cond_1a3

    invoke-static {v8, v5}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    invoke-virtual {v0, v11}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    :goto_1a0
    move v9, v6

    goto/16 :goto_249

    :cond_1a3
    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    iget v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/16 v2, 0x24

    if-ge v9, v2, :cond_249

    :goto_1ab
    const/16 v9, 0x24

    goto/16 :goto_249

    :cond_1af
    const/4 v6, 0x0

    if-ltz v3, :cond_248

    if-lt v7, v3, :cond_1bc

    if-ge v7, v2, :cond_1bc

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v7, v3

    const/4 v3, 0x2

    div-int/2addr v7, v3

    goto :goto_176

    :cond_1bc
    if-ne v7, v2, :cond_1d3

    invoke-static {v8, v5}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->BOPR_VALUE_STEP:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->bopr_cumulative_count:I

    iput v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->cal_value_sum:F

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    iput v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    invoke-virtual {v0, v11}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    goto :goto_1a0

    :cond_1d3
    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    iget v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/16 v2, 0x24

    if-ge v9, v2, :cond_249

    goto :goto_1ab

    :cond_1dc
    if-nez v2, :cond_248

    invoke-static {v6, v3, v15, v4, v14}, Landroid/net/shared/InitialConfiguration$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v7, v5, v13, v10, v2}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    add-int/lit16 v3, v3, -0xb4

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v8, v2}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    add-int/lit16 v3, v2, -0xb4

    if-gez v3, :cond_22e

    add-int/lit16 v3, v2, 0x4ec

    if-lt v7, v3, :cond_212

    const/16 v6, 0x5a0

    if-ge v7, v6, :cond_212

    const/4 v6, 0x0

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v7, v3

    div-int/lit8 v7, v7, 0x5

    :goto_20f
    rsub-int/lit8 v9, v7, 0x23

    goto :goto_249

    :cond_212
    const/4 v6, 0x0

    if-ltz v7, :cond_221

    if-ge v7, v2, :cond_221

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v2, v7

    rsub-int v2, v2, 0xb4

    div-int/lit8 v2, v2, 0x5

    rsub-int/lit8 v9, v2, 0x23

    goto :goto_249

    :cond_221
    if-ne v7, v2, :cond_22a

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    invoke-virtual {v0, v11}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    goto/16 :goto_1a0

    :cond_22a
    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    goto/16 :goto_1ab

    :cond_22e
    const/4 v6, 0x0

    if-ltz v3, :cond_248

    if-lt v7, v3, :cond_23b

    if-ge v7, v2, :cond_23b

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    sub-int/2addr v7, v3

    div-int/lit8 v7, v7, 0x5

    goto :goto_20f

    :cond_23b
    if-ne v7, v2, :cond_244

    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    invoke-virtual {v0, v11}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateSleepWakeupTime(Ljava/lang/String;)V

    goto/16 :goto_1a0

    :cond_244
    iput-boolean v6, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterEnableTime:Z

    goto/16 :goto_1ab

    :cond_248
    const/4 v9, 0x0

    :cond_249
    :goto_249
    const-string/jumbo v2, "currentSleepStep : "

    invoke-static {v9, v2, v8}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_251

    :cond_250
    const/4 v9, 0x0

    :goto_251
    iget-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateWakeup:Z

    const-string/jumbo v3, "] , boprIndex : ["

    const-string v4, "Change BLF step by mCurrentStateWakeup, BLF dayIndex : ["

    const-string/jumbo v5, "]"

    if-eqz v2, :cond_283

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    if-eq v2, v1, :cond_314

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    invoke-static {v2, v5, v8, v1}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    add-int/2addr v1, v2

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    return-void

    :cond_283
    iget-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mCurrentStateSleep:Z

    if-eqz v1, :cond_314

    iget-boolean v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    if-eqz v1, :cond_2ca

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    const/4 v2, -0x1

    if-ne v1, v2, :cond_2ab

    const/16 v2, 0x24

    if-le v9, v2, :cond_295

    move v9, v2

    :cond_295
    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Change BLF step by mCurrentStateSleep_1, BLF totalIndex : ["

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    invoke-static {v2, v5, v8, v1}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    :cond_2ab
    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    if-eq v1, v9, :cond_314

    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    if-ge v9, v1, :cond_314

    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Change BLF step by mCurrentStateSleep_2, BLF totalIndex : ["

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    invoke-static {v2, v5, v8, v1}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    return-void

    :cond_2ca
    if-nez v1, :cond_314

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    if-eq v1, v9, :cond_314

    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    iput v9, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    invoke-static {v2, v5, v8, v1}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    add-int/2addr v1, v2

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    return-void

    :cond_2f2
    const/4 v2, -0x1

    iput v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->prevTotalStep:I

    const/4 v1, 0x0

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    const-string/jumbo v2, "set ead offset to 0"

    invoke-static {v8, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iput v1, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    iget-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    if-nez v2, :cond_314

    iget-boolean v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    if-eqz v2, :cond_314

    iget v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastDayBlueLightFilterIndex:I

    iget v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastBoprBlueLightFilterIndex:I

    add-int/2addr v2, v3

    iput v2, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mLastTotalBlueLightFilterIndex:I

    invoke-virtual {v0, v2, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->setBlueLightFilterMode(IZ)V

    :cond_314
    return-void
.end method

.method public final setBlueLightFilterMode(IZ)V
    .locals 17

    move-object/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    iget-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mAdaptiveBlueLightFilterSupported:Z

    if-eqz v3, :cond_c3

    iget-boolean v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mColorOnPixelRatioSupported:Z

    const-string v4, " , ead offset : "

    const-string v5, " + 11] = "

    const-string v6, " , targetIndex : ["

    const-string v7, "BLF Adaptive Mode Enable : "

    const-string v8, "EyeComfortSolutionService"

    const-wide v9, 0x403638e38e38e38eL    # 22.22222222222222

    const-wide v11, 0x40b7700000000000L    # 6000.0

    if-eqz v3, :cond_37

    int-to-double v13, v1

    mul-double/2addr v13, v9

    sub-double v13, v11, v13

    invoke-static {v1, v7, v6, v5, v2}, Lcom/android/server/accessibility/AccessibilityManagerService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v13, v14}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    invoke-static {v5, v4, v8}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    :cond_35
    move-wide v15, v9

    goto :goto_52

    :cond_37
    if-nez v3, :cond_35

    const-wide v13, 0x404bc71c71c71c72L    # 55.55555555555556

    move-wide v15, v9

    int-to-double v9, v1

    mul-double/2addr v9, v13

    sub-double v9, v11, v9

    invoke-static {v1, v7, v6, v5, v2}, Lcom/android/server/accessibility/AccessibilityManagerService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9, v10}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    invoke-static {v5, v4, v8}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    :goto_52
    iget-object v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    const-string/jumbo v5, "mDNIe"

    invoke-virtual {v4, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/samsung/android/hardware/display/SemMdnieManager;

    iput-object v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    new-instance v4, Ljava/lang/StringBuilder;

    const-string/jumbo v5, "mMdnieManager : "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v8, v4}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I

    iget-boolean v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mEnvironmentAdaptiveDisplaySupported:Z

    if-nez v4, :cond_8f

    iget-object v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    if-eqz v3, :cond_c0

    add-int/lit8 v4, v1, 0xb

    invoke-virtual {v3, v4}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightModeStep(I)Z

    iget-object v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    int-to-double v5, v1

    mul-double/2addr v5, v15

    sub-double/2addr v11, v5

    double-to-int v5, v11

    invoke-virtual {v3, v5}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightModeCct(I)Z

    iget-object v3, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    invoke-virtual {v3, v2, v4}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightMode(ZI)Z

    goto :goto_c0

    :cond_8f
    if-eqz v4, :cond_c0

    iget-object v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    if-eqz v4, :cond_c0

    if-eqz v3, :cond_9a

    const/16 v3, 0x65

    goto :goto_a0

    :cond_9a
    if-nez v3, :cond_9f

    const/16 v3, 0x2f

    goto :goto_a0

    :cond_9f
    const/4 v3, 0x0

    :goto_a0
    iget v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    add-int/2addr v5, v1

    add-int/lit8 v5, v5, 0xb

    if-le v5, v3, :cond_a8

    goto :goto_a9

    :cond_a8
    move v3, v5

    :goto_a9
    invoke-virtual {v4, v3}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightModeStep(I)Z

    iget-object v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    int-to-double v5, v1

    mul-double/2addr v5, v15

    sub-double/2addr v11, v5

    iget v5, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlfIndexEadOffset:I

    mul-int/lit8 v5, v5, 0x16

    int-to-double v5, v5

    sub-double/2addr v11, v5

    double-to-int v5, v11

    invoke-virtual {v4, v5}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightModeCct(I)Z

    iget-object v4, v0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mMdnieManager:Lcom/samsung/android/hardware/display/SemMdnieManager;

    invoke-virtual {v4, v2, v3}, Lcom/samsung/android/hardware/display/SemMdnieManager;->setNightMode(ZI)Z

    :cond_c0
    :goto_c0
    invoke-virtual/range {p0 .. p1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->updateNightDimSettings(I)V

    :cond_c3
    return-void
.end method

.method public final updateNightDimSettings(I)V
    .locals 8

    iget-object v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_7d

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimModeEnabled:Z

    if-eqz v1, :cond_7d

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    const/16 v3, 0x4b

    const/16 v4, 0x20

    if-eqz v1, :cond_67

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDefaultThemeEnabled:Z

    if-eqz v1, :cond_64

    if-nez p1, :cond_21

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto/16 :goto_7f

    :cond_21
    const/16 v1, 0xb

    if-lez p1, :cond_2c

    if-gt p1, v1, :cond_2c

    const/16 v1, 0x26

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_2c
    const/16 v4, 0x16

    if-le p1, v1, :cond_37

    if-gt p1, v4, :cond_37

    const/16 v1, 0x2c

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_37
    const/16 v1, 0x22

    if-le p1, v4, :cond_42

    if-gt p1, v1, :cond_42

    const/16 v1, 0x32

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_42
    const/16 v4, 0x2d

    const/16 v5, 0x38

    if-le p1, v1, :cond_4d

    if-gt p1, v4, :cond_4d

    iput v5, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_4d
    if-le p1, v4, :cond_56

    if-gt p1, v5, :cond_56

    const/16 v1, 0x3e

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_56
    const/16 v1, 0x44

    if-le p1, v5, :cond_5f

    if-gt p1, v1, :cond_5f

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_5f
    if-le p1, v1, :cond_7f

    iput v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_64
    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_67
    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterScheduledTime:Z

    if-nez v1, :cond_73

    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterCustomAlwaysOn:Z

    if-eqz v1, :cond_70

    goto :goto_73

    :cond_70
    iput v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_73
    :goto_73
    iget-boolean v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mDefaultThemeEnabled:Z

    if-eqz v1, :cond_7a

    iput v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_7a
    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    goto :goto_7f

    :cond_7d
    iput v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    :cond_7f
    :goto_7f
    const-string/jumbo v1, "updateNightDimSettings index : "

    const-string v3, " , mNightDimFontConfigValue : "

    invoke-static {p1, v1, v3}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    const-string v4, "EyeComfortSolutionService"

    invoke-static {v1, v3, v4}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValuePrev:I

    if-eq v1, v3, :cond_d0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string/jumbo v3, "updateConfiguration ("

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValuePrev:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ") -> ("

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    const-string v5, ")"

    invoke-static {v3, v5, v4, v1}, Lcom/android/server/BinaryTransparencyService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    iget v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValue:I

    iput v1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimFontConfigValuePrev:I

    const-string/jumbo v3, "enhanced_comfort_font_value"

    const/4 v5, -0x2

    invoke-static {v0, v3, v1, v5}, Landroid/provider/Settings$Secure;->putIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)Z

    invoke-static {}, Landroid/app/ActivityManager;->getService()Landroid/app/IActivityManager;

    move-result-object v0

    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v1, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0, v0}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService$$ExternalSyntheticLambda0;-><init>(Lcom/samsung/android/displaysolution/EyeComfortSolutionService;Landroid/app/IActivityManager;)V

    const-wide/16 v5, 0x0

    invoke-virtual {v1, v3, v5, v6}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_d0
    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalGammaScreenModeSupported:Z

    const-string v1, "/sys/class/lcd/panel/night_dim"

    const-string v3, "/sys/class/lcd/panel1/night_dim"

    if-nez v0, :cond_176

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterModeEnabled:Z

    const-string/jumbo v5, "NIGHT_DIM Mode : 0 (CLUT Off setting)"

    if-eqz v0, :cond_15d

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNightDimModeEnabled:Z

    if-eqz v0, :cond_15d

    iget-boolean v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterAdaptiveModeEnabled:Z

    const-string/jumbo v6, "NIGHT_DIM Mode : 1 (CLUT On)"

    const/4 v7, 0x1

    if-eqz v0, :cond_122

    if-nez p1, :cond_109

    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eqz p0, :cond_1c0

    invoke-static {v2, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p0, Ljava/io/File;

    invoke-direct {p0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-eqz p0, :cond_102

    invoke-static {v2, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_102
    const-string/jumbo p0, "NIGHT_DIM Mode : 0 (CLUT Off index)"

    invoke-static {v4, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_109
    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eq p0, v7, :cond_1c0

    invoke-static {v7, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p0, Ljava/io/File;

    invoke-direct {p0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-eqz p0, :cond_11e

    invoke-static {v7, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_11e
    invoke-static {v4, v6}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_122
    iget-boolean p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterScheduledTime:Z

    if-nez p1, :cond_144

    iget-boolean p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBlueLightFilterCustomAlwaysOn:Z

    if-eqz p1, :cond_12b

    goto :goto_144

    :cond_12b
    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eqz p0, :cond_1c0

    invoke-static {v2, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p0, Ljava/io/File;

    invoke-direct {p0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-eqz p0, :cond_140

    invoke-static {v2, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_140
    invoke-static {v4, v5}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_144
    :goto_144
    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eq p0, v7, :cond_1c0

    invoke-static {v7, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p0, Ljava/io/File;

    invoke-direct {p0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-eqz p0, :cond_159

    invoke-static {v7, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_159
    invoke-static {v4, v6}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_15d
    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eqz p0, :cond_1c0

    invoke-static {v2, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p0, Ljava/io/File;

    invoke-direct {p0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-eqz p0, :cond_172

    invoke-static {v2, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_172
    invoke-static {v4, v5}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_176
    if-eqz v0, :cond_1c0

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mNaturalModeVersion:I

    const/4 v0, 0x2

    if-ne p1, v0, :cond_1c0

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mScreenModeSetting:I

    const/4 v5, 0x4

    if-ne p1, v5, :cond_1a0

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eqz p1, :cond_1c0

    invoke-static {v2, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p1, Ljava/io/File;

    invoke-direct {p1, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/io/File;->exists()Z

    move-result p1

    if-eqz p1, :cond_197

    invoke-static {v2, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_197
    iput v2, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    const-string/jumbo p0, "NIGHT_DIM_Mode : 0 (Vivid)"

    invoke-static {v4, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_1a0
    const/4 v2, 0x3

    if-ne p1, v2, :cond_1c0

    iget p1, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    if-eq p1, v0, :cond_1c0

    invoke-static {v0, v1}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    new-instance p1, Ljava/io/File;

    invoke-direct {p1, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/io/File;->exists()Z

    move-result p1

    if-eqz p1, :cond_1b8

    invoke-static {v0, v3}, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->sysfsWrite(ILjava/lang/String;)V

    :cond_1b8
    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mPrevClutValue:I

    const-string/jumbo p0, "NIGHT_DIM_Mode : 2 (Natural)"

    invoke-static {v4, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1c0
    return-void
.end method

.method public final updateSleepWakeupTime(Ljava/lang/String;)V
    .locals 12

    const-string/jumbo v0, "currentRubinState"

    const-string/jumbo v1, "isDeviceRubinSupported"

    const-string v2, "EyeComfortSolutionService"

    const-string/jumbo v3, "mRubinDataValid : "

    const-string/jumbo v4, "O-Runestone currentRubinState : "

    const-string v5, "D-Runestone isDeviceRubinSupported : "

    new-instance v6, Ljava/text/SimpleDateFormat;

    const-string v7, "HH"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v8

    invoke-direct {v6, v7, v8}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v7, Ljava/text/SimpleDateFormat;

    const-string/jumbo v8, "mm"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v9

    invoke-direct {v7, v8, v9}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v8, Ljava/util/Date;

    invoke-direct {v8}, Ljava/util/Date;-><init>()V

    invoke-virtual {v6, v8}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v6

    new-instance v8, Ljava/util/Date;

    invoke-direct {v8}, Ljava/util/Date;-><init>()V

    invoke-virtual {v7, v8}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v7

    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    const/4 v6, 0x0

    :try_start_40
    iget-object v7, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mContext:Landroid/content/Context;

    invoke-virtual {v7}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7

    const-string/jumbo v8, "content://com.samsung.android.rubin.state"

    invoke-static {v8}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v8

    const-string/jumbo v9, "getRubinState"

    const-string/jumbo v10, "com.samsung.android.bluelightfilter"

    const/4 v11, 0x0

    invoke-virtual {v7, v8, v9, v10, v11}, Landroid/content/ContentResolver;->call(Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object v7

    if-eqz v7, :cond_c2

    invoke-virtual {v7, v1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v8

    const/4 v9, 0x1

    if-eqz v8, :cond_7b

    invoke-virtual {v7, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v8
    :try_end_65
    .catch Ljava/lang/Exception; {:try_start_40 .. :try_end_65} :catch_c2

    if-eqz v8, :cond_7b

    :try_start_67
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_7a
    .catch Ljava/lang/Exception; {:try_start_67 .. :try_end_7a} :catch_c3

    goto :goto_b2

    :cond_7b
    :try_start_7b
    const-string/jumbo v1, "OK"

    invoke-virtual {v7, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1
    :try_end_86
    .catch Ljava/lang/Exception; {:try_start_7b .. :try_end_86} :catch_c2

    const-string/jumbo v5, "isEnabledInSupportedApps"

    if-eqz v1, :cond_92

    :try_start_8b
    invoke-virtual {v7, v5}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1
    :try_end_8f
    .catch Ljava/lang/Exception; {:try_start_8b .. :try_end_8f} :catch_c2

    if-eqz v1, :cond_92

    goto :goto_93

    :cond_92
    move v9, v6

    :goto_93
    :try_start_93
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " , isEnabledInSupportedApps : "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I

    :goto_b2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Slog;->v(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_c1
    .catch Ljava/lang/Exception; {:try_start_93 .. :try_end_c1} :catch_c3

    goto :goto_c3

    :catch_c2
    :cond_c2
    move v9, v6

    :catch_c3
    :goto_c3
    new-instance v0, Ljava/text/SimpleDateFormat;

    sget-object v1, Ljava/util/Locale;->ENGLISH:Ljava/util/Locale;

    const-string v3, "EE"

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v4, Ljava/util/Date;

    invoke-direct {v4}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v4}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v4, "Sun"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/16 v4, 0x168

    const-string/jumbo v5, "NextWakeupTime"

    const-string/jumbo v7, "WakeupTime"

    const-string v8, "BedTime"

    const/4 v10, -0x1

    if-eqz v0, :cond_127

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_sunday:I

    if-eq v0, v10, :cond_121

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_sunday:I

    if-eq v0, v10, :cond_121

    if-eqz v9, :cond_121

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_ff

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_sunday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_ff
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_10b

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_sunday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_10b
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_117

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_monday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_117
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_sunday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_sunday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_121
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_127
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v11, Ljava/util/Date;

    invoke-direct {v11}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v11}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v11, "Mon"

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17c

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_monday:I

    if-eq v0, v10, :cond_176

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_monday:I

    if-eq v0, v10, :cond_176

    if-eqz v9, :cond_176

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_154

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_monday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_154
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_160

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_monday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_160
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_16c

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_tuesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_16c
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_monday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_monday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_176
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_17c
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v11, Ljava/util/Date;

    invoke-direct {v11}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v11}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v11, "Tue"

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1d1

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_tuesday:I

    if-eq v0, v10, :cond_1cb

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_tuesday:I

    if-eq v0, v10, :cond_1cb

    if-eqz v9, :cond_1cb

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1a9

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_tuesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_1a9
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1b5

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_tuesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_1b5
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1c1

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_wednesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_1c1
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_tuesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_tuesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_1cb
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_1d1
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v11, Ljava/util/Date;

    invoke-direct {v11}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v11}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v11, "Wed"

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_226

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_wednesday:I

    if-eq v0, v10, :cond_220

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_wednesday:I

    if-eq v0, v10, :cond_220

    if-eqz v9, :cond_220

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1fe

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_wednesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_1fe
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_20a

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_wednesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_20a
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_216

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_thursday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_216
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_wednesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_wednesday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_220
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_226
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v11, Ljava/util/Date;

    invoke-direct {v11}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v11}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v11, "Thu"

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_27b

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_thursday:I

    if-eq v0, v10, :cond_275

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_thursday:I

    if-eq v0, v10, :cond_275

    if-eqz v9, :cond_275

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_253

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_thursday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_253
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_25f

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_thursday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_25f
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_26b

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_friday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_26b
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_thursday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_thursday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_275
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_27b
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v11, Ljava/util/Date;

    invoke-direct {v11}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v11}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string v11, "Fri"

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2cc

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_friday:I

    if-eq v0, v10, :cond_2c7

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_friday:I

    if-eq v0, v10, :cond_2c7

    if-eqz v9, :cond_2c7

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2a7

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_friday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto/16 :goto_31b

    :cond_2a7
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2b3

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_friday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto/16 :goto_31b

    :cond_2b3
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2be

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_saturday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_2be
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_friday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_friday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_2c7
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_2cc
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-direct {v0, v3, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "Sat"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_31b

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_saturday:I

    if-eq v0, v10, :cond_317

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_saturday:I

    if-eq v0, v10, :cond_317

    if-eqz v9, :cond_317

    invoke-virtual {v8, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2f8

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_saturday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    goto :goto_31b

    :cond_2f8
    invoke-virtual {v7, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_303

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_saturday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_303
    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_30e

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_sunday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_30e
    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mBedtime_saturday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->mWakeupTime_saturday:I

    iput v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    goto :goto_31b

    :cond_317
    iput v6, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    iput v4, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    :cond_31b
    :goto_31b
    const-string/jumbo v0, "updateSleepWakeupTime. type : "

    const-string v1, " , defaultBedTime : "

    invoke-static {v0, p1, v1}, Lcom/android/internal/util/jobs/DumpUtils$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget v0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultBedTime:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " , defaultWakeupTime : "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/samsung/android/displaysolution/EyeComfortSolutionService;->defaultWakeupTime:I

    invoke-static {p1, p0, v2}, Lcom/android/server/alarm/GmsAlarmManager$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    return-void
.end method
