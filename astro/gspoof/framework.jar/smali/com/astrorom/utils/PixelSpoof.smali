#
# PixelSpoof is inspired by Salvo's https://github.com/salvogiangri/UN1CA/blob/sixteen/unica/mods/settings/smali/system/framework/framework.jar/0002-Introduce-SamsungPropsHooks.patch'

.class public Lcom/astrorom/utils/PixelSpoof;
.super Ljava/lang/Object;
.source "PixelSpoof.java"

# static fields
.field private static final FEATURES:[Ljava/lang/String;

.field private static final FEATURES_PHOTOS:[Ljava/lang/String;

.field private static final PACKAGES_TO_SPOOF:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 27

    const-string v0, "com.google.android.feature.PIXEL_2017_PRELOAD"
    const-string v1, "com.google.android.feature.PIXEL_2018_PRELOAD"
    const-string v2, "com.google.android.feature.PIXEL_2019_PRELOAD"
    const-string v3, "com.google.android.feature.PIXEL_2019_MIDYEAR_PRELOAD"
    const-string v4, "com.google.android.feature.PIXEL_2020_PRELOAD"
    const-string v5, "com.google.android.feature.PIXEL_2020_MIDYEAR_PRELOAD"
    const-string v6, "com.google.android.feature.PIXEL_2021_PRELOAD"
    const-string v7, "com.google.android.feature.PIXEL_2021_MIDYEAR_PRELOAD"
    const-string v8, "com.google.android.feature.PIXEL_2022_PRELOAD"
    const-string v9, "com.google.android.feature.PIXEL_2022_MIDYEAR_PRELOAD"
    const-string v10, "com.google.android.feature.PIXEL_2023_PRELOAD"
    const-string v11, "com.google.android.feature.PIXEL_2024_PRELOAD"
    const-string v12, "com.google.android.feature.TURBO_PRELOAD"
    const-string v13, "com.google.android.feature.ADAPTIVE_CHARGING"
    const-string v14, "com.google.android.feature.ASI"
    filled-new-array/range {v0 .. v14}, [Ljava/lang/String;
    move-result-object v0
    sput-object v0, Lcom/astrorom/utils/PixelSpoof;->FEATURES:[Ljava/lang/String;

    const-string v0, "com.google.android.apps.photos.NEXUS_PRELOAD"
    const-string v1, "com.google.android.apps.photos.nexus_preload"
    const-string v2, "com.google.android.feature.PIXEL_EXPERIENCE"
    const-string v3, "com.google.android.feature.GOOGLE_BUILD"
    const-string v4, "com.google.android.feature.GOOGLE_EXPERIENCE"
    filled-new-array {v0, v1, v2, v3, v4}, [Ljava/lang/String;
    move-result-object v0
    sput-object v0, Lcom/astrorom/utils/PixelSpoof;->FEATURES_PHOTOS:[Ljava/lang/String;

    const-string v0, "com.google.android.apps.recorder"
    const-string v1, "com.google.android.keep"
    const-string v2, "com.google.android.apps.nexuslauncher"
    const-string v3, "com.google.android.as"
    const-string v4, "com.google.android.deskclock"
    const-string v5, "com.google.android.calendar"
    const-string v6, "com.google.android.apps.wellbeing"
    const-string v7, "com.google.android.apps.privacy.wildlife"
    const-string v8, "com.google.android.apps.subscriptions.red"
    const-string v9, "com.google.android.inputmethod.latin"
    const-string v10, "com.google.android.GoogleCamera"
    const-string v11, "com.google.android.apps.googleassistant"
    const-string v12, "com.google.android.dialer"
    const-string v13, "com.google.android.contacts"
    const-string v14, "com.google.android.apps.messaging"
    const-string v15, "com.google.android.apps.docs"
    const-string v16, "com.google.android.apps.restore"
    const-string v17, "com.google.android.youtube"
    const-string v18, "com.google.android.apps.youtube.music"
    const-string v19, "com.netflix.ninja"
    const-string v20, "com.google.android.apps.tachyon"
    const-string v21, "com.google.android.apps.wallpaper"
    const-string v22, "com.google.android.soundpicker"
    const-string v23, "com.google.android.apps.turbo"
    const-string v24, "com.google.android.apps.bard"
    filled-new-array/range {v0 .. v24}, [Ljava/lang/String;
    move-result-object v0
    sput-object v0, Lcom/astrorom/utils/PixelSpoof;->PACKAGES_TO_SPOOF:[Ljava/lang/String;

    return-void
.end method

.method private static setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    .locals 2
    :try_start_0
    const-class v0, Landroid/os/Build;
    invoke-virtual {v0, p0}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v0
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1, p1}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_12
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_12} :catch_12
    :catch_12
    return-void
.end method

.method public static setProps(Landroid/content/Context;)V
    .locals 5
    const-string v0, "astro_pixel_props"
    const/4 v1, 0x1
    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    if-nez v0, :cond_a
    return-void

    :cond_a
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object p0

    const-string v0, "com.google.android.apps.photos"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_photos_skip
    invoke-static {}, Lcom/astrorom/utils/PixelSpoof;->spoofPixelXL()V
    return-void

    :cond_photos_skip
    sget-object v0, Lcom/astrorom/utils/PixelSpoof;->PACKAGES_TO_SPOOF:[Ljava/lang/String;
    array-length v2, v0
    const/4 v3, 0x0
    :goto_12
    if-ge v3, v2, :cond_23
    aget-object v4, v0, v3
    invoke-virtual {p0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :cond_20
    invoke-static {}, Lcom/astrorom/utils/PixelSpoof;->spoofPixel10()V
    return-void
    :cond_20
    add-int/lit8 v3, v3, 0x1
    goto :goto_12
    :cond_23
    return-void
.end method

.method public static shouldSpoof(Ljava/lang/String;)Z
    .locals 7
    const/4 v0, 0x0
    const-string v1, "astro_unlimited_photos"
    const/4 v2, 0x1
    invoke-static {v1, v2}, Landroid/os/SemSystemProperties;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    if-nez v1, :cond_b
    return v0

    :cond_b
    invoke-static {}, Landroid/app/ActivityThread;->currentPackageName()Ljava/lang/String;
    move-result-object v1


    const-string v3, "com.google.android.apps.photos"
    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :cond_check_others
    sget-object v1, Lcom/astrorom/utils/PixelSpoof;->FEATURES_PHOTOS:[Ljava/lang/String;
    goto :goto_features_loop

    :cond_check_others
    sget-object v3, Lcom/astrorom/utils/PixelSpoof;->PACKAGES_TO_SPOOF:[Ljava/lang/String;
    array-length v4, v3
    const/4 v5, 0x0
    :goto_find_pkg
    if-ge v5, v4, :cond_pkg_not_found
    aget-object v6, v3, v5
    invoke-virtual {v6, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-eqz v6, :cond_pkg_next
    sget-object v1, Lcom/astrorom/utils/PixelSpoof;->FEATURES:[Ljava/lang/String;
    goto :goto_features_loop
    :cond_pkg_next
    add-int/lit8 v5, v5, 0x1
    goto :goto_find_pkg
    :cond_pkg_not_found
    return v0

    :goto_features_loop
    array-length v3, v1
    const/4 v4, 0x0
    :goto_26
    if-ge v4, v3, :cond_34
    aget-object v5, v1, v4
    invoke-virtual {v5, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-eqz v5, :cond_31
    return v2
    :cond_31
    add-int/lit8 v4, v4, 0x1
    goto :goto_26
    :cond_34
    return v0
.end method

.method private static spoofPixel10()V
    .locals 2
    const-string v0, "BRAND"
    const-string v1, "google"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "MANUFACTURER"
    const-string v1, "Google"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "DEVICE"
    const-string/jumbo v1, "mustang"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "PRODUCT"
    const-string/jumbo v1, "mustang"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "MODEL"
    const-string v1, "Pixel 10 Pro XL"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "FINGERPRINT"
    const-string v1, "google/mustang/mustang:16/BD3A.251005.003.W4/14331773:user/release-keys"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "ID"
    const-string v1, "BD3A.251005.003.W4"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "TAGS"
    const-string/jumbo v1, "release-keys"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "TYPE"
    const-string/jumbo v1, "user"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    return-void
.end method

.method private static spoofPixelXL()V
    .locals 2

    const-string v0, "BRAND"
    const-string v1, "google"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "MANUFACTURER"
    const-string v1, "Google"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "DEVICE"
    const-string/jumbo v1, "marlin"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "PRODUCT"
    const-string/jumbo v1, "marlin"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "MODEL"
    const-string v1, "Pixel XL"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "FINGERPRINT"
    const-string v1, "google/marlin/marlin:10/QP1A.191005.007.A3/5972223:user/release-keys"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    const-string v0, "ID"
    const-string v1, "QP1A.191005.007.A3"
    invoke-static {v0, v1}, Lcom/astrorom/utils/PixelSpoof;->setPropValue(Ljava/lang/String;Ljava/lang/Object;)V
    return-void
.end method
