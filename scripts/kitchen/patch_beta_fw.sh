PATCH_BETA_FW() {
    local model=$1
    local csc=$2

    local ODIN_FOLDER="${FW_BASE}/${model}_${csc}"
    local CURRENT_MODEL="${WORKDIR}/${model}"
    local BETA_DIR="$WORKDIR/beta_ota"
    local UNPACK_CONF="${CURRENT_MODEL}/unpack.conf"
    local TOOLS="$PREBUILTS/imgpatchtools"


    local target_partitions=(system product system_ext odm vendor_dlkm odm_dlkm system_dlkm vendor)

    LOG_BEGIN "Extracting firmware for $model"

    mkdir -p "$CURRENT_MODEL" "$BETA_DIR"

    local ap_file
    ap_file=$(find "$ODIN_FOLDER" -maxdepth 1 \( -name "AP_*.tar.md5" -o -name "AP_*.tar" \) | head -1)
    [[ -z "$ap_file" ]] && { ERROR_EXIT "AP package missing for $model"; return 1; }

    local current_data
    current_data=$(_GET_FILE_STAT "$ap_file")

    if [[ -f "$UNPACK_CONF" ]]; then
        local cached_data
        cached_data=$(source "$UNPACK_CONF" && echo "$METADATA")
        if [[ "$cached_data" == "$current_data" && -f "${CURRENT_MODEL}/.extraction_complete" ]]; then
            LOG_INFO "$model firmware already extracted and merged."
            return 0
        fi
    fi

    LOG_INFO "Unpacking $model  firmware.."
    rm -rf "${CURRENT_MODEL:?}"/*
    mkdir -p "$CURRENT_MODEL"

    local super_img="$CURRENT_MODEL/super.img"
    FETCH_FILE "$ap_file" "super.img" "$CURRENT_MODEL" >/dev/null || {
        rm -f "$UNPACK_CONF" "${CURRENT_MODEL}/.extraction_complete"
        ERROR_EXIT "Failed to extract super.img from $ap_file"
        return 1
    }

    if IS_GITHUB_ACTIONS; then
        rm -f "$ap_file"
        rm -rf "$ODIN_FOLDER"
    fi


if [[ ! -f "$BETA_DIR/beta.zip" ]]; then
        LOG_INFO "Downloading beta OTA package..."
        curl -fL --user-agent "Mozilla/5.0" "$BETA_OTA_URL" -o "$BETA_DIR/beta.zip" || {
            ERROR_EXIT "Download failed. The URL might be expired or blocked."
            return 1
        }
    fi


    if [[ ! -f "$BETA_DIR/system.transfer.list" ]]; then
        LOG_INFO "Extracting beta OTA package..."
        unzip -q -o "$BETA_DIR/beta.zip" -d "$BETA_DIR" || { ERROR_EXIT "Unzip failed"; return 1; }
    fi


    if [[ ! -f "$UNPACK_CONF" ]]; then
        local super_raw="$CURRENT_MODEL/super.raw"
        if file "$super_img" | grep -q "sparse"; then
            "$PREBUILTS/android-tools/simg2img" "$super_img" "$super_raw" >/dev/null
        else
            cp "$super_img" "$super_raw"
        fi

        local lpdump_output
        lpdump_output=$("$PREBUILTS/android-tools/lpdump" "$super_raw" 2>&1)

        local super_size metadata_size metadata_slots group_name group_size
        super_size=$(echo "$lpdump_output" | awk '/Partition name: super/,/Flags:/ {if ($1=="Size:") {print $2; exit}}')
        metadata_size=$(echo "$lpdump_output" | awk '/Metadata max size:/ {print $4}')
        metadata_slots=$(echo "$lpdump_output" | awk '/Metadata slot count:/ {print $4}')
        read -r group_name group_size <<< $(echo "$lpdump_output" | awk '/Group table:/ {in_table=1} in_table && /Name:/ {name=$2} in_table && /Maximum size:/ {size=$3; if(size+0>0){print name,size; exit}}')

        cat > "$UNPACK_CONF" <<EOF
METADATA="$current_data"
SUPER_SIZE="$super_size"
METADATA_SIZE="$metadata_size"
METADATA_SLOTS="$metadata_slots"
GROUP_NAME="$group_name"
GROUP_SIZE="$group_size"
EXTRACT_DATE="$(date '+%Y-%m-%d %H:%M:%S')"
PARTITIONS=""
EOF
        rm -f "$super_raw"
    fi

    LOG_INFO "Extracting sparse partitions from super..."
    7z x "$super_img" -o"$CURRENT_MODEL" "*.img" -y >/dev/null 2>&1
    rm -f "$super_img"


    LOG_BEGIN "Applying beta OTA patches"


    local OP_LIST="$BETA_DIR/dynamic_partitions_op_list"
    if [[ -f "$OP_LIST" ]]; then
        while read -r op part size; do
            [[ "$op" != "resize" ]] && continue
            [[ "$part" == "vendor" ]] && { LOG_INFO "Skipping resize for $part"; continue; }
            local target="$CURRENT_MODEL/$part.img"
            [[ ! -f "$target" ]] && target="$CURRENT_MODEL/${part}_a.img"
            if [[ -f "$target" ]]; then
                LOG_INFO "Resizing $part to $size"
                truncate -s "$size" "$target"
            fi
        done < "$OP_LIST"
    fi

    for part in "${target_partitions[@]}"; do
        local part_img=""

        for suffix in "_a" ""; do
            if [[ -f "$CURRENT_MODEL/${part}${suffix}.img" ]]; then
                part_img="$CURRENT_MODEL/${part}${suffix}.img"
                [[ "$suffix" == "_a" ]] && mv "$part_img" "$CURRENT_MODEL/$part.img" && part_img="$CURRENT_MODEL/$part.img"
                break
            fi
        done

        [[ -z "$part_img" ]] && continue



        if [[ -f "$BETA_DIR/$part.transfer.list" ]]; then
            LOG_INFO "Patching $part..."
            SILENT "$TOOLS/BlockImageUpdate" \
                "$part_img" \
                "$BETA_DIR/$part.transfer.list" \
                "$BETA_DIR/$part.new.dat" \
                "$BETA_DIR/$part.patch.dat" || { ERROR_EXIT "$part patch failed"; return 1; }
        fi


        UNPACK_PARTITION "$part_img" "$model" || { ERROR_EXIT "Failed to unpack $part"; return 1; }
        rm -f "$part_img"
    done

    find "$CURRENT_MODEL" -maxdepth 1 -type f -name "*_b.img" -delete
    touch "${CURRENT_MODEL}/.extraction_complete"

    if [[ -n "${SUDO_USER:-}" ]]; then
        chown -R "$SUDO_USER:$SUDO_USER" "$WORKDIR"
        chmod -R 755 "$WORKDIR"
    fi

    rm -rf $BETA_DIR

    return 0
}
