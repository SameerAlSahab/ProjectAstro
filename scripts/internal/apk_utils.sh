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

# Special Thanks to @BlackMesa123 for his help and hints on github issues

# Sources:
# https://github.com/iBotPeaches/Apktool/issues/3775
# https://github.com/iBotPeaches/Apktool/pull/3879
# https://github.com/SameerAlSahab/smali_patch/blob/main/smali_patch.py
# https://github.com/iBotPeaches/Apktool/issues/1775


DEFAULT_SDK="36"  #branch sixteen
USABLE_THREADS=$(( $(nproc) - 1 ))
[[ $USABLE_THREADS -lt 1 ]] && USABLE_THREADS=1

PATCH_MARKER_FILE="$WORKSPACE/.patch_markers"

DO_SIGN_APK="false"  # coz disabled apk signature verification on framework.jar as of now
CERT_PEM=""
CERT_PK8=""

DECOMPILE_RES=false

APK_TO_DECOMPILE_RES=(
     wallpaper-res.apk
	 SecSettings.apk
	 SystemUI.apk
)


declare -A PATCH_CACHE


_LOAD_MARKERS()
{
    PATCH_CACHE=()

    if [[ -f "$PATCH_MARKER_FILE" ]]; then
        while read -r TARGET_NAME HASH || [[ -n "$TARGET_NAME" ]]; do
            PATCH_CACHE["$TARGET_NAME"]="$HASH"
        done < "$PATCH_MARKER_FILE"
    fi
}

_UPDATE_MARKER()
{
    local TARGET_NAME="$1"
    local HASH="$2"
    local TEMP_FILE=$(mktemp)

    touch "$PATCH_MARKER_FILE"

    awk -v name="$TARGET_NAME" -v h="$HASH" '
        $1 == name { print name, h; found=1; next; }
        { print }
        END { if (!found) print name, h; }
    ' "$PATCH_MARKER_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$PATCH_MARKER_FILE"
}


CALC_HASH()
{
    local PATCH_DIR="$1"
    find "$PATCH_DIR" \( -name "*.patch" -o -name "*.smalipatch" \) -type f -exec md5sum {} + | \
        sort | md5sum | cut -d' ' -f1
}



INSTALL_FRAMEWORK()
{
    local FRAMEWORK_APK="$WORKSPACE/system/system/framework/framework-res.apk"
    local SDK="$DEFAULT_SDK"

    if [[ -f "$BUILD_PROP" ]]; then
        local PROP_SDK=$(BPROP "system" "ro.build.version.sdk" | cut -d'=' -f2 | tr -d '[:space:]')
        [[ -n "$PROP_SDK" ]] && SDK="$PROP_SDK"
    fi

    local INSTALLED="$FRAMEWORK_DIR/1-${SDK}.apk"
    if [[ -f "$INSTALLED" ]]; then
        echo "$SDK"
        return 0
    fi

    [[ ! -f "$FRAMEWORK_APK" ]] && ERROR_EXIT "framework-res.apk missing"

    java -jar "$PREBUILTS/apktool/apktool.jar" if -p "$FRAMEWORK_DIR" -t "$SDK" "$FRAMEWORK_APK" > /dev/null || \
        ERROR_EXIT "Failed to install framework"

    echo "$SDK"
}


FIND_TARGET()
{
    local FILE_NAME="$1"

    # JAR files are at system/framework
    if [[ "$FILE_NAME" == *.jar ]]; then
        local SYSTEM_DIR=$(GET_PARTITION_PATH "system") || true
        if [[ -n "$SYSTEM_DIR" && -f "$SYSTEM_DIR/framework/$FILE_NAME" ]]; then
            echo "$SYSTEM_DIR/framework/$FILE_NAME"
            return 0
        fi
    fi


    # As of now , we dont need partition paths except them
    if [[ "$FILE_NAME" == *.apk ]]; then
        local PARTITIONS=("system" "system_ext" "product")
        for PART in "${PARTITIONS[@]}"; do
            local PART_DIR=$(GET_PARTITION_PATH "$PART") || continue
            [[ -z "$PART_DIR" || ! -d "$PART_DIR" ]] && continue

                # For now we take app and priv-app cause preload and hidden apps are useless.
            local SUBDIRS=("app" "priv-app")
            for SUBDIR in "${SUBDIRS[@]}"; do
                [[ ! -d "$PART_DIR/$SUBDIR" ]] && continue
                local FOUND=$(find "$PART_DIR/$SUBDIR" -maxdepth 3 -name "$FILE_NAME" -print -quit 2>/dev/null)
                if [[ -n "$FOUND" ]]; then
                    echo "$FOUND"
                    return 0
                fi
            done
        done
    fi

    return 1
}


DECOMPILE()
{
    local FILE="$1"
    [[ -z "$FILE" ]] && ERROR_EXIT "No input file"
    [[ "$FILE" != /* ]] && FILE="$WORKSPACE/$FILE"
    [[ ! -f "$FILE" ]] && ERROR_EXIT "File not found: $FILE"

    local NAME=$(basename "$FILE")
    local EXT="${NAME##*.}"
    local DIR=$(dirname "$FILE")
    local WORK_DIR="$DIR/${NAME}_decompiled"

    [[ -d "$WORK_DIR" ]] && rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"

    LOG_INFO "Decompiling $NAME"

    local SDK=$(INSTALL_FRAMEWORK)
    local API="$SDK"
    local TEMP_DEX=$(mktemp)
    local DEX_MAGIC=""

    if unzip -p "$FILE" "classes.dex" > "$TEMP_DEX" 2>/dev/null; then
        API=$(GET_DEX_API "$TEMP_DEX")
        DEX_MAGIC=$(xxd -s 4 -l 4 -p "$TEMP_DEX")
    fi
    rm -f "$TEMP_DEX"

    mkdir -p "$WORK_DIR/.meta"
    echo "$API" > "$WORK_DIR/.meta/api"
    echo "$SDK" > "$WORK_DIR/.meta/sdk"

    # DEX v041 Container Bypass (OneUI 8+). I saw OneUI8+ uses dex 041 for services.jar
    if [[ "$DEX_MAGIC" == "30343100" ]]; then

    # Decompile with --no-src
        java -jar "$PREBUILTS/apktool/apktool.jar" d -api "$API" -f -j "$USABLE_THREADS" \
            -o "$WORK_DIR" -p "$FRAMEWORK_DIR" -t "$SDK" -s "$FILE" > /dev/null 2>&1 || \
            ERROR_EXIT "Decompile failed"

    # Baksmali each dex parts
        local PART=1
        while true; do
            local INPUT="$FILE/classes.dex"
            local OUT="smali"
            [[ $PART -gt 1 ]] && INPUT="$FILE/classes.dex/$PART" && OUT="smali_classes$PART"

            java -jar "$PREBUILTS/smali/baksmali.jar" d -a "$API" -j "$USABLE_THREADS" \
                --ac false --di false -l -o "$WORK_DIR/$OUT" "$INPUT" > /dev/null 2>&1

            if [[ $? -ne 0 || ! -d "$WORK_DIR/$OUT" ]]; then
                rm -rf "$WORK_DIR/$OUT"
                break
            fi

            ((PART++))
            [[ $PART -gt 99 ]] && break
        done
        rm -f "$WORK_DIR/classes"*.dex
    else

        # Standard flags
        local FLAGS=("-f" "-j" "$USABLE_THREADS" "-o" "$WORK_DIR" "-p" "$FRAMEWORK_DIR" "-t" "$SDK" "-s")

        # Resource decompile for listed APKs we declared on top
		local IN_LIST="false"
		for ITEM in "${APK_TO_DECOMPILE_RES[@]}"; do
			[[ "$ITEM" == "$NAME" ]] && IN_LIST="true" && break
		done


if ! GET_FEATURE "DECOMPILE_RES" || [[ "$IN_LIST" != "true" ]]; then
    FLAGS+=("-r")
fi

        java -jar "$PREBUILTS/apktool/apktool.jar" d "${FLAGS[@]}" "$FILE" > /dev/null 2>&1 || \
            ERROR_EXIT "Decompile failed"

        # Baksmali all DEX files
        find "$WORK_DIR" -maxdepth 1 -name "*.dex" | while read -r DEX; do
            local D_NAME=$(basename "$DEX")
            local OUT="smali"
            [[ "$D_NAME" != "classes.dex" ]] && OUT="smali_${D_NAME%.dex}"

            java -jar "$PREBUILTS/smali/baksmali.jar" d -a "$API" --ac false --di false \
                -j "$USABLE_THREADS" -l -o "$WORK_DIR/$OUT" "$DEX" > /dev/null 2>&1

            rm -f "$DEX"
        done
    fi

    # Extract extra resources for JARs (Issue found on OneUI6+)
    if [[ "$EXT" == "jar" ]] && unzip -l "$FILE" | grep -q "debian.mime.types"; then
        mkdir -p "$WORK_DIR/__res__"
        unzip -qo "$FILE" "res/*" -d "$WORK_DIR/__res__"
    fi

    LOG_END "Decompiled $NAME"
}


BUILD() {
    local FILE="$1"
    
    [[ -z "$FILE" ]] && ERROR_EXIT "No file specified"
    
    if [[ "$FILE" != /* ]]; then
        FILE="$WORKSPACE/$FILE"
    fi

    local NAME
    NAME=$(basename "$FILE")
    local EXT="${NAME##*.}"
    local DIR
    DIR=$(dirname "$FILE")
    local WORK_DIR="$DIR/${NAME}_decompiled"
    local DIST_DIR="$WORK_DIR/dist"
    local BUILT_FILE="$DIST_DIR/$NAME"

    [[ ! -d "$WORK_DIR" ]] && ERROR_EXIT "Decompiled folder not found: $WORK_DIR"

    LOG_INFO "Building $NAME"

    local API="$DEFAULT_SDK"
    if [[ -f "$WORK_DIR/.meta/api" ]]; then
        API=$(cat "$WORK_DIR/.meta/api")
    fi

    mkdir -p "$DIST_DIR"


    local APKTOOL_FLAGS=(
        "b"
        "-api" "$API"
        "-j" "$USABLE_THREADS"
        "-p" "$FRAMEWORK_DIR"
        "-o" "$BUILT_FILE"
    )

    if [[ "$EXT" == "apk" ]]; then
        # -c: Copies original META-INF and manifest (Preserves original structure)
        APKTOOL_FLAGS+=("-c") 
    fi

    local BUILD_OUTPUT
    if ! BUILD_OUTPUT=$(java -jar "$PREBUILTS/apktool/apktool.jar" "${APKTOOL_FLAGS[@]}" "$WORK_DIR" 2>&1); then
        LOG_WARN "Recompilation failed. Check logs below:"
		
        # We dont show I: information of progress until get an error. Same thing -q flag do
        echo "$BUILD_OUTPUT" | sed '/^I:/d' 
        return 1
    fi


    if [[ "$EXT" == "apk" ]]; then
            # Sign the apk if turned on
        if [[ "$DO_SIGN_APK" == "true" ]]; then
            LOG_INFO "Signing APK..."
            local UNSIGNED="$DIST_DIR/${NAME}.unsigned"
            mv "$BUILT_FILE" "$UNSIGNED"
            
            if ! java -jar "$PREBUILTS/signapk/signapk.jar" "$CERT_PEM" "$CERT_PK8" \
                "$UNSIGNED" "$BUILT_FILE" > /dev/null 2>&1; then
                ERROR_EXIT "Sign failed"
            fi
            rm -f "$UNSIGNED"
        else
            # Zipalign APKs
		    # https://developer.android.com/tools/zipalign
            local ALIGNED="$DIST_DIR/aligned.apk"
            if zipalign -p -f 4 "$BUILT_FILE" "$ALIGNED" > /dev/null 2>&1; then
                mv -f "$ALIGNED" "$BUILT_FILE"
            else
                ERROR_EXIT "Apk Zipalign failed."
            fi
        fi
    fi

    # Add missing resources for JARs [Android14+ bug] See DECOMPILE function for more info.
    if [[ "$EXT" == "jar" && -d "$WORK_DIR/__res__" ]]; then
        (cd "$WORK_DIR/__res__" && zip -qr "$BUILT_FILE" .)
    fi

    mv -f "$BUILT_FILE" "$FILE"
    rm -rf "$WORK_DIR"

    rm -f "$DIR/$NAME.prof" "$DIR/$NAME.bprof"
    rm -rf "$DIR/oat" 

    LOG_END "Built $NAME"
    return 0
}


# For instance , patch failed we will start from scratch
RESTORE_TARGET()
{
    local TARGET_NAME="$1"
    local CURRENT_PATH="$2"
    local SOURCE_DIR=$(GET_FW_DIR "main") || ERROR_EXIT "Workspace not found"

    local SOURCE=""
    if [[ "$TARGET_NAME" == *.jar ]]; then
        SOURCE="$SOURCE_DIR/system/system/framework/$TARGET_NAME"
    elif [[ "$TARGET_NAME" == *.apk ]]; then

    # As of now , we dont need partition paths except them
        local PARTITIONS=("system/system" "system_ext" "product")
        for PART in "${PARTITIONS[@]}"; do
            [[ ! -d "$SOURCE_DIR/$PART" ]] && continue
            SOURCE=$(find "$SOURCE_DIR/$PART" -name "$TARGET_NAME" -print -quit 2>/dev/null)
            [[ -n "$SOURCE" ]] && break
        done
    fi

    [[ -z "$SOURCE" || ! -f "$SOURCE" ]] && return 1


    if cmp --silent "$SOURCE" "$CURRENT_PATH"; then
        return 0
    fi

     cp -f "$SOURCE" "$CURRENT_PATH" || ERROR_EXIT "Failed to revert changes for $TARGET_NAME"

    LOG_END "Restored $TARGET_NAME"

    return 0
}


BUILD_ALL()
{
    local FOUND="false"

    while IFS= read -r -d '' WORK_DIR; do
        FOUND="true"
        local DIR_NAME=$(basename "$WORK_DIR")
        local FILE_NAME="${DIR_NAME%_decompiled}"
        local PARENT=$(dirname "$WORK_DIR")
        local ORIGINAL="$PARENT/$FILE_NAME"
        local RELATIVE="${ORIGINAL#$WORKSPACE/}"

        if [[ -f "$ORIGINAL" ]]; then
            BUILD "$RELATIVE" || ERROR_EXIT "Failed to build $FILE_NAME"
        else
            LOG_WARN "Source missing for $FILE_NAME"
        fi
    done < <(find "$WORKSPACE" -type d -name "*_decompiled" -print0)

    [[ "$FOUND" == "false" ]] && return 0

    return 0
}

#https://github.com/iBotPeaches/Apktool/issues/3775
GET_DEX_API()
{
    local DEX_FILE="$1"
    local HEX_SIG=$(xxd -s 4 -l 4 -p "$DEX_FILE")

    case "$HEX_SIG" in
        "30333500") echo "23" ;;
        "30333700") echo "25" ;;
        "30333800") echo "27" ;;
        "30333900") echo "29" ;;
        "30343000") echo "34" ;;
        "30343100") echo "35" ;;
        *) echo "$DEFAULT_SDK" ;;
    esac
}


_APKTOOL_PATCH() {

    _LOAD_MARKERS

    local SEARCH_PATHS=(
    "$OBJECTIVES_DIR/$CODENAME"
    "$PROJECT_DIR"
    "$WORKSPACE/patches"
)

    local TARGETS=()
    declare -A TARGET_MAP


    for BASE in "${SEARCH_PATHS[@]}"; do
        [[ ! -d "$BASE" ]] && continue
        while IFS= read -r -d '' DIR; do
            local NAME=$(basename "$DIR")
            [[ -z "${TARGET_MAP[$NAME]}" ]] && TARGETS+=("$NAME")
            TARGET_MAP[$NAME]+="$DIR "
        done < <(find "$BASE" -type d \( -name "*.apk" -o -name "*.jar" \) -print0)
    done

    if [[ ${#TARGETS[@]} -eq 0 ]]; then
        LOG_INFO "No apk files to patch"
        BUILD_ALL
        return 0
    fi


    for TARGET in "${TARGETS[@]}"; do
        local PATCH_DIRS=(${TARGET_MAP[$TARGET]})


        local HASH=""
        for P_DIR in "${PATCH_DIRS[@]}"; do
            HASH+=$(CALC_HASH "$P_DIR")
        done
        HASH=$(echo "$HASH" | md5sum | cut -d' ' -f1)

        local CACHED="${PATCH_CACHE[$TARGET]:-}"


        if [[ -n "$CACHED" && "$CACHED" == "$HASH" ]]; then
            continue
        fi


        local TARGET_FILE=$(FIND_TARGET "$TARGET")
        if [[ -z "$TARGET_FILE" ]]; then
            LOG_WARN "File not found $TARGET"
            continue
        fi

        local WORK_DIR="$(dirname "$TARGET_FILE")/${TARGET}_decompiled"


        if [[ -n "$CACHED" && "$CACHED" != "$HASH" ]]; then
            LOG_INFO "Changes detected in $TARGET"
            [[ -d "$WORK_DIR" ]] && rm -rf "$WORK_DIR"
            RESTORE_TARGET "$TARGET" "$TARGET_FILE" || ERROR_EXIT "Failed to revert changes $TARGET"
        fi


        if [[ ! -d "$WORK_DIR" ]]; then
            local RELATIVE="${TARGET_FILE#$WORKSPACE/}"
            DECOMPILE "$RELATIVE" || ERROR_EXIT "Decompile failed: $TARGET"
        fi


        local PATCHES=()
        for P_DIR in "${PATCH_DIRS[@]}"; do
            while IFS= read -r -d '' P; do
                PATCHES+=("$P")
            done < <(find "$P_DIR" -maxdepth 1 \( -name "*.patch" -o -name "*.smalipatch" \) -type f -print0)
        done
        IFS=$'\n' PATCHES=($(sort -V <<<"${PATCHES[*]}")); unset IFS

        # Apply our patches
        # TODO: show error logs only , wil do later

        for P in "${PATCHES[@]}"; do
            local P_NAME=$(basename "$P")
            LOG_INFO "Applying $P_NAME"

            if [[ "$P_NAME" == *.patch ]]; then
                (
                    cd "$WORK_DIR" || ERROR_EXIT "Cannot change directory to $WORK_DIR"

                    # 
                    # -p1: Strip one leading directory component from file paths.
                    # -s: Work silently unless an error occurs. (Clean output)
                    # -f: Force/Ignore bad Prereq patches, assume unreversed.
                    # -l: Ignore white space changes (line endings, indentation) for better matching.
                    # --dry-run: Test the patch without modifying any files.
					#
                    patch -p1 -s -f -l --dry-run < "$P" >/dev/null 2>&1

                    if [[ $? -eq 0 ]]; then
                        patch -p1 -s -f -l < "$P" >/dev/null 2>&1
                    else
                        exit 1
                    fi
                ) || {
                    rm -rf "$WORK_DIR"
                    ERROR_EXIT "Patch failed for $P_NAME"
                }

            elif [[ "$P_NAME" == *.smalipatch ]]; then
                local SMALI_BIN="$PREBUILTS/smalipatch/smali_patch.py"
                python3 "$SMALI_BIN" "$WORK_DIR" "$P" || {
                    rm -rf "$WORK_DIR"
                    ERROR_EXIT "Smali patch failed for $P_NAME"
                }
            fi
        done


        # Merge resources and run scripts
        for P_DIR in "${PATCH_DIRS[@]}"; do
            for SUB in "res" "smali" "assets" "lib"; do
                [[ -d "$P_DIR/$SUB" ]] && rsync -a "$P_DIR/$SUB/" "$WORK_DIR/$SUB/"
            done
            for S_CLASS in "$P_DIR"/smali_classes*; do
                [[ -d "$S_CLASS" ]] && rsync -a "$S_CLASS/" "$WORK_DIR/$(basename "$S_CLASS")/"
            done

 for SCRIPT in "$P_DIR"/*.sh; do
 if [[ -f "$SCRIPT" ]]; then
 LOG_INFO "Executing $(basename "$SCRIPT")"
 (cd "$WORK_DIR" && . "$SCRIPT") || ERROR_EXIT "Script failed: $(basename "$SCRIPT")"
 fi
 done
        done

        _UPDATE_MARKER "$TARGET" "$HASH"

        LOG_END "Patched $TARGET"
    done

    BUILD_ALL
}


ADD_PATCH()
{
    local TARGET="$1"
    local SOURCE="$2"

    [[ -z "$TARGET" || -z "$SOURCE" ]] && \
        ERROR_EXIT "Usage: ADD_PATCH <apk|jar> <patch_dir_or_file>"

    [[ ! -e "$SOURCE" ]] && \
        ERROR_EXIT "Source not found: $SOURCE"

    local DEST="$WORKSPACE/patches/$TARGET"
    mkdir -p "$DEST"

    if [[ -f "$SOURCE" ]]; then

        case "$SOURCE" in
            *.patch|*.smalipatch)
                cp -f "$SOURCE" "$DEST/"
                ;;
        esac
    else

        rsync -a \
            --include="*/" \
            --include="*.patch" \
            --include="*.smalipatch" \
            --include="res/**" \
            --include="smali/**" \
            --include="smali_classes*/**" \
            --include="assets/**" \
            --include="lib/**" \
            --exclude="*" \
            "$SOURCE/" "$DEST/"


        find "$DEST" -type d -empty -delete
    fi
}
