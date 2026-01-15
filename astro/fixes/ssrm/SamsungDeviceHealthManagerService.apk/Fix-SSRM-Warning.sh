find . -type f -name "*.smali" | while read -r file; do
    if grep -q '"SSRM Warning"' "$file" && grep -q '"I got it"' "$file"; then

        method_line=$(grep -B 20 '"SSRM Warning"' "$file" | grep "^\.method" | tail -1)
        method_name=$(echo "$method_line" | awk '{print $3}')

        start_line=$(grep -n "^\.method.*${method_name}" "$file" | head -n 1 | cut -d: -f1)
        end_line=$(awk -v start="$start_line" 'NR>start && /^\.end method/{print NR; exit}' "$file")

        if ! [[ "$start_line" =~ ^[0-9]+$ ]] || ! [[ "$end_line" =~ ^[0-9]+$ ]]; then
            continue
        fi

        {
            sed -n "1,$((start_line-1))p" "$file"
            sed -n "${start_line}p" "$file"
            echo "    .locals 1"
            echo ""
            echo "    const/4 v0, 0x0"
            echo ""
            echo "    return-void"
            sed -n "${end_line}p" "$file"
            sed -n "$((end_line+1)),\$p" "$file"
        } > "${file}.tmp"

        mv "${file}.tmp" "$file"
        echo "Patched: $file"

    fi
done
