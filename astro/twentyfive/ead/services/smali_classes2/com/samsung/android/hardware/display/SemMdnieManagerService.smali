.class public Lcom/samsung/android/hardware/display/SemMdnieManagerService;
.super Lcom/samsung/android/hardware/display/ISemMdnieManager$Stub;
.source "qb/103929649 219d93a284d1fff4b5709e5ce2b5a222211f6ba2ee96a17027c5dc5683cbd672"


# instance fields
.field public final FP_FEATURE_SENSOR_IS_OPTICAL:Ljava/lang/String;

.field public final MDNIE_SUPPORT_FUNCTION:I

.field public final NIGHT_MODE_MAX_INDEX:I

.field public final afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

.field public final mAdaptiveBlueLightFilterSupported:Z

.field public mAlwaysOnDisplayEnabled:Z

.field public mBlueFilterCct:I

.field public mBlueFilterIndex:I

.field public mBlueLightFilterAdaptiveModeEnabled:Z

.field public mBlueLightFilterCustomAlwaysOn:Z

.field public mBlueLightFilterCustomAvailableTime:Z

.field public final mBlueLightFilterCustomStringArray:[Ljava/lang/String;

.field public final mBlueLightFilterCustomValueArray:[I

.field public mBlueLightFilterEnabled:Z

.field public mContentMode:I

.field public final mContext:Landroid/content/Context;

.field public mCurtainModeIsRunning:Z

.field public final mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

.field public final mDisplayListener:Lcom/samsung/android/hardware/display/SemMdnieManagerService$1;

.field public final mDisplayManager:Landroid/hardware/display/DisplayManager;

.field public mDisplayOn:Z

.field public mDisplaySolutionManager:Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;

.field public mDisplayState:I

.field public mDisplayStatePrev:I

.field public final mEnhancedComfortCustomStringArray:[Ljava/lang/String;

.field public final mEnhancedComfortCustomValueArray:[I

.field public mEnvironmentAdaptiveDisplayEnabled:Z

.field public final mEnvironmentAdaptiveDisplaySupported:Z

.field public final mMdnieWhiteRGBSupported:Z

.field public final mNaturalGammaScreenModeSupported:Z

.field public final mNaturalModeVersion:I

.field public mNightDimModeEnabled:Z

.field public final mNightDimSupported:Z

.field public final mNightDisplayOffsetDelta:I

.field public mNightMode:Z

.field public mNightModeBlock:Z

.field public mNightModeIndex:I

.field public final mPresetAdjustWhiteRGB:[[[I

.field public mScreenMode:I

.field public mScreenModeSetting:I

.field public final mSupportAPmDNIe:Z

.field public final mSupportBlueFilter:Z

.field public final mSupportContentMode:Z

.field public final mSupportContentModeGame:Z

.field public final mSupportContentModeVideoEnhance:Z

.field public final mSupportLightNotificationMode:Z

.field public final mSupportScreeenReadingMode:Z

.field public final mSupportScreenMode:Z

.field public final mUseAfterimageCompensationServiceConfig:Z

.field public mVividnessIndex:I

.field public mWhiteBalancePresetIndex:I

.field public mWorkBlueFilter:Z


# direct methods
.method public static -$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V
    .locals 22

    move-object/from16 v0, p0

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string/jumbo v2, "sec_display_temperature_red"

    const/4 v3, 0x0

    const/4 v4, -0x2

    invoke-static {v1, v2, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v6

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string/jumbo v2, "sec_display_temperature_green"

    invoke-static {v1, v2, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v7

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string/jumbo v2, "sec_display_temperature_blue"

    invoke-static {v1, v2, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v8

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string/jumbo v2, "sec_display_preset_index"

    const/4 v5, 0x2

    invoke-static {v1, v2, v5, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v1

    iget-object v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v9}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v9

    const-string/jumbo v10, "blue_light_filter"

    invoke-static {v9, v10, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v9

    const/4 v10, 0x1

    if-ne v9, v10, :cond_4b

    move v9, v10

    goto :goto_4c

    :cond_4b
    move v9, v3

    :goto_4c
    iput-boolean v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterEnabled:Z

    iget-object v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v9}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v9

    const-string/jumbo v11, "blue_light_filter_adaptive_mode"

    invoke-static {v9, v11, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v9

    if-ne v9, v10, :cond_5f

    move v9, v10

    goto :goto_60

    :cond_5f
    move v9, v3

    :goto_60
    iput-boolean v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterAdaptiveModeEnabled:Z

    iget-object v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v9}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v9

    const-string/jumbo v11, "blue_light_filter_type"

    invoke-static {v9, v11, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v9

    if-nez v9, :cond_73

    move v9, v10

    goto :goto_74

    :cond_73
    move v9, v3

    :goto_74
    iput-boolean v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAlwaysOn:Z

    iget-object v9, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v9}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v9

    invoke-static {v9, v2, v5, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v2

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWhiteBalancePresetIndex:I

    iget-object v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const-string/jumbo v9, "screen_mode_setting"

    const/4 v11, 0x4

    invoke-static {v2, v9, v11, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v2

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenModeSetting:I

    iget-object v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const-string/jumbo v9, "ead_enabled"

    invoke-static {v2, v9, v3, v4}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v2

    if-ne v2, v10, :cond_a3

    move v2, v10

    goto :goto_a4

    :cond_a3
    move v2, v3

    :goto_a4
    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplayEnabled:Z

    iget-object v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const-string/jumbo v4, "vividness_intensity"

    invoke-static {v2, v4, v3, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v2

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    new-instance v2, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "setting_is_changed - Screen Mode : "

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenModeSetting:I

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " , mMdnieWhiteRGBSupported : "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mMdnieWhiteRGBSupported:Z

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " , mEnvironmentAdaptiveDisplayEnabled : "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplayEnabled:Z

    const-string/jumbo v9, "SemMdnieManagerService"

    invoke-static {v9, v2, v4}, Lcom/android/server/HeimdAllFsService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/StringBuilder;Z)V

    iget v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    iget-boolean v12, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplayEnabled:Z

    if-nez v12, :cond_256

    iget-boolean v12, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mMdnieWhiteRGBSupported:Z

    const-string v13, "/sys/class/mdnie/mdnie1/whiteRGB"

    const-string v14, "/sys/class/mdnie/mdnie/whiteRGB"

    if-eqz v12, :cond_201

    iget v15, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenModeSetting:I

    if-ne v15, v11, :cond_201

    const-string/jumbo v2, "setting_is_changed - white balance("

    const-string v11, "), R("

    const-string v12, "), G("

    invoke-static {v1, v6, v2, v11, v12}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v11, "), B("

    const-string v12, ")"

    invoke-static {v7, v8, v11, v12, v2}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v9, v2}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-ltz v1, :cond_11a

    const/4 v2, 0x5

    if-ge v1, v2, :cond_11a

    iget-object v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mPresetAdjustWhiteRGB:[[[I

    aget-object v2, v2, v3

    aget-object v1, v2, v1

    aget v2, v1, v3

    add-int v3, v6, v2

    aget v2, v1, v10

    add-int/2addr v2, v7

    aget v1, v1, v5

    add-int/2addr v1, v8

    move v11, v1

    move v10, v2

    move v5, v3

    goto :goto_11f

    :cond_11a
    move v1, v3

    move v2, v1

    move v5, v2

    move v10, v5

    move v11, v10

    :goto_11f
    if-gtz v3, :cond_256

    const/16 v15, -0xfa

    if-lt v3, v15, :cond_256

    if-gtz v2, :cond_256

    if-lt v2, v15, :cond_256

    if-gtz v1, :cond_256

    if-lt v1, v15, :cond_256

    if-gtz v5, :cond_256

    if-lt v5, v15, :cond_256

    if-gtz v10, :cond_256

    if-lt v10, v15, :cond_256

    if-gtz v11, :cond_256

    if-lt v11, v15, :cond_256

    iget-boolean v15, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v4, ") , Sub RGB offset ("

    move/from16 v17, v15

    const-string v15, ","

    if-eqz v17, :cond_191

    iget v13, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const-string v14, "AP setWhiteBalanceMode : Main RGB offset ("

    move/from16 v20, v10

    const/4 v10, 0x3

    if-ne v13, v10, :cond_171

    invoke-virtual {v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getBlueLightFilterState()Z

    move-result v1

    if-nez v1, :cond_169

    invoke-static {v6, v7, v14, v15, v15}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {v8, v6, v4, v15, v1}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    invoke-static {v7, v8, v15, v12, v1}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v9, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    move v9, v6

    move v10, v7

    move v11, v8

    invoke-virtual/range {v5 .. v11}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setWhiteBalanceMode(IIIIII)Z

    return-void

    :cond_169
    iget-boolean v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    return-void

    :cond_171
    invoke-static {v3, v2, v14, v15, v15}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-static {v1, v5, v4, v15, v6}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    move/from16 v4, v20

    invoke-static {v4, v11, v15, v12, v6}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v9, v6}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v15, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    move/from16 v18, v1

    move/from16 v17, v2

    move/from16 v16, v3

    move/from16 v19, v5

    move/from16 v21, v11

    invoke-virtual/range {v15 .. v21}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setWhiteBalanceMode(IIIIII)Z

    return-void

    :cond_191
    move v0, v5

    move v5, v10

    move v6, v11

    invoke-static {v14}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v7

    const-string v8, " "

    if-eqz v7, :cond_1c3

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v14, v7}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_1c3
    invoke-static {v13}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1f0

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {v0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v13, v7}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_1f0
    const-string v7, "DDI setWhiteBalanceMode : Main RGB offset ("

    invoke-static {v3, v2, v7, v15, v15}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v1, v0, v4, v15, v2}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    invoke-static {v5, v6, v15, v12, v2}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v9, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_201
    if-eqz v12, :cond_256

    iget v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenModeSetting:I

    if-eq v1, v11, :cond_256

    iget-boolean v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    if-eqz v1, :cond_23d

    const-string v1, "AP setWhiteBalanceMode : Main RGB offset (0,0,0) , Sub RGB offset (0,0,0)"

    const/4 v10, 0x3

    if-ne v2, v10, :cond_22e

    invoke-virtual {v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getBlueLightFilterState()Z

    move-result v2

    if-nez v2, :cond_226

    invoke-static {v9, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v10, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    const/4 v15, 0x0

    const/16 v16, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    invoke-virtual/range {v10 .. v16}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setWhiteBalanceMode(IIIIII)Z

    return-void

    :cond_226
    iget-boolean v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    return-void

    :cond_22e
    invoke-static {v9, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v3 .. v9}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setWhiteBalanceMode(IIIIII)Z

    return-void

    :cond_23d
    invoke-static {v14}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    const-string v1, "0 0 0"

    if-eqz v0, :cond_248

    invoke-static {v14, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_248
    invoke-static {v13}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_251

    invoke-static {v13, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_251
    const-string v0, "DDI setWhiteBalanceMode : Main RGB offset (0,0,0) , Sub RGB offset (0,0,0)"

    invoke-static {v9, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_256
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 16

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-direct {v0}, Lcom/samsung/android/hardware/display/ISemMdnieManager$Stub;-><init>()V

    const-string/jumbo v2, "eng"

    sget-object v3, Landroid/os/Build;->TYPE:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    const/4 v2, 0x4

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenMode:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenModeSetting:I

    const/4 v2, 0x0

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContentMode:I

    const/4 v3, 0x0

    iput-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    const-string v4, "65303"

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    iput v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->MDNIE_SUPPORT_FUNCTION:I

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v5

    const-string/jumbo v6, "SEC_FLOATING_FEATURE_BIOAUTH_CONFIG_FINGERPRINT_FEATURES"

    invoke-virtual {v5, v6}, Lcom/samsung/android/feature/SemFloatingFeature;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->FP_FEATURE_SENSOR_IS_OPTICAL:Ljava/lang/String;

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeGame:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeVideoEnhance:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportBlueFilter:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportLightNotificationMode:Z

    const/4 v5, 0x1

    iput-boolean v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    iput-boolean v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeBlock:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mCurtainModeIsRunning:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAdaptiveBlueLightFilterSupported:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalGammaScreenModeSupported:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimSupported:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterEnabled:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterAdaptiveModeEnabled:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAlwaysOn:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimModeEnabled:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAlwaysOnDisplayEnabled:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayOn:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mMdnieWhiteRGBSupported:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplayEnabled:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mUseAfterimageCompensationServiceConfig:Z

    iput-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAvailableTime:Z

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterIndex:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterCct:I

    const/4 v6, -0x1

    iput v6, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayStatePrev:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayState:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    iput v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const/4 v7, 0x2

    iput v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWhiteBalancePresetIndex:I

    const/16 v7, 0x1f4

    iput v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDisplayOffsetDelta:I

    const/4 v7, -0x6

    const/16 v8, -0x14

    filled-new-array {v2, v7, v8}, [I

    move-result-object v9

    const/4 v10, -0x3

    const/16 v11, -0xa

    filled-new-array {v2, v10, v11}, [I

    move-result-object v12

    filled-new-array {v2, v2, v2}, [I

    move-result-object v13

    const/4 v14, -0x7

    const/4 v15, -0x5

    filled-new-array {v14, v15, v2}, [I

    move-result-object v15

    const/16 v3, -0xe

    filled-new-array {v3, v11, v2}, [I

    move-result-object v5

    filled-new-array {v9, v12, v13, v15, v5}, [[I

    move-result-object v5

    filled-new-array {v2, v10, v8}, [I

    move-result-object v9

    filled-new-array {v2, v2, v11}, [I

    move-result-object v11

    filled-new-array {v10, v2, v10}, [I

    move-result-object v12

    const/4 v13, -0x2

    filled-new-array {v14, v13, v2}, [I

    move-result-object v15

    filled-new-array {v3, v14, v2}, [I

    move-result-object v13

    filled-new-array {v9, v11, v12, v15, v13}, [[I

    move-result-object v9

    filled-new-array {v2, v2, v8}, [I

    move-result-object v8

    const/16 v11, -0xd

    filled-new-array {v10, v2, v11}, [I

    move-result-object v11

    filled-new-array {v7, v2, v7}, [I

    move-result-object v12

    const/4 v13, -0x8

    filled-new-array {v13, v2, v6}, [I

    move-result-object v13

    const/4 v15, -0x4

    filled-new-array {v3, v15, v2}, [I

    move-result-object v14

    filled-new-array {v8, v11, v12, v13, v14}, [[I

    move-result-object v8

    const/16 v11, -0x17

    filled-new-array {v10, v2, v11}, [I

    move-result-object v10

    const/16 v11, -0x10

    filled-new-array {v7, v2, v11}, [I

    move-result-object v12

    const/16 v13, -0x9

    filled-new-array {v13, v2, v13}, [I

    move-result-object v14

    const/16 v11, -0xb

    filled-new-array {v11, v2, v15}, [I

    move-result-object v11

    filled-new-array {v3, v6, v2}, [I

    move-result-object v15

    filled-new-array {v10, v12, v14, v11, v15}, [[I

    move-result-object v10

    const/16 v11, -0x1a

    filled-new-array {v7, v2, v11}, [I

    move-result-object v7

    const/16 v11, -0x13

    filled-new-array {v13, v2, v11}, [I

    move-result-object v11

    const/16 v12, -0xc

    filled-new-array {v12, v2, v12}, [I

    move-result-object v12

    const/4 v13, -0x7

    filled-new-array {v3, v2, v13}, [I

    move-result-object v3

    const/4 v13, -0x2

    const/16 v14, -0x10

    filled-new-array {v14, v2, v13}, [I

    move-result-object v14

    filled-new-array {v7, v11, v12, v3, v14}, [[I

    move-result-object v3

    filled-new-array {v5, v9, v8, v10, v3}, [[[I

    move-result-object v3

    iput-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mPresetAdjustWhiteRGB:[[[I

    new-instance v3, Lcom/samsung/android/hardware/display/SemMdnieManagerService$1;

    invoke-direct {v3, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService$1;-><init>(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    iput-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayListener:Lcom/samsung/android/hardware/display/SemMdnieManagerService$1;

    iput-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    new-instance v5, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;

    invoke-direct {v5, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;-><init>(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    and-int/lit8 v7, v4, 0x1

    if-eqz v7, :cond_137

    const/4 v7, 0x1

    goto :goto_138

    :cond_137
    move v7, v2

    :goto_138
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    and-int/lit8 v7, v4, 0x2

    if-eqz v7, :cond_140

    const/4 v7, 0x1

    goto :goto_141

    :cond_140
    move v7, v2

    :goto_141
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeGame:Z

    and-int/lit8 v7, v4, 0x4

    if-eqz v7, :cond_149

    const/4 v7, 0x1

    goto :goto_14a

    :cond_149
    move v7, v2

    :goto_14a
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeVideoEnhance:Z

    and-int/lit8 v7, v4, 0x10

    if-eqz v7, :cond_152

    const/4 v7, 0x1

    goto :goto_153

    :cond_152
    move v7, v2

    :goto_153
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    and-int/lit8 v7, v4, 0x20

    if-eqz v7, :cond_15b

    const/4 v7, 0x1

    goto :goto_15c

    :cond_15b
    move v7, v2

    :goto_15c
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    and-int/lit16 v7, v4, 0x1000

    if-eqz v7, :cond_164

    const/4 v7, 0x1

    goto :goto_165

    :cond_164
    move v7, v2

    :goto_165
    iput-boolean v7, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportBlueFilter:Z

    const v7, 0x8000

    and-int/2addr v4, v7

    if-eqz v4, :cond_16f

    const/4 v4, 0x1

    goto :goto_170

    :cond_16f
    move v4, v2

    :goto_170
    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportLightNotificationMode:Z

    const/4 v4, 0x1

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mMdnieWhiteRGBSupported:Z

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v7, 0x1110013

    invoke-virtual {v4, v7}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v4

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mUseAfterimageCompensationServiceConfig:Z

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v7, 0x1070048

    invoke-virtual {v4, v7}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v4

    iput-object v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomStringArray:[Ljava/lang/String;

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v7, 0x1070067

    invoke-virtual {v4, v7}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v4

    iput-object v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomStringArray:[Ljava/lang/String;

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v4

    const-string/jumbo v7, "SEC_FLOATING_FEATURE_LCD_CONFIG_HW_MDNIE"

    invoke-virtual {v4, v7}, Lcom/samsung/android/feature/SemFloatingFeature;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v7, "DDI"

    invoke-virtual {v7, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_1b4

    const/4 v4, 0x1

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    :cond_1b4
    const-string/jumbo v4, "screen_mode_setting"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    const/4 v13, -0x2

    invoke-virtual {v3, v4, v2, v5, v13}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "sec_display_temperature_red"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v13}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "sec_display_temperature_green"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v13}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "sec_display_temperature_blue"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v13}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "sec_display_preset_index"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v2}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "vividness_intensity"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v6}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "blue_light_filter"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v6}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "blue_light_filter_night_dim"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v6}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "aod_show_state"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v6}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    const-string/jumbo v4, "ead_enabled"

    invoke-static {v4}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2, v5, v6}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;I)V

    new-instance v3, Landroid/content/IntentFilter;

    invoke-direct {v3}, Landroid/content/IntentFilter;-><init>()V

    const-string/jumbo v4, "android.intent.action.BOOT_COMPLETED"

    invoke-virtual {v3, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string/jumbo v4, "android.intent.action.SCREEN_ON"

    invoke-virtual {v3, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string/jumbo v4, "android.intent.action.SCREEN_OFF"

    invoke-virtual {v3, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string/jumbo v4, "android.intent.action.USER_PRESENT"

    invoke-virtual {v3, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    invoke-static {}, Landroid/os/FactoryTest;->isFactoryBinary()Z

    move-result v4

    if-nez v4, :cond_244

    new-instance v4, Lcom/samsung/android/hardware/display/SemMdnieManagerService$ScreenWatchingReceiver;

    invoke-direct {v4, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService$ScreenWatchingReceiver;-><init>(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    invoke-virtual {v1, v4, v3}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :cond_244
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v3

    const-string/jumbo v4, "SEC_FLOATING_FEATURE_LCD_SUPPORT_BLUE_FILTER_ADAPTIVE_MODE"

    invoke-virtual {v3, v4, v2}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v3

    const/4 v4, 0x1

    if-lez v3, :cond_254

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAdaptiveBlueLightFilterSupported:Z

    :cond_254
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v3

    const-string/jumbo v5, "SEC_FLOATING_FEATURE_LCD_CONFIG_NIGHT_DIM"

    invoke-virtual {v3, v5, v2}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-lez v3, :cond_263

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimSupported:Z

    :cond_263
    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v3

    const-string/jumbo v5, "SEC_FLOATING_FEATURE_LCD_CONFIG_NATURAL_MODE_TYPE"

    invoke-virtual {v3, v5, v2}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-lez v3, :cond_27c

    iput-boolean v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalGammaScreenModeSupported:Z

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object v3

    invoke-virtual {v3, v5, v2}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result v3

    iput v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    :cond_27c
    iget-boolean v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAdaptiveBlueLightFilterSupported:Z

    const/16 v4, 0xb

    if-eqz v3, :cond_28b

    iget-boolean v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimSupported:Z

    if-eqz v5, :cond_28b

    const/16 v3, 0x132

    iput v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    goto :goto_298

    :cond_28b
    if-eqz v3, :cond_296

    iget-boolean v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimSupported:Z

    if-nez v3, :cond_296

    const/16 v3, 0x66

    iput v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    goto :goto_298

    :cond_296
    iput v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    :goto_298
    new-array v3, v4, [I

    iput-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomValueArray:[I

    move v3, v2

    :goto_29d
    iget-object v5, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomStringArray:[Ljava/lang/String;

    array-length v6, v5

    if-ge v3, v6, :cond_2af

    iget-object v6, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomValueArray:[I

    aget-object v5, v5, v3

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    aput v5, v6, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_29d

    :cond_2af
    new-array v3, v4, [I

    iput-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomValueArray:[I

    :goto_2b3
    iget-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomStringArray:[Ljava/lang/String;

    array-length v4, v3

    if-ge v2, v4, :cond_2c5

    iget-object v4, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomValueArray:[I

    aget-object v3, v3, v2

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    aput v3, v4, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_2b3

    :cond_2c5
    iget-boolean v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mUseAfterimageCompensationServiceConfig:Z

    if-eqz v2, :cond_2d6

    invoke-static {}, Landroid/os/FactoryTest;->isFactoryBinary()Z

    move-result v2

    if-nez v2, :cond_2d6

    new-instance v2, Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    invoke-direct {v2, v1}, Lcom/samsung/android/hardware/display/AfterimageCompensationService;-><init>(Landroid/content/Context;)V

    iput-object v2, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    :cond_2d6
    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    const-string/jumbo v2, "SemMdnieManagerService"

    if-nez v1, :cond_2fc

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v3, "display_aiqe"

    invoke-virtual {v1, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    iput-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "mDisplayAiqeManager : "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2fc
    invoke-static {}, Landroid/os/FactoryTest;->isFactoryBinary()Z

    move-result v1

    if-eqz v1, :cond_32e

    iget-boolean v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    if-eqz v1, :cond_312

    const-string v1, "AP setByPassMode : true"

    invoke-static {v2, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    const/4 v4, 0x1

    invoke-virtual {v1, v4}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setByPassMode(Z)Z

    goto :goto_32e

    :cond_312
    const/4 v4, 0x1

    const-string v1, "/sys/class/mdnie/mdnie/bypass"

    invoke-static {v1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_31e

    invoke-static {v4, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_31e
    const-string v1, "/sys/class/mdnie/mdnie1/bypass"

    invoke-static {v1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_329

    invoke-static {v4, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_329
    const-string v1, "DDI setByPassMode : true"

    invoke-static {v2, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_32e
    :goto_32e
    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayManager:Landroid/hardware/display/DisplayManager;

    if-nez v1, :cond_357

    iget-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v3, "display"

    invoke-virtual {v1, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/hardware/display/DisplayManager;

    iput-object v1, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayManager:Landroid/hardware/display/DisplayManager;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string/jumbo v4, "mDisplayManager : "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayListener:Lcom/samsung/android/hardware/display/SemMdnieManagerService$1;

    const/4 v4, 0x0

    invoke-virtual {v1, v3, v4}, Landroid/hardware/display/DisplayManager;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;)V

    :cond_357
    new-instance v1, Ljava/lang/StringBuilder;

    const-string/jumbo v3, "mMdnieWhiteRGBSupported : "

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mMdnieWhiteRGBSupported:Z

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string/jumbo v3, "Night mode Index : "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", S_EAD : "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", SemMdnieMdnieManager AFC config : "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mUseAfterimageCompensationServiceConfig:Z

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " , mNaturalModeVersion : "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    invoke-static {v1, v0, v2}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    return-void
.end method

.method public static sysfsWrite(ILjava/lang/String;)Z
    .locals 2

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result p1

    if-eqz p1, :cond_3d

    const/4 p1, 0x0

    :try_start_c
    new-instance v1, Ljava/io/FileOutputStream;

    invoke-direct {v1, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_11
    .catch Ljava/io/FileNotFoundException; {:try_start_c .. :try_end_11} :catch_2d
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_11} :catch_2b

    :try_start_11
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    const-string/jumbo p1, "UTF-8"

    invoke-static {p1}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_26
    .catch Ljava/io/IOException; {:try_start_11 .. :try_end_26} :catch_28

    const/4 p0, 0x1

    return p0

    :catch_28
    move-exception p0

    move-object p1, v1

    goto :goto_32

    :catch_2b
    move-exception p0

    goto :goto_32

    :catch_2d
    move-exception p0

    :try_start_2e
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V
    :try_end_31
    .catch Ljava/io/IOException; {:try_start_2e .. :try_end_31} :catch_2b

    goto :goto_3d

    :goto_32
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :try_start_35
    invoke-virtual {p1}, Ljava/io/FileOutputStream;->close()V
    :try_end_38
    .catch Ljava/lang/Exception; {:try_start_35 .. :try_end_38} :catch_39

    goto :goto_3d

    :catch_39
    move-exception p0

    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_3d
    :goto_3d
    const/4 p0, 0x0

    return p0
.end method

.method public static sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Ljava/io/FileOutputStream;

    new-instance v2, Ljava/io/File;

    invoke-direct {v2, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_b
    .catch Ljava/io/FileNotFoundException; {:try_start_1 .. :try_end_b} :catch_23
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_b} :catch_21

    :try_start_b
    const-string/jumbo p0, "UTF-8"

    invoke-static {p0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_1c
    .catch Ljava/io/IOException; {:try_start_b .. :try_end_1c} :catch_1e

    const/4 p0, 0x1

    return p0

    :catch_1e
    move-exception p0

    move-object v0, v1

    goto :goto_28

    :catch_21
    move-exception p0

    goto :goto_28

    :catch_23
    move-exception p0

    :try_start_24
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V
    :try_end_27
    .catch Ljava/io/IOException; {:try_start_24 .. :try_end_27} :catch_21

    goto :goto_33

    :goto_28
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :try_start_2b
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_2e
    .catch Ljava/lang/Exception; {:try_start_2b .. :try_end_2e} :catch_2f

    goto :goto_33

    :catch_2f
    move-exception p0

    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_33
    const/4 p0, 0x0

    return p0
.end method

.method public static sysfsWrite_AdaptiveArray(Ljava/lang/String;[I)V
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    aget v1, p1, v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v2, 0x1

    aget v2, p1, v2

    invoke-static {v2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x2

    aget p1, p1, v1

    invoke-static {v0, p1}, Lcom/android/server/am/ProcessList$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object p1

    const/4 v0, 0x0

    :try_start_29
    new-instance v1, Ljava/io/FileOutputStream;

    new-instance v2, Ljava/io/File;

    invoke-direct {v2, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_33
    .catch Ljava/io/FileNotFoundException; {:try_start_29 .. :try_end_33} :catch_4a
    .catch Ljava/io/IOException; {:try_start_29 .. :try_end_33} :catch_48

    :try_start_33
    const-string/jumbo p0, "UTF-8"

    invoke-static {p0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_44
    .catch Ljava/io/IOException; {:try_start_33 .. :try_end_44} :catch_45

    return-void

    :catch_45
    move-exception p0

    move-object v0, v1

    goto :goto_4f

    :catch_48
    move-exception p0

    goto :goto_4f

    :catch_4a
    move-exception p0

    :try_start_4b
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V
    :try_end_4e
    .catch Ljava/io/IOException; {:try_start_4b .. :try_end_4e} :catch_48

    goto :goto_5a

    :goto_4f
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :try_start_52
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_55
    .catch Ljava/lang/Exception; {:try_start_52 .. :try_end_55} :catch_56

    goto :goto_5a

    :catch_56
    move-exception p0

    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_5a
    return-void
.end method

.method public static sysfsWrite_CB(ILjava/lang/String;[I)Z
    .locals 4

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    aget v2, p2, v1

    invoke-static {v2, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v2, 0x1

    aget v3, p2, v2

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x2

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x3

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x4

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x5

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x6

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/4 v3, 0x7

    aget v3, p2, v3

    invoke-static {v3, v0, p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(ILjava/lang/StringBuilder;Ljava/lang/String;)V

    const/16 p0, 0x8

    aget p0, p2, p0

    invoke-static {v0, p0}, Landroid/hardware/audio/common/V2_0/AudioChannelMask$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object p0

    const/4 p2, 0x0

    :try_start_4a
    new-instance v0, Ljava/io/FileOutputStream;

    new-instance v3, Ljava/io/File;

    invoke-direct {v3, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_54
    .catch Ljava/io/FileNotFoundException; {:try_start_4a .. :try_end_54} :catch_6b
    .catch Ljava/io/IOException; {:try_start_4a .. :try_end_54} :catch_69

    :try_start_54
    const-string/jumbo p1, "UTF-8"

    invoke-static {p1}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_65
    .catch Ljava/io/IOException; {:try_start_54 .. :try_end_65} :catch_66

    return v2

    :catch_66
    move-exception p0

    move-object p2, v0

    goto :goto_70

    :catch_69
    move-exception p0

    goto :goto_70

    :catch_6b
    move-exception p0

    :try_start_6c
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V
    :try_end_6f
    .catch Ljava/io/IOException; {:try_start_6c .. :try_end_6f} :catch_69

    goto :goto_7b

    :goto_70
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :try_start_73
    invoke-virtual {p2}, Ljava/io/FileOutputStream;->close()V
    :try_end_76
    .catch Ljava/lang/Exception; {:try_start_73 .. :try_end_76} :catch_77

    goto :goto_7b

    :catch_77
    move-exception p0

    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_7b
    return v1
.end method


# virtual methods
.method public final afpcDataApply()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "afpcDataApply"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v0, "SemMdnieManagerService"

    invoke-static {v0, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    if-eqz p0, :cond_1a

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->afpcDataApply()Z

    move-result p0

    return p0

    :cond_1a
    const/4 p0, 0x0

    return p0
.end method

.method public final afpcDataOff()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "afpcDataOff"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v0, "SemMdnieManagerService"

    invoke-static {v0, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    if-eqz p0, :cond_1a

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->afpcDataOff()Z

    move-result p0

    return p0

    :cond_1a
    const/4 p0, 0x0

    return p0
.end method

.method public final afpcDataVerify()Z
    .locals 2

    const-string/jumbo v0, "SemMdnieManagerService"

    const-string/jumbo v1, "afpcDataVerify"

    invoke-static {v0, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    if-eqz p0, :cond_12

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->afpcDataVerify()Z

    move-result p0

    return p0

    :cond_12
    const/4 p0, 0x0

    return p0
.end method

.method public final afpcDataWrite()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "afpcDataWrite"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v0, "SemMdnieManagerService"

    invoke-static {v0, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    if-eqz p0, :cond_1a

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->afpcDataWrite()Z

    move-result p0

    return p0

    :cond_1a
    const/4 p0, 0x0

    return p0
.end method

.method public final afpcWorkOff()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "afpcWorkOff"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo v0, "SemMdnieManagerService"

    invoke-static {v0, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    const/4 v0, 0x0

    if-eqz p0, :cond_25

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const-string v1, "AfterimageCompensationService"

    const-string/jumbo v2, "afpcWorkOff()"

    invoke-static {v1, v2}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iput-boolean v0, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->AfcStateCondition:Z

    const/4 p0, 0x1

    return p0

    :cond_25
    return v0
.end method

.method public final checkScreenMode(I)Z
    .locals 5

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    const/4 v1, 0x5

    const/4 v2, 0x4

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v0, :cond_1c

    if-eqz p1, :cond_1b

    if-eq p1, v3, :cond_1b

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1b

    const/4 v0, 0x3

    if-eq p1, v0, :cond_1b

    if-eq p1, v2, :cond_1b

    if-eq p1, v1, :cond_17

    goto :goto_1c

    :cond_17
    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz v0, :cond_1c

    :cond_1b
    move v4, v3

    :cond_1c
    :goto_1c
    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz p0, :cond_26

    if-ne p1, v1, :cond_23

    move v4, v3

    :cond_23
    if-ne p1, v2, :cond_26

    return v3

    :cond_26
    return v4
.end method

.method public final disableNightMode()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "disableNightMode"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    iget v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, v0, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    move-result p0

    return p0
.end method

.method public final enableNightMode(I)Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "enableNightMode"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x1

    invoke-virtual {p0, v0, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    move-result p0

    return p0
.end method

.method public final getBlueLightFilterState()Z
    .locals 2

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplaySolutionManager:Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;

    if-nez v0, :cond_10

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string v1, "DisplaySolution"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;

    iput-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplaySolutionManager:Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;

    :cond_10
    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplaySolutionManager:Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;

    if-eqz v0, :cond_1a

    invoke-virtual {v0}, Lcom/samsung/android/displaysolution/SemDisplaySolutionManager;->isBlueLightFilterScheduledTime()Z

    move-result v0

    iput-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAvailableTime:Z

    :cond_1a
    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterEnabled:Z

    if-eqz v0, :cond_26

    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAlwaysOn:Z

    if-nez v1, :cond_2c

    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterAdaptiveModeEnabled:Z

    if-nez v1, :cond_2c

    :cond_26
    if-eqz v0, :cond_2e

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomAvailableTime:Z

    if-eqz p0, :cond_2e

    :cond_2c
    const/4 p0, 0x1

    return p0

    :cond_2e
    const/4 p0, 0x0

    return p0
.end method

.method public final getContentMode()I
    .locals 0

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContentMode:I

    return p0
.end method

.method public final getNightModeBlock()Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "getNightModeBlock"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "getNightModeBlock : "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v2, v0, v1}, Lcom/android/server/HeimdAllFsService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/StringBuilder;Z)V

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    return p0
.end method

.method public final getNightModeCct()I
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "getNightModeCct : "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterCct:I

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v0, v1, v2}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterCct:I

    return p0
.end method

.method public final getNightModeStep()I
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "getNightModeStep : "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterIndex:I

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v0, v1, v2}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterIndex:I

    return p0
.end method

.method public final getScreenMode()I
    .locals 0

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenMode:I

    return p0
.end method

.method public final getSupportedContentMode()[I
    .locals 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "MDNIE_SUPPORT_FUNCTION ("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->MDNIE_SUPPORT_FUNCTION:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "), mSupportContentMode ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "SemMdnieManagerService"

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    const/4 v0, 0x6

    const/4 v1, 0x0

    if-eqz p0, :cond_2e

    move v2, v0

    goto :goto_2f

    :cond_2e
    move v2, v1

    :goto_2f
    new-array v2, v2, [I

    if-eqz p0, :cond_48

    aput v1, v2, v1

    const/4 p0, 0x1

    aput p0, v2, p0

    const/4 p0, 0x2

    const/4 v1, 0x4

    aput v1, v2, p0

    const/4 p0, 0x3

    aput v0, v2, p0

    const/16 p0, 0x8

    aput p0, v2, v1

    const/4 p0, 0x5

    const/16 v0, 0x9

    aput v0, v2, p0

    :cond_48
    return-object v2
.end method

.method public final getSupportedScreenMode()[I
    .locals 7

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    const/4 v1, 0x2

    const/4 v2, 0x5

    const/4 v3, 0x0

    const/4 v4, 0x4

    if-eqz v0, :cond_10

    iget-boolean v5, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz v5, :cond_e

    move v5, v2

    goto :goto_17

    :cond_e
    move v5, v4

    goto :goto_17

    :cond_10
    iget-boolean v5, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz v5, :cond_16

    move v5, v1

    goto :goto_17

    :cond_16
    move v5, v3

    :goto_17
    new-array v5, v5, [I

    const/4 v6, 0x1

    if-eqz v0, :cond_2c

    aput v3, v5, v3

    aput v6, v5, v6

    aput v1, v5, v1

    const/4 v0, 0x3

    aput v4, v5, v0

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz p0, :cond_34

    aput v2, v5, v4

    return-object v5

    :cond_2c
    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz p0, :cond_34

    aput v4, v5, v3

    aput v2, v5, v6

    :cond_34
    return-object v5
.end method

.method public final isContentModeSupported()Z
    .locals 0

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    if-eqz p0, :cond_6

    const/4 p0, 0x1

    return p0

    :cond_6
    const/4 p0, 0x0

    return p0
.end method

.method public final isNightModeSupported()Z
    .locals 0

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportBlueFilter:Z

    if-eqz p0, :cond_6

    const/4 p0, 0x1

    return p0

    :cond_6
    const/4 p0, 0x0

    return p0
.end method

.method public final isScreenModeSupported()Z
    .locals 1

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    if-nez v0, :cond_b

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz p0, :cond_9

    goto :goto_b

    :cond_9
    const/4 p0, 0x0

    return p0

    :cond_b
    :goto_b
    const/4 p0, 0x1

    return p0
.end method

.method public final setColorFadeNightDim(Z)Z
    .locals 5

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v1, "blue_light_filter"

    const/4 v2, 0x0

    const/4 v3, -0x2

    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v1

    const/4 v4, 0x1

    if-ne v1, v4, :cond_14

    move v1, v4

    goto :goto_15

    :cond_14
    move v1, v2

    :goto_15
    iput-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterEnabled:Z

    const-string/jumbo v1, "blue_light_filter_night_dim"

    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    if-ne v0, v4, :cond_21

    goto :goto_22

    :cond_21
    move v4, v2

    :goto_22
    iput-boolean v4, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimModeEnabled:Z

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterEnabled:Z

    if-eqz v0, :cond_4c

    if-eqz v4, :cond_4c

    const-string/jumbo v0, "SemMdnieManagerService"

    const-string/jumbo v1, "setColorFadeNightDim"

    invoke-static {v0, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p1, :cond_3e

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, v0, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightDimOffMode(IZ)Z

    move-result p0

    return p0

    :cond_3e
    iget p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayState:I

    const/4 v0, 0x2

    if-ne p1, v0, :cond_4c

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p1, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    move-result p0

    return p0

    :cond_4c
    return v2
.end method

.method public final setColorVision(ZII)Z
    .locals 2

    if-ltz p2, :cond_4f

    const/16 p0, 0xc

    if-gt p2, p0, :cond_4f

    if-ltz p3, :cond_4f

    const/16 p0, 0x9

    if-gt p3, p0, :cond_4f

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0, p3}, Lcom/android/server/am/ProcessList$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object p0

    const-string v0, "/sys/class/mdnie/mdnie/color_lens"

    invoke-static {v0, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3e

    const-string v0, "/sys/class/mdnie/mdnie1/color_lens"

    invoke-static {v0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3e

    invoke-static {v0, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_3e
    const-string/jumbo p0, "setColorVision : "

    const-string v0, " - "

    invoke-static {p2, p0, v0, v0, p1}, Lcom/android/server/accessibility/AccessibilityManagerService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string/jumbo p1, "SemMdnieManagerService"

    invoke-static {p0, p3, p1}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    const/4 p0, 0x1

    return p0

    :cond_4f
    const/4 p0, 0x0

    return p0
.end method

.method public final setContentMode(I)Z
    .locals 4

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentMode:Z

    if-eqz v0, :cond_57

    if-eqz v0, :cond_57

    const/4 v0, 0x1

    if-eqz p1, :cond_2a

    if-eq p1, v0, :cond_2a

    const/4 v1, 0x4

    if-eq p1, v1, :cond_2a

    const/4 v1, 0x6

    if-eq p1, v1, :cond_2a

    const/16 v1, 0x14

    if-eq p1, v1, :cond_2a

    const/16 v1, 0x8

    if-eq p1, v1, :cond_2a

    const/16 v1, 0x9

    if-eq p1, v1, :cond_2a

    packed-switch p1, :pswitch_data_5a

    goto :goto_57

    :pswitch_21
    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeVideoEnhance:Z

    if-eqz v1, :cond_57

    goto :goto_2a

    :pswitch_26
    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportContentModeGame:Z

    if-eqz v1, :cond_57

    :cond_2a
    :goto_2a
    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string/jumbo v2, "SemMdnieManagerService"

    if-eqz v1, :cond_3c

    const-string v1, "AP setContentMode : "

    invoke-static {p1, v1, v2}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    iget-object v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v1, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setContentMode(I)Z

    goto :goto_54

    :cond_3c
    const-string v1, "/sys/class/mdnie/mdnie/scenario"

    invoke-static {p1, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_54

    const-string v1, "/sys/class/mdnie/mdnie1/scenario"

    invoke-static {v1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_4f

    invoke-static {p1, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_4f
    const-string v1, "DDI setContentMode : "

    invoke-static {p1, v1, v2}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    :cond_54
    :goto_54
    iput p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContentMode:I

    return v0

    :cond_57
    :goto_57
    const/4 p0, 0x0

    return p0

    nop

    :pswitch_data_5a
    .packed-switch 0xb
        :pswitch_26
        :pswitch_26
        :pswitch_26
        :pswitch_21
        :pswitch_21
    .end packed-switch
.end method

.method public final setEadMode(II[I)V
    .locals 2

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    if-eqz p1, :cond_53

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v0, ")"

    const-string/jumbo v1, "SemMdnieManagerService"

    if-eqz p1, :cond_27

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {p0, p2}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setEnvironmentAdaptiveDisplayLevel(I)Z

    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "AP setEadMode : index("

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_27
    const-string p0, "/sys/class/mdnie/mdnie/whiteRGB"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_53

    invoke-static {p0, p3}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite_AdaptiveArray(Ljava/lang/String;[I)V

    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "DDI setEadMode : arr("

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 p1, 0x0

    aget p1, p3, p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ","

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p2, 0x1

    aget p2, p3, p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p1, 0x2

    aget p1, p3, p1

    invoke-static {p1, v0, v1, p0}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    :cond_53
    return-void
.end method

.method public final setEadModeSub(II[I)V
    .locals 2

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    if-eqz p1, :cond_3f

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string p1, ")"

    const-string/jumbo v0, "SemMdnieManagerService"

    if-eqz p0, :cond_13

    const-string p0, "AP setEadModeSub : index("

    invoke-static {p2, p0, p1, v0}, Lcom/android/server/BootReceiver$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_13
    const-string p0, "/sys/class/mdnie/mdnie1/whiteRGB"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_3f

    invoke-static {p0, p3}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite_AdaptiveArray(Ljava/lang/String;[I)V

    new-instance p0, Ljava/lang/StringBuilder;

    const-string p2, "DDI setEadModeSub : arr("

    invoke-direct {p0, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 p2, 0x0

    aget p2, p3, p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ","

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x1

    aget v1, p3, v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p2, 0x2

    aget p2, p3, p2

    invoke-static {p2, p1, v0, p0}, Lcom/android/server/CustomizedBinderCallsStatsInternal$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    :cond_3f
    return-void
.end method

.method public final setExtraDimMode(I)V
    .locals 2

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string/jumbo v1, "SemMdnieManagerService"

    if-eqz v0, :cond_12

    const-string v0, "AP setExtraDimMode : "

    invoke-static {p1, v0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {p0, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setExtraDimMode(I)Z

    return-void

    :cond_12
    const-string/jumbo p0, "sys/class/mdnie/mdnie/extra_dim"

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2c

    const-string/jumbo p0, "sys/class/mdnie/mdnie1/extra_dim"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_27

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_27
    const-string p0, "DDI setExtraDimMode : "

    invoke-static {p1, p0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    :cond_2c
    return-void
.end method

.method public final setHighBrightnessMode(III)V
    .locals 4

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v1, ", index : "

    const-string v2, ") lux : "

    const-string/jumbo v3, "SemMdnieManagerService"

    if-eqz v0, :cond_1a

    const-string v0, "AP setHighBrightnessMode id("

    invoke-static {p1, p2, v0, v2, v1}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-static {p1, p3, v3}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {p0, p3}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setHighBrightnessMode(I)Z

    return-void

    :cond_1a
    if-nez p1, :cond_22

    const-string p0, "/sys/class/lcd/panel/lux"

    invoke-static {p2, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    goto :goto_2a

    :cond_22
    const/4 p0, 0x1

    if-ne p1, p0, :cond_2a

    const-string p0, "/sys/class/lcd/panel1/lux"

    invoke-static {p2, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_2a
    :goto_2a
    const-string p0, "DDI setHighBrightnessMode id("

    invoke-static {p1, p2, p0, v2, v1}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-static {p0, p3, v3}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    return-void
.end method

.method public final setHighDynamicRangeMode(Z)Z
    .locals 4

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const/4 v1, 0x1

    const-string/jumbo v2, "SemMdnieManagerService"

    if-eqz v0, :cond_1f

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "AP setHighDynamicRangeMode : "

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {p0, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setHighDynamicRangeMode(Z)Z

    return v1

    :cond_1f
    const-string/jumbo p0, "sys/class/mdnie/mdnie/hdr"

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_45

    const-string/jumbo p0, "sys/class/mdnie/mdnie1/hdr"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_34

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_34
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "DDI setHighDynamicRangeMode : "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_45
    return v1
.end method

.method public final setLightNotificationMode(Z)Z
    .locals 1

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportLightNotificationMode:Z

    if-eqz p0, :cond_2b

    const-string p0, "/sys/class/mdnie/mdnie1/light_notification"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_f

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_f
    new-instance p0, Ljava/lang/StringBuilder;

    const-string/jumbo v0, "setLightNotificationMode : "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string/jumbo v0, "SemMdnieManagerService"

    invoke-static {v0, p0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string p0, "/sys/class/mdnie/mdnie/light_notification"

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    return p0

    :cond_2b
    const/4 p0, 0x0

    return p0
.end method

.method public final setNightDimOffMode(IZ)Z
    .locals 7

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v1, "blue_light_filter_night_dim"

    const/4 v2, 0x0

    const/4 v3, -0x2

    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_14

    move v0, v1

    goto :goto_15

    :cond_14
    move v0, v2

    :goto_15
    iput-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimModeEnabled:Z

    iget v3, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const/4 v4, 0x3

    if-ne v3, v4, :cond_1f

    const/4 v0, 0x0

    :goto_1d
    move v3, p1

    goto :goto_54

    :cond_1f
    const-string v3, " "

    if-eqz v0, :cond_39

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, p1, 0x66

    invoke-static {v0, v3}, Lcom/android/server/am/ProcessList$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_54

    :cond_39
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_1d

    :goto_54
    iget-boolean v5, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportBlueFilter:Z

    if-eqz v5, :cond_ca

    iget-boolean v5, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    if-eqz v5, :cond_ca

    if-ltz p1, :cond_ca

    iget v5, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    if-gt p1, v5, :cond_ca

    iget-boolean v2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v5, ", index : "

    const-string/jumbo v6, "SemMdnieManagerService"

    if-eqz v2, :cond_a5

    iget v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const-string v2, "AP setNightMode : "

    if-ne v0, v4, :cond_8a

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual {p0, p2, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    goto :goto_c5

    :cond_8a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v0, p2, v3}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setBlueLightFilterMode(ZI)Z

    goto :goto_c5

    :cond_a5
    const-string v2, "/sys/class/mdnie/mdnie/night_mode"

    invoke-static {v2, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_c5

    const-string v2, "/sys/class/mdnie/mdnie1/night_mode"

    invoke-static {v2}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_b8

    invoke-static {v2, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_b8
    const-string v2, "DDI setNightDimOffMode : "

    const-string v3, ", str : ("

    invoke-static {p1, v2, v5, v3, p2}, Lcom/android/server/accessibility/AccessibilityManagerService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-static {v2, v0, v3, v6}, Lcom/android/server/BootReceiver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_c5
    :goto_c5
    iput-boolean p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iput p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    return v1

    :cond_ca
    return v2
.end method

.method public final setNightMode(ZI)Z
    .locals 11

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v1, "blue_light_filter_night_dim"

    const/4 v2, 0x0

    const/4 v3, -0x2

    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v1

    const/4 v4, 0x1

    if-ne v1, v4, :cond_14

    move v1, v4

    goto :goto_15

    :cond_14
    move v1, v2

    :goto_15
    iput-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimModeEnabled:Z

    const-string/jumbo v1, "aod_show_state"

    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    if-ne v0, v4, :cond_22

    move v0, v4

    goto :goto_23

    :cond_22
    move v0, v2

    :goto_23
    iput-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAlwaysOnDisplayEnabled:Z

    iget-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightDimModeEnabled:Z

    const-string v3, " "

    if-eqz v1, :cond_5d

    if-nez v0, :cond_47

    iget v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayState:I

    if-eq v0, v4, :cond_47

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit16 v1, p2, 0xcc

    invoke-static {v0, v1}, Lcom/android/server/am/ProcessList$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_78

    :cond_47
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, p2, 0x66

    invoke-static {v0, v1}, Lcom/android/server/am/ProcessList$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_78

    :cond_5d
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    move v1, p2

    :goto_78
    iget v3, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const/4 v5, 0x3

    if-ne v3, v5, :cond_9b

    const/16 v3, 0x71

    const/16 v6, 0xd7

    const/16 v7, 0x66

    const/16 v8, 0xcc

    const/16 v9, 0xb

    if-ltz v1, :cond_8b

    if-lt v1, v9, :cond_93

    :cond_8b
    if-lt v1, v7, :cond_8f

    if-lt v1, v3, :cond_93

    :cond_8f
    if-lt v1, v8, :cond_b5

    if-ge v1, v6, :cond_b5

    :cond_93
    if-ltz v1, :cond_9d

    if-ge v1, v9, :cond_9d

    iget-object v3, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueLightFilterCustomValueArray:[I

    aget v3, v3, v1

    :cond_9b
    :goto_9b
    move v3, v2

    goto :goto_f6

    :cond_9d
    if-lt v1, v7, :cond_a9

    if-ge v1, v3, :cond_a9

    iget-object v3, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomValueArray:[I

    add-int/lit8 v6, v1, -0x66

    aget v3, v3, v6

    move v3, v4

    goto :goto_f6

    :cond_a9
    if-lt v1, v8, :cond_9b

    if-ge v1, v6, :cond_9b

    iget-object v3, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnhancedComfortCustomValueArray:[I

    add-int/lit16 v6, v1, -0xcc

    aget v3, v3, v6

    const/4 v3, 0x2

    goto :goto_f6

    :cond_b5
    const/16 v10, 0x132

    if-lt v1, v9, :cond_bb

    if-lt v1, v7, :cond_c3

    :cond_bb
    if-lt v1, v3, :cond_bf

    if-lt v1, v8, :cond_c3

    :cond_bf
    if-lt v1, v6, :cond_9b

    if-ge v1, v10, :cond_9b

    :cond_c3
    if-lt v1, v9, :cond_cb

    if-ge v1, v7, :cond_cb

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getNightModeCct()I

    goto :goto_9b

    :cond_cb
    if-ne v1, v3, :cond_d2

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getNightModeCct()I

    :goto_d0
    move v3, v5

    goto :goto_f6

    :cond_d2
    const/16 v3, 0x72

    if-lt v1, v3, :cond_e1

    if-ge v1, v8, :cond_e1

    add-int/lit8 v3, v1, -0x71

    div-int/lit8 v3, v3, 0x13

    add-int/2addr v3, v5

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getNightModeCct()I

    goto :goto_f6

    :cond_e1
    if-ne v1, v6, :cond_e7

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getNightModeCct()I

    goto :goto_d0

    :cond_e7
    const/16 v3, 0xd8

    if-lt v1, v3, :cond_9b

    if-ge v1, v10, :cond_9b

    add-int/lit16 v3, v1, -0xd7

    div-int/lit8 v3, v3, 0x13

    add-int/lit8 v3, v3, 0x8

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->getNightModeCct()I

    :goto_f6
    iget-boolean v6, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportBlueFilter:Z

    if-eqz v6, :cond_170

    iget-boolean v6, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    if-eqz v6, :cond_170

    if-ltz p2, :cond_170

    iget v6, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->NIGHT_MODE_MAX_INDEX:I

    if-gt p2, v6, :cond_170

    iget-boolean v2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v6, ", index : "

    const-string/jumbo v7, "SemMdnieManagerService"

    if-eqz v2, :cond_14b

    iget v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNaturalModeVersion:I

    const-string v2, "AP setNightMode : "

    if-ne v0, v5, :cond_130

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", night_display_idx : "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v0, p1, v3}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setBlueLightFilterMode(ZI)Z

    goto :goto_16b

    :cond_130
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v0, p1, v1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setBlueLightFilterMode(ZI)Z

    goto :goto_16b

    :cond_14b
    const-string v1, "/sys/class/mdnie/mdnie/night_mode"

    invoke-static {v1, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_16b

    const-string v1, "/sys/class/mdnie/mdnie1/night_mode"

    invoke-static {v1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_15e

    invoke-static {v1, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_15e
    const-string v1, "DDI setNightMode : "

    const-string v2, ", str : ("

    invoke-static {p2, v1, v6, v2, p1}, Lcom/android/server/accessibility/AccessibilityManagerService$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ")"

    invoke-static {v1, v0, v2, v7}, Lcom/android/server/BootReceiver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_16b
    :goto_16b
    iput-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iput p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    return v4

    :cond_170
    return v2
.end method

.method public final setNightModeBlock(Z)Z
    .locals 4

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeBlock:Z

    iget-object v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v2, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v3, "setNightModeBlock"

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v1, Ljava/lang/StringBuilder;

    const-string/jumbo v2, "setNightModeBlock : "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " - "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v2, v1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-nez p1, :cond_32

    invoke-virtual {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->disableNightMode()Z

    :cond_32
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeBlock:Z

    iput-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mWorkBlueFilter:Z

    return v0
.end method

.method public final setNightModeCct(I)Z
    .locals 2

    const-string/jumbo v0, "setNightModeCct : "

    const-string/jumbo v1, "SemMdnieManagerService"

    invoke-static {p1, v0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    iput p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterCct:I

    const/4 p0, 0x1

    return p0
.end method

.method public final setNightModeStep(I)Z
    .locals 2

    const-string/jumbo v0, "setNightModeStep : "

    const-string/jumbo v1, "SemMdnieManagerService"

    invoke-static {p1, v0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    iput p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mBlueFilterIndex:I

    const/4 p0, 0x1

    return p0
.end method

.method public final setScreenMode(I)Z
    .locals 3

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreenMode:Z

    if-nez v0, :cond_8

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportScreeenReadingMode:Z

    if-eqz v0, :cond_4c

    :cond_8
    invoke-virtual {p0, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->checkScreenMode(I)Z

    move-result v0

    if-eqz v0, :cond_4c

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string/jumbo v1, "SemMdnieManagerService"

    if-eqz v0, :cond_30

    const-string v0, "AP setScreenMode : "

    invoke-static {p1, v0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual {v0, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setScreenMode(I)Z

    new-instance v0, Ljava/io/File;

    const-string v1, "/sys/class/sensors/light_sensor/screen_mode"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :cond_48

    invoke-static {p1, v1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    goto :goto_48

    :cond_30
    const-string v0, "/sys/class/mdnie/mdnie/mode"

    invoke-static {p1, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_48

    const-string v0, "/sys/class/mdnie/mdnie1/mode"

    invoke-static {v0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_43

    invoke-static {p1, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_43
    const-string v0, "DDI setScreenMode : "

    invoke-static {p1, v0, v1}, Lcom/android/server/HermesService$3$$ExternalSyntheticOutline0;->m(ILjava/lang/String;Ljava/lang/String;)V

    :cond_48
    :goto_48
    iput p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mScreenMode:I

    const/4 p0, 0x1

    return p0

    :cond_4c
    const/4 p0, 0x0

    return p0
.end method

.method public final setWhiteRGB(IIIIII)Z
    .locals 7

    const-string/jumbo v0, "setWhiteRGB("

    const-string v1, ","

    invoke-static {p1, p2, v0, v1, v1}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p3, p4, v1, v1, v0}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    const-string v2, ")"

    invoke-static {p5, p6, v1, v2, v0}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v3, "SemMdnieManagerService"

    invoke-static {v3, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    if-eqz v0, :cond_ae

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplayEnabled:Z

    if-eqz v0, :cond_ae

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string v4, ") , Sub RGB offset ("

    if-eqz v0, :cond_3c

    const-string v0, "AP setWhiteBalanceMode : Main RGB offset ("

    invoke-static {p1, p2, v0, v1, v1}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p3, p4, v4, v1, v0}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    invoke-static {p5, p6, v1, v2, v0}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    invoke-virtual/range {p0 .. p6}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setWhiteBalanceMode(IIIIII)Z

    goto :goto_ae

    :cond_3c
    const-string p0, "/sys/class/mdnie/mdnie/whiteRGB"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    const-string v5, " "

    if-eqz v0, :cond_6d

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_6d
    const-string p0, "/sys/class/mdnie/mdnie1/whiteRGB"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_9c

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p4}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWriteSting(Ljava/lang/String;Ljava/lang/String;)Z

    :cond_9c
    const-string p0, "DDI setWhiteBalanceMode : Main RGB offset ("

    invoke-static {p1, p2, p0, v1, v1}, Lcom/android/internal/util/jobs/ArrayUtils$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-static {p3, p4, v4, v1, p0}, Lcom/android/server/ServiceKeeper$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)V

    invoke-static {p5, p6, v1, v2, p0}, Lcom/android/server/am/BroadcastController$$ExternalSyntheticOutline0;->m(IILjava/lang/String;Ljava/lang/String;Ljava/lang/StringBuilder;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v3, p0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0

    :cond_ae
    :goto_ae
    const/4 p0, 0x0

    return p0
.end method

.method public final setmDNIeAccessibilityMode(IZ)Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "setmDNIeAccessibilityMode"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "setmDNIeAccessibilityMode("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "SemMdnieManagerService"

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mCurtainModeIsRunning:Z

    const/4 v0, 0x0

    if-nez p0, :cond_68

    const/16 p0, 0xa

    if-eq p1, p0, :cond_61

    const-string p0, "/sys/class/mdnie/mdnie1/accessibility"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v1

    const-string v2, "/sys/class/mdnie/mdnie/accessibility"

    if-eqz v1, :cond_58

    if-eqz p2, :cond_44

    move v1, p1

    goto :goto_45

    :cond_44
    move v1, v0

    :goto_45
    invoke-static {v1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_57

    if-eqz p2, :cond_4e

    goto :goto_4f

    :cond_4e
    move p1, v0

    :goto_4f
    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_57

    const/4 p0, 0x1

    return p0

    :cond_57
    return v0

    :cond_58
    if-eqz p2, :cond_5b

    goto :goto_5c

    :cond_5b
    move p1, v0

    :goto_5c
    invoke-static {p1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    return p0

    :cond_61
    const-string p0, "/sys/class/backlight/panel/weakness_hbm_comp"

    invoke-static {p2, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    return p0

    :cond_68
    return v0
.end method

.method public final setmDNIeColorBlind(Z[I)Z
    .locals 4

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "setmDNIeColorBlind"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "setmDNIeColorBlind ("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v0, v1, v2}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)V

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mCurtainModeIsRunning:Z

    const/4 v0, 0x0

    if-nez p0, :cond_4e

    const-string p0, "/sys/class/mdnie/mdnie1/accessibility"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v1

    const-string v2, "/sys/class/mdnie/mdnie/accessibility"

    const/4 v3, 0x2

    if-eqz v1, :cond_46

    if-eqz p1, :cond_32

    move v1, v3

    goto :goto_33

    :cond_32
    move v1, v0

    :goto_33
    invoke-static {v1, v2, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite_CB(ILjava/lang/String;[I)Z

    move-result v1

    if-eqz v1, :cond_45

    if-eqz p1, :cond_3c

    goto :goto_3d

    :cond_3c
    move v3, v0

    :goto_3d
    invoke-static {v3, p0, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite_CB(ILjava/lang/String;[I)Z

    move-result p0

    if-eqz p0, :cond_45

    const/4 p0, 0x1

    return p0

    :cond_45
    return v0

    :cond_46
    if-eqz p1, :cond_49

    move v0, v3

    :cond_49
    invoke-static {v0, v2, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite_CB(ILjava/lang/String;[I)Z

    move-result p0

    return p0

    :cond_4e
    return v0
.end method

.method public final setmDNIeEmergencyMode(Z)Z
    .locals 4

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v0, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v1, "setmDNIeEmergencyMode"

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance p0, Ljava/lang/StringBuilder;

    const-string/jumbo v0, "setmDNIeEmergencyMode ("

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ")"

    const-string/jumbo v1, "SemMdnieManagerService"

    invoke-static {p0, v0, v1}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x0

    const/4 v0, 0x4

    if-eqz p1, :cond_24

    move v1, v0

    goto :goto_25

    :cond_24
    move v1, p0

    :goto_25
    const-string v2, "/sys/class/mdnie/mdnie/accessibility"

    invoke-static {v1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v1

    const-string v2, "/sys/class/mdnie/mdnie1/accessibility"

    invoke-static {v2}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3c

    if-eqz p1, :cond_36

    move p0, v0

    :cond_36
    invoke-static {p0, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    and-int/2addr p0, v1

    return p0

    :cond_3c
    return v1
.end method

.method public final setmDNIeNegative(Z)Z
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "setmDNIeNegative"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "setmDNIeNegative ("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v0, v1, v2}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)V

    iget-boolean p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mCurtainModeIsRunning:Z

    const/4 v0, 0x0

    if-nez p0, :cond_41

    const-string p0, "/sys/class/mdnie/mdnie1/accessibility"

    invoke-static {p0}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v1

    const-string v2, "/sys/class/mdnie/mdnie/accessibility"

    if-eqz v1, :cond_3c

    invoke-static {p1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3b

    invoke-static {p1, p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_3b

    const/4 p0, 0x1

    return p0

    :cond_3b
    return v0

    :cond_3c
    invoke-static {p1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    return p0

    :cond_41
    return v0
.end method

.method public final setmDNIeScreenCurtain(Z)Z
    .locals 4

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "com.samsung.android.permission.CHANGE_DISPLAY_COLOR"

    const-string/jumbo v2, "setmDNIeScreenCurtain"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string/jumbo v1, "setmDNIeScreenCurtain ("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    const-string/jumbo v2, "SemMdnieManagerService"

    invoke-static {v0, v1, v2}, Lcom/android/server/DeviceIdleController$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;Ljava/lang/String;Ljava/lang/String;)V

    iput-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mCurtainModeIsRunning:Z

    const/4 p0, 0x0

    const/4 v0, 0x3

    if-eqz p1, :cond_26

    move v1, v0

    goto :goto_27

    :cond_26
    move v1, p0

    :goto_27
    const-string v2, "/sys/class/mdnie/mdnie/accessibility"

    invoke-static {v1, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result v1

    const-string v2, "/sys/class/mdnie/mdnie1/accessibility"

    invoke-static {v2}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3e

    if-eqz p1, :cond_38

    move p0, v0

    :cond_38
    invoke-static {p0, v2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    move-result p0

    and-int/2addr p0, v1

    return p0

    :cond_3e
    return v1
.end method

.method public final updateAlwaysOnDisplay(ZI)V
    .locals 2

    if-eqz p1, :cond_25

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->afterimageCompensation:Lcom/samsung/android/hardware/display/AfterimageCompensationService;

    if-eqz p0, :cond_25

    iget-boolean v0, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->AfcStateCondition:Z

    if-eqz v0, :cond_25

    iget v0, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->mAfcType:I

    const/16 v1, 0xa

    if-lt v0, v1, :cond_25

    if-eqz p1, :cond_25

    iput-boolean p1, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->AfcThreadAODCondition:Z

    iput p2, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->AodBrightness:I

    iget-object p1, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->mAfcThread:Lcom/samsung/android/hardware/display/AfterimageCompensationService$AfcThread;

    if-eqz p1, :cond_25

    monitor-enter p1

    :try_start_1b
    iget-object p0, p0, Lcom/samsung/android/hardware/display/AfterimageCompensationService;->mAfcThread:Lcom/samsung/android/hardware/display/AfterimageCompensationService$AfcThread;

    invoke-virtual {p0}, Ljava/lang/Object;->notify()V

    monitor-exit p1

    return-void

    :catchall_22
    move-exception p0

    monitor-exit p1
    :try_end_24
    .catchall {:try_start_1b .. :try_end_24} :catchall_22

    throw p0

    :cond_25
    return-void
.end method
