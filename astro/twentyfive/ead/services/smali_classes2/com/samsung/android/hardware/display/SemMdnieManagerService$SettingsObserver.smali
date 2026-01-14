.class public final Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;
.super Landroid/database/ContentObserver;
.source "qb/103929649 219d93a284d1fff4b5709e5ce2b5a222211f6ba2ee96a17027c5dc5683cbd672"


# instance fields
.field public final AOD_SHOW_STATE_URI:Landroid/net/Uri;

.field public final EAD_ENABLED_URI:Landroid/net/Uri;

.field public final NIGHT_DIM_URI:Landroid/net/Uri;

.field public final VIVIDNESS_STATE_URI:Landroid/net/Uri;

.field public final resolver:Landroid/content/ContentResolver;

.field public final synthetic this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;


# direct methods
.method public constructor <init>(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V
    .locals 1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    invoke-direct {p0, v0}, Landroid/database/ContentObserver;-><init>(Landroid/os/Handler;)V

    iget-object p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->resolver:Landroid/content/ContentResolver;

    const-string/jumbo p1, "blue_light_filter_night_dim"

    invoke-static {p1}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->NIGHT_DIM_URI:Landroid/net/Uri;

    const-string/jumbo p1, "ead_enabled"

    invoke-static {p1}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->EAD_ENABLED_URI:Landroid/net/Uri;

    const-string/jumbo p1, "aod_show_state"

    invoke-static {p1}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->AOD_SHOW_STATE_URI:Landroid/net/Uri;

    const-string/jumbo p1, "vividness_intensity"

    invoke-static {p1}, Landroid/provider/Settings$System;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->VIVIDNESS_STATE_URI:Landroid/net/Uri;

    return-void
.end method


# virtual methods
.method public final onChange(ZLandroid/net/Uri;)V
    .locals 11

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->FP_FEATURE_SENSOR_IS_OPTICAL:Ljava/lang/String;

    const-string/jumbo v0, "optical"

    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    const-string v0, "DDI setVividnessMode : "

    const-string v1, "AP setVividnessMode : "

    const-string/jumbo v2, "SEC_FLOATING_FEATURE_LCD_CONFIG_VIVIDNESS"

    const-string/jumbo v3, "VIVIDNESS_STATE_URI onChange"

    const-string v4, "/sys/class/mdnie/mdnie1/vividness"

    const-string v5, "/sys/class/mdnie/mdnie/vividness"

    const/4 v6, 0x0

    const-string/jumbo v7, "SemMdnieManagerService"

    if-nez p1, :cond_1a6

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v8, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->resolver:Landroid/content/ContentResolver;

    const-string/jumbo v9, "aod_show_state"

    const/4 v10, -0x2

    invoke-static {v8, v9, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v8

    const/4 v9, 0x1

    if-ne v8, v9, :cond_30

    move v8, v9

    goto :goto_31

    :cond_30
    move v8, v6

    :goto_31
    iput-boolean v8, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAlwaysOnDisplayEnabled:Z

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->AOD_SHOW_STATE_URI:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_92

    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "AOD_SHOW_STATE_SETTINGS onChange. mAlwaysOnDisplayEnabled : "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAlwaysOnDisplayEnabled:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " , mDisplayOn : "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayOn:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " , mDisplayState : "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayState:I

    invoke-static {p1, p2, v7}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mAlwaysOnDisplayEnabled:Z

    if-eqz p1, :cond_6f

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p2, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightDimOffMode(IZ)Z

    return-void

    :cond_6f
    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayOn:Z

    if-eqz p1, :cond_7b

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p1, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    return-void

    :cond_7b
    iget p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayState:I

    if-ne p1, v9, :cond_87

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p2, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightDimOffMode(IZ)Z

    return-void

    :cond_87
    const/4 p2, 0x2

    if-ne p1, p2, :cond_19f

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p1, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    return-void

    :cond_92
    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->NIGHT_DIM_URI:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_a9

    const-string p1, "BLUE_LIGHT_FILTER_NIGHT_DIM onChange"

    invoke-static {v7, p1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightMode:Z

    iget p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mNightModeIndex:I

    invoke-virtual {p0, p1, p2}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->setNightMode(ZI)Z

    return-void

    :cond_a9
    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->EAD_ENABLED_URI:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_143

    const-string p1, "EAD_ENABLED_URI onChange"

    invoke-static {v7, p1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p2, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mEnvironmentAdaptiveDisplaySupported:Z

    if-eqz p2, :cond_19f

    iget-boolean p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    const-string/jumbo p2, "ead_enabled"

    if-eqz p1, :cond_f2

    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "AP setEnvironmentAdaptiveDisplayMode : "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v0, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-static {v0, p2, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v7, p1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v0, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    iget-object p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    invoke-static {p1, p2, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result p1

    invoke-virtual {v0, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setEnvironmentAdaptiveDisplayMode(I)Z

    goto :goto_13d

    :cond_f2
    const-string p1, "/sys/class/mdnie/mdnie/adaptive_mode"

    invoke-static {p1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_109

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v0, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-static {v0, p2, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    invoke-static {v0, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_109
    const-string p1, "/sys/class/mdnie/mdnie1/adaptive_mode"

    invoke-static {p1}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_120

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v0, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-static {v0, p2, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result v0

    invoke-static {v0, p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_120
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "DDI setEnvironmentAdaptiveDisplayMode : "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object v0, v0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-static {v0, p2, v6, v10}, Landroid/provider/Settings$System;->getIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v7, p1}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_13d
    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    invoke-static {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->-$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    return-void

    :cond_143
    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->VIVIDNESS_STATE_URI:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1a0

    invoke-static {v7, v3}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object p1

    invoke-virtual {p1, v2, v6}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result p1

    if-lez p1, :cond_19f

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    invoke-static {p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->-$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    if-eqz p1, :cond_179

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, p2, v7}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-virtual {p1, p0}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setVividnessMode(I)Z

    return-void

    :cond_179
    invoke-static {v5}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_186

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, v5}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_186
    invoke-static {v4}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_193

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, v4}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_193
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, p0, v7}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    :cond_19f
    return-void

    :cond_1a0
    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    invoke-static {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->-$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    return-void

    :cond_1a6
    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->VIVIDNESS_STATE_URI:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_202

    invoke-static {v7, v3}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Lcom/samsung/android/feature/SemFloatingFeature;->getInstance()Lcom/samsung/android/feature/SemFloatingFeature;

    move-result-object p1

    invoke-virtual {p1, v2, v6}, Lcom/samsung/android/feature/SemFloatingFeature;->getInt(Ljava/lang/String;I)I

    move-result p1

    if-lez p1, :cond_202

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    invoke-static {p1}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->-$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-boolean p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mSupportAPmDNIe:Z

    if-eqz p1, :cond_1dc

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, p2, v7}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget-object p2, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mDisplayAiqeManager:Lcom/samsung/android/displayaiqe/DisplayAiqeManager;

    iget p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-virtual {p2, p1}, Lcom/samsung/android/displayaiqe/DisplayAiqeManager;->setVividnessMode(I)Z

    goto :goto_202

    :cond_1dc
    invoke-static {v5}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1e9

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, v5}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_1e9
    invoke-static {v4}, Lcom/android/server/BatteryService$$ExternalSyntheticOutline0;->m(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1f6

    iget-object p1, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p1, p1, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, v4}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->sysfsWrite(ILjava/lang/String;)Z

    :cond_1f6
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    iget p2, p2, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->mVividnessIndex:I

    invoke-static {p1, p2, v7}, Lcom/android/server/RescueParty$RescuePartyObserver$$ExternalSyntheticOutline0;->m(Ljava/lang/StringBuilder;ILjava/lang/String;)V

    :cond_202
    :goto_202
    iget-object p0, p0, Lcom/samsung/android/hardware/display/SemMdnieManagerService$SettingsObserver;->this$0:Lcom/samsung/android/hardware/display/SemMdnieManagerService;

    invoke-static {p0}, Lcom/samsung/android/hardware/display/SemMdnieManagerService;->-$$Nest$msetting_is_changed(Lcom/samsung/android/hardware/display/SemMdnieManagerService;)V

    return-void
.end method
