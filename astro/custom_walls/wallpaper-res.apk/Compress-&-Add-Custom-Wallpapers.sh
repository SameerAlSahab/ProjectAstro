
# Settings
TARGET_RES_IMG="3200"
TARGET_FPS="60"
VIDEO_RES=1080
SCALE_FACTOR="0.5"
ADD_CUSTOM_WALL=false

RES_DIR="$WORK_DIR/res"
DRAWABLE_DIR="$RES_DIR/drawable-nodpi-v4"
RAW_DIR="$RES_DIR/raw"
VALUES_DIR="$RES_DIR/values"
JSON_MAIN="$RAW_DIR/resources_info.json"
STRINGS_XML="$VALUES_DIR/strings.xml"
PUBLIC_XML="$VALUES_DIR/public.xml"
CUSTOM_DIR="$PROJECT_DIR/custom_walls/res"


FFMPEG_FIX_ARGS="-c:v libx264 -pix_fmt yuv420p -crf 18 -g 1 -preset veryslow -tune zerolatency -movflags use_metadata_tags -map_metadata 0 -video_track_timescale 360000 -movie_timescale 90000"


increment_hex() {
    local hex=$1
    local dec=$(printf "%d" "$hex")
    local next_dec=$((dec + 1))
    printf "0x%x" "$next_dec"
}


for cmd in jq ffmpeg cwebp bc ffprobe; do
    if ! command -v $cmd &> /dev/null; then echo "Error: $cmd missing."; exit 1; fi
done

echo "Scaling stock wallpapers..."

shopt -s globstar nullglob
for img in "$RES_DIR"/**/*.webp; do
    cwebp -q 90 "$img" -o "${img}.tmp" 2>/dev/null && mv -f "${img}.tmp" "$img"
done
for vid in "$RAW_DIR/video_"*.mp4; do
    ffmpeg -y -i "$vid" -vf "fps=$TARGET_FPS,scale=$VIDEO_RES:-2,setsar=1:1" $FFMPEG_FIX_ARGS -c:a copy "$vid.tmp.mp4" >/dev/null 2>&1 && mv -f "$vid.tmp.mp4" "$vid"
done

if [ "$ADD_CUSTOM_WALL" = true ] && [ -d "$CUSTOM_DIR" ]; then
    LOG_BEGIN "Adding custom wallpapers if exist.."

    NEXT_INDEX=$(jq '[.phone[].index] | max + 1' "$JSON_MAIN")

    shopt -s nullglob
    for file in "$CUSTOM_DIR"/*; do
        extension="${file##*.}"
        filename=$(basename "$file")


        if [[ "$extension" =~ ^(jpg|png|webp)$ ]]; then
            TYPE="image"
            LAST_FILE_NUM=$(find "$DRAWABLE_DIR" -name "wallpaper_*.webp" | grep -oE '[0-9]+' | sort -rn | head -1)
            [ -z "$LAST_FILE_NUM" ] && LAST_FILE_NUM=0
            NEW_NAME=$(printf "wallpaper_%03d" $((10#$LAST_FILE_NUM + 1)))
            FINAL_FILENAME="${NEW_NAME}.webp"
            cwebp -q 100 -resize 0 "$TARGET_RES_IMG" "$file" -o "$DRAWABLE_DIR/$FINAL_FILENAME" 2>/dev/null
        elif [[ "$extension" == "mp4" ]]; then
            TYPE="video"
            LAST_FILE_NUM=$(find "$RAW_DIR" -name "video_*.mp4" | grep -oE '[0-9]+' | sort -rn | head -1)
            [ -z "$LAST_FILE_NUM" ] && LAST_FILE_NUM=0
            NEW_NAME=$(printf "video_%03d" $((10#$LAST_FILE_NUM + 1)))
            FINAL_FILENAME="${NEW_NAME}.mp4"
            ffmpeg -y -i "$file" $FFMPEG_FIX_ARGS -vf "fps=60,scale=1080:-2,setsar=1:1" -c:a copy "$RAW_DIR/$FINAL_FILENAME" 2>/dev/null
        else
            continue
        fi


        LAST_ASTRO_NUM=$(grep -oE 'astro_custom_[0-9]+' "$JSON_MAIN" | grep -oE '[0-9]+' | sort -rn | head -1)
        [ -z "$LAST_ASTRO_NUM" ] && LAST_ASTRO_NUM=0
        ASTRO_ID_NUM=$((LAST_ASTRO_NUM + 1))
        ASTRO_ID="astro_custom_${ASTRO_ID_NUM}"

        LAST_DRAW_ID=$(grep 'type="drawable"' "$PUBLIC_XML" | tail -n 1 | grep -oE 'id="0x[0-9a-f]+"' | cut -d'"' -f2)
        NEXT_DRAW_ID=$(increment_hex "$LAST_DRAW_ID")
        # Get last string ID
        LAST_STR_ID=$(grep 'type="string"' "$PUBLIC_XML" | tail -n 1 | grep -oE 'id="0x[0-9a-f]+"' | cut -d'"' -f2)
        NEXT_STR_ID=$(increment_hex "$LAST_STR_ID")

        # Insert before </resources>
        sed -i "/<\/resources>/i \    <public type=\"drawable\" name=\"${NEW_NAME}\" id=\"${NEXT_DRAW_ID}\" />" "$PUBLIC_XML"
        sed -i "/<\/resources>/i \    <public type=\"string\" name=\"${ASTRO_ID}\" id=\"${NEXT_STR_ID}\" />" "$PUBLIC_XML"

        sed -i "/<\/resources>/i \    <string name=\"${ASTRO_ID}\">Astro Custom ${ASTRO_ID_NUM}</string>" "$STRINGS_XML"

        tmp_json=$(mktemp)
        if [ "$TYPE" == "image" ]; then
            jq --argjson idx "$NEXT_INDEX" --arg fn "$FINAL_FILENAME" --arg sid "$ASTRO_ID" \
               '.phone += [{"isDefault": false, "index": $idx, "which": 1, "screen": 0, "type": 0, "filename": $fn, "frame_no": -1, "desc_str_id": $sid, "cmf_info": ["custom"]}]' \
               "$JSON_MAIN" > "$tmp_json" && mv "$tmp_json" "$JSON_MAIN"
        else
            FRAMES=$(ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of csv=p=0 "$RAW_DIR/$FINAL_FILENAME")
            HALF_FRAMES=$((FRAMES / 2))
            jq --argjson idx "$NEXT_INDEX" --arg fn "$FINAL_FILENAME" --argjson f "$FRAMES" --argjson hf "$HALF_FRAMES" --arg sid "$ASTRO_ID" \
               '.phone += [{"isDefault": false, "index": $idx, "which": 7, "screen": 0, "target_screen_only": true, "type": 10, "type_params": {"content_type": "infinity", "service_package_name": "com.samsung.android.wallpaper.live", "service_class_name": "com.samsung.android.wallpaper.live.infinity.InfinityWallpaper", "service_settings": {"filename": $fn, "thumbnail_system_frame_no": $f, "thumbnail_lock_frame_no": $hf, "thumbnail_frame_no": $hf, "transition_frame_info": ("AOD HOME 0 " + ($f|tostring) + " 1000 0.33 0 0.1 1")}}, "filename": $fn, "frame_no": $f, "desc_str_id": $sid, "cmf_info": ["custom"]}]' \
               "$JSON_MAIN" > "$tmp_json" && mv "$tmp_json" "$JSON_MAIN"
        fi

        NEXT_INDEX=$((NEXT_INDEX + 1))
    done

    LOG_END "Wallpaper Patch applied."
elif [ "$ADD_CUSTOM_WALL" = false ]; then
    echo "Custom wallpaper addition is disabled."
else
    echo "Custom wallpaper directory not found: $CUSTOM_DIR"
fi
