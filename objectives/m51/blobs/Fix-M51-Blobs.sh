#
# Usage: FF_FW "TAG" "VALUE"
# FF_FW "TAG" "" ->> means deletion of line from floating_feature.xml in both WORKSPACE and STOCK_FW
# Modifies /system/system/etc/floating_feature.xml both in STOCK_FW and WORKSPACE for Samsung-specific features
#
FF_FW() {
    local TAG="$1"
    local TAG_VALUE="$2"
    local FF_XML_FILE="${WORKSPACE}/system/system/etc/floating_feature.xml"
    local FF_FW_XML_FILE="${STOCK_FW}/system/system/etc/floating_feature.xml"

    if ! command -v xmlstarlet &> /dev/null; then
        ERROR_EXIT "xmlstarlet not found."
        return 1
    fi

    _SEC_FF_PREFIX TAG

    if [[ -z "$TAG_VALUE" ]]; then
        for file in "$FF_XML_FILE" "$FF_FW_XML_FILE"; do
            if xmlstarlet sel -t -v "//${TAG}" "$file" &>/dev/null; then
                xmlstarlet ed -L -d "//${TAG}" "$file"
                LOG "Deleted floating feature: <${TAG}> ($file)"
            fi
        done
        return
    fi

    for file in "$FF_XML_FILE" "$FF_FW_XML_FILE"; do
        if [[ ! -f "$file" ]]; then
            mkdir -p "$(dirname "$file")"
            cat > "$file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<SecFloatingFeatureSet>
</SecFloatingFeatureSet>
EOF
            LOG_INFO "Created new floating_feature.xml ($file)"
        fi

        local current_value
        current_value=$(xmlstarlet sel -t -v "//${TAG}" "$file" 2>/dev/null || true)

        if [[ -n "$current_value" ]]; then
            if [[ "$current_value" != "$TAG_VALUE" ]]; then
                xmlstarlet ed -L -u "//${TAG}" -v "$TAG_VALUE" "$file"
                LOG "Updated : <${TAG}>${TAG_VALUE}</${TAG}> ($file)"
            else
                LOG_INFO "Unchanged : <${TAG}> already set to ${TAG_VALUE} ($file)"
            fi
        else
            xmlstarlet ed -L -s '/SecFloatingFeatureSet' -t elem -n "$TAG" -v "$TAG_VALUE" "$file"
            LOG "Added : <${TAG}>${TAG_VALUE}</${TAG}> ($file)"
        fi
    done
}

#
# Adds, updates, or deletes entries in a `build.prop` file from a specific partition in both WORKSPACE and STOCK_FW.
# Usage: BPROP_FW <partition> <tag> <value>
# To delete a property: BPROP_FW <partition> <tag> ""
#
BPROP_FW() {
    local partition="$1"
    local tag="$2"
    local value="$3"

    local ASTRO_MARKER="# Added by AstroROM [scripts/Internal/props.sh]"
    local END_MARKER="# end of file"
    local prop_file
    local root

    if [[ -z "$partition" || -z "$tag" ]]; then
        ERROR_EXIT "BPROP_FW: Partition and Tag are required."
        return 1
    fi

    for root in "$WORKSPACE" "${STOCK_FW:-}"; do
        [[ -n "$root" ]] || continue

        if ! prop_file=$(_FIND_PROP_IN_PARTITION "$root" "$partition" "$tag"); then
            prop_file=$(_RESOLVE_PROP_FILE "$root" "$partition")
        fi

        if [[ -z "$prop_file" || ! -f "$prop_file" ]]; then
            LOG_INFO "Cannot set property. No build.prop found for partition '$partition' in $root. Skipping ${tag}."
            continue
        fi

        local tmp_file
        tmp_file=$(mktemp)
        cp "$prop_file" "$tmp_file"

        if [[ -z "$value" ]]; then
            if grep -q "^${tag}=" "$tmp_file"; then
                sed -i "/^${tag}=/d" "$tmp_file"
                LOG "Deleted property from ${partition} (${root}): ${tag}"
            else
                LOG_INFO "Property not found in ${partition} (${root}): ${tag} (Nothing to delete)."
            fi

        elif grep -q "^${tag}=" "$tmp_file"; then

            sed -i "s|^${tag}=.*|${tag}=${value}|" "$tmp_file"
            LOG_INFO "Updated existing property in ${partition} (${root}): ${tag}=${value}"

        else

            local insert_content=""
            if ! grep -Fq "$ASTRO_MARKER" "$tmp_file"; then
                insert_content="${ASTRO_MARKER}\n"
            fi
            insert_content="${insert_content}${tag}=${value}"

            if grep -Fq "$END_MARKER" "$tmp_file"; then
                local end_footer
                end_footer=$(echo "$END_MARKER" | sed 's/[]\/$*.^[]/\\&/g')
                sed -i "/$end_footer/i $insert_content" "$tmp_file"
            else
                echo -e "$insert_content" >> "$tmp_file"
            fi

            LOG "Added new property to ${partition} (${root}): ${tag}=${value}"
        fi

        if ! mv -f "$tmp_file" "$prop_file"; then
            rm -f "$tmp_file"
            ERROR_EXIT "Failed to write changes to $prop_file"
            return 1
        fi
    done
}


LOG "Patching a52q firmware with m51 device tree"

LOG_BEGIN "- Removing a52q specific vendor blobs"

LOG_BEGIN "- Removing init, soundbooster, audconf"
REMOVE "vendor" "etc/init/hw/init.a52q.rc"
REMOVE "system" "lib/lib_SoundBooster_ver1050.so"
REMOVE "system" "lib64/lib_SoundBooster_ver1050.so"
REMOVE "vendor" "lib/lib_SoundBooster_ver1050.so"
REMOVE "vendor" "lib64/lib_SoundBooster_ver1050.so"
REMOVE "vendor" "lib/hw/audio.primary.atoll.so"
REMOVE "vendor" "etc/audconf/ODM"
LOG_END

LOG_BEGIN "- Removing sensor blobs"
REMOVAL_LIST="$(cd "$WORKSPACE/vendor/etc" 2>/dev/null && find sensors -type f -print 2>/dev/null | sort || true)"
while IFS= read -r file; do 
    [ -z "$file" ] && continue
    [ ! -f "$SCRPATH/vendor/etc/$file" ] && REMOVE "vendor" "etc/$file"
done <<< "$REMOVAL_LIST"
LOG_END

LOG_BEGIN "- Removing camera libraries"
REMOVAL_LIST="$(find "$WORKSPACE/vendor" -type f -path '*/lib*/camera/*' -printf '%P\n' 2>/dev/null | sort || true)"
while IFS= read -r file; do 
    [ -z "$file" ] && continue
    [ ! -f "$SCRPATH/vendor/$file" ] && REMOVE "vendor" "$file"
done <<< "$REMOVAL_LIST"
LOG_END

LOG_END 

LOG_BEGIN "- Patching a52q properties with m51"
BPROP_FW "system" "ro.factory.model" "SM-M515F"
BPROP_FW "system" "ro.build.flavor" "m51nsxx-user"
BPROP_FW "product" "ro.product.product.name" "m51nsxx"
BPROP_FW "vendor" "ro.product.board" "sm6150"
BPROP_FW "vendor" "ro.board.platform" "sm6150"
BPROP_FW "vendor" "ro.hardware.chipname" "SM7150"
BPROP_FW "vendor" "ro.soc.model" "SM7150"
BPROP_FW "vendor" "ro.vendor.build.fingerprint" "samsung/m51nsxx/m51:11/RP1A.200720.012/M515FXXS6DXE4:user/release-keys"
BPROP_FW "vendor" "ro.vendor.build.version.incremental" "M515FXXS6DXE4"
BPROP_FW "vendor" "ro.product.vendor.device" "m51"
BPROP_FW "vendor" "ro.product.vendor.model" "SM-M515F"
BPROP_FW "vendor" "ro.product.vendor.name" "m51nsxx"
BPROP_FW "vendor" "ro.netflix.bsp_rev" "Q7250-19133-1"
BPROP_FW "vendor" "ro.bootimage.build.fingerprint" "samsung/m51nsxx/m51:11/RP1A.200720.012/M515FXXS6DXE4:user/release-keys"
BPROP_FW "odm" "ro.odm.build.fingerprint" "samsung/m51nsxx/m51:11/RP1A.200720.012/M515FXXS6DXE4:user/release-keys"
BPROP_FW "odm" "ro.odm.build.version.incremental" "M515FXXS6DXE4"
BPROP_FW "odm" "ro.product.odm.device" "m51"
BPROP_FW "odm" "ro.product.odm.model" "SM-M515F"
BPROP_FW "odm" "ro.product.odm.name" "m51nsxx"
LOG_END

LOG_BEGIN "- Running hex patches for atoll -> sm6150"
find "$WORKSPACE/vendor" -type f -name '*atoll*' -print0 2>/dev/null |
while IFS= read -r -d '' f; do
  HEX_EDIT "${f#$WORKSPACE/}" "61746F6C6C2E736F00" "736D363135302E736F"
  mv -- "$f" "${f//atoll/sm6150}" 2>/dev/null
done
LOG_END

LOG_BEGIN "- Replacing a52q props with m51"
sed -i -e 's|sm7125|sm7150|g' -e 's|a52q|m51|g' -e 's|A52|M51|g' "$WORKSPACE/vendor/etc/floating_feature.xml"
sed -i 's|a52q|m51|g' "$WORKSPACE/vendor/etc/ev_lux_map_config.xml" "$WORKSPACE/vendor/etc/sensorhub_services.json"
sed -i 's|A52|M51|g' "$WORKSPACE/vendor/etc/selinux/vendor_sepolicy_version"
sed -i 's|atoll|sm6150|g' "$WORKSPACE/vendor/etc/vramdiskd.xml"
LOG_END

LOG_BEGIN "- Replacing media profiles into odm with vendor"
cp -r "$WORKSPACE/vendor/etc/media_profiles_V1_0.xml" "$WORKSPACE/odm/etc"
LOG_END

LOG_BEGIN "- Replacing a52q blobs with m51"
git clone https://github.com/mehedihjoy0/M51-Device-Tree $SCRPATH/tree
cp -r "$SCRPATH/tree/system/"* "$WORKSPACE/system/system"
cp -r "$SCRPATH/tree/system/"* "$STOCK_FW/system/system"
cp -r "$SCRPATH/tree/vendor/"* "$WORKSPACE/vendor"
cp -r "$SCRPATH/tree/vendor/"* "$STOCK_FW/vendor"
rm -rf "$SCRPATH/tree"
LOG_END

LOG_BEGIN "- Replacing csc partitions with $DEVICE_MODEL"
find "$WORKSPACE/optics" -type f -exec \
sed -i -E "s/SM-[A-Z0-9]+/$DEVICE_MODEL/g" {} +
find "$WORKSPACE/prism" -type f -exec \
sed -i -E "s/SM-[A-Z0-9]+/$DEVICE_MODEL/g" {} +
sed -i 's/.*/M515FOXM6DXE4/' "$WORKSPACE/prism/etc/CSCVersion.txt"
xmlstarlet ed -L -u "//CSCName" -v "M515FOXM" "$WORKSPACE/prism/etc/SW_Configuration.xml"
xmlstarlet ed -L -u "//CSCVersion" -v "6DXE4" "$WORKSPACE/prism/etc/SW_Configuration.xml"
LOG_END

# Device specific
FF_FW "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_BRAND_NAME" "Galaxy M51"
FF_FW "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_DEFAULT_FONT_SIZE" "3"
FF_FW "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_FCC_ID" "A3LSMM515F"
FF_FW "SEC_FLOATING_FEATURE_SYSTEMUI_CONFIG_CORNER_ROUND" "2.0"
FF_FW "SEC_FLOATING_FEATURE_LOCKSCREEN_CONFIG_PUNCHHOLE_VI" "face,pos:0.5:0.02292,size:0.1018:0.04583,type:circle"


LOG "- M51IFY has been completed successfully"
