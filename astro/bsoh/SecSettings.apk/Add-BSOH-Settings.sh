# Scamsung only added this bomb in Galaxy A23

BOMB_MODEL="SM-A236B"
OLD_PROP="ro.product.model"
NEW_PROP="ro.product.astro.model"


BPROP "system" "ro.product.astro.model" "$STOCK_MODEL"

# Add entries in floating feature

FF "BATTERY_SUPPORT_BSOH_SETTINGS" "TRUE"
FF "BATTERY_SUPPORT_SBP_INFO_SETTINGS" "TRUE"


PLANT_MODEL="$STOCK_MODEL"


find . -type f -name "*.smali" | while read -r smali; do
    if grep -q "$BOMB_MODEL" "$smali"; then
        
        # Replace bomb / plant 
        sed -i "s/$BOMB_MODEL/$PLANT_MODEL/g" "$smali"

        sed -i "s/ro\.product\.model/$NEW_PROP/g" "$smali"

    fi
done

# Real model name in settings
find . -type f -name "ModelNameGetter.smali" | while read -r smali; do
    if grep -q "ro.product.model" "$smali"; then
        sed -i "s/ro\.product\.model/ro.boot.em.model/g" "$smali"
        
    fi
done

LOG_END "BSOH patch applied"