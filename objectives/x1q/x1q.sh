# Device props
MODEL_NAME="Galaxy S20 5G"
CODENAME="x1q"
SIOP_POLICY_NAME=siop_x1q_sm8250
VNDK="30"
PLATFORM=sd_8250
STOCK_MODEL="SM-G981N"
STOCK_CSC="KOO"
STOCK_IMEI="355995110205095"

# The firmware to be used as source
MODEL="SM-S908U1"
CSC="ATT"
IMEI="359185441860000"

# Extra firmware which is optional
#EXTRA_MODEL=""
#EXTRA_CSC=""
#EXTRA_IMEI=""


# External
# FILESYSTEM=ext4
# Need flash erofs supported kernel
FILESYSTEM="erofs"


# Specs
DEVICE_HAVE_SPEN_SUPPORT=false
DEVICE_HAVE_QHD_PANEL=true
DEVICE_HAVE_HIGH_REFRESH_RATE=true
DEVICE_HAVE_ESIM_SUPPORT=true

# Custom props (If not used , it will use values from stock rom)
DEVICE_DISPLAY_HFR_MODE=3 # S20 5G supports adaptive refresh rate
DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ="30,48,60,96,120"
IDLE_TIMER_MS=250
TOUCH_TIMER_MS=300
DISPLAY_POWER_TIMER_MS=200
