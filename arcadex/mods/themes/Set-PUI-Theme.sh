# ==============================================================================
#
# MOD_NAME="Add PUI theme for Galaxy"
# MOD_AUTHOR="@FifthSnow and @HeheJuice"
# MOD_DESC="Applies PUI theme overlays to system."
#
# ==============================================================================

LOG_BEGIN "Adding PUI theme overlays.."

for f in "$SCRPATH/pui"/*.apk; do
    [ -f "$f" ] || continue
    cp -f "$f" "$WORKSPACE/product/overlay/"
done
