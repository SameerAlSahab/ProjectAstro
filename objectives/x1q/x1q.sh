# Device props
SIOP_POLICY_NAME=siop_x1q_sm8250
PLATFORM=sd_8250
STOCK_MODEL="SM-G981N"
STOCK_CSC="KOO"
STOCK_IMEI="355995110205095"

# The firmware to be used as source
MODEL="SM-G990B"
CSC="EUX"
IMEI="353718681151510"

# Extra firmware which is optional
#EXTRA_MODEL=""
#EXTRA_CSC=""
#EXTRA_IMEI=""


# External
# FILESYSTEM=ext4
# Need flash erofs supported kernel
FILESYSTEM="erofs"

# Custom props (If not used , it will use values from stock rom)
DEVICE_DISPLAY_HFR_MODE=3 # S20 5G supports adaptive refresh rate
DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ="30,48,60,96,120"
IDLE_TIMER_MS=250
TOUCH_TIMER_MS=300
DISPLAY_POWER_TIMER_MS=200
