#
# Copyright (c) 2026 Sameer Al Sahab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Galaxy Fold 3 5G config
CODENAME="q2q"
PLATFORM="sm8350"

# Stock firmware details for download
STOCK_MODEL="SM-F926B"
STOCK_CSC="XSG"
STOCK_IMEI="353249141751335"

# Source firmware details for download
MODEL="SM-F936B"
CSC="XSG"
IMEI="351843261422552"

# Extra firmware (Optional) details for download
EXTRA_MODEL=""
EXTRA_CSC=""
EXTRA_IMEI=""

# Output
FILESYSTEM=ext4


#
# The following values are auto genarated by auto_gen.sh.
# Manually uncomment and set values here to override default stock values.
#

###
# DEVICE_MODEL_NAME=""                          # Brand name from settings config
# DEVICE_SIOP_POLICY_FILENAME=""                # Thermal/SIOP policy filename

### Display
# DEVICE_DISPLAY_HFR_MODE="2"                   # High Frame Rate Mode (0=60Hz)
# DEVICE_HAVE_HIGH_REFRESH_RATE=""              # Device have high refresh rate or not
# DEVICE_DISPLAY_REFRESH_RATE_VALUES_HZ="60,120" # Supported rates by display (e.g., 60,120)
# DEVICE_DEFAULT_REFRESH_RATE=""                # Initial boot refresh rate
# DEVICE_HAVE_QHD_PANEL=""                      # True if QHD display device
# DEVICE_HAVE_AMOLED_DISPLAY=""                 # True if amoled display device
# DEVICE_AUTO_BRIGHTNESS_LEVEL=""               # Light sensor behavior
# DEVICE_MDNIE_MODE=""                          # Samsung mDnie color profile

### Audio
# DEVICE_HAVE_DUAL_SPEAKER="true"                   # true for Stereo, false for Mono

### Extra features
# DEVICE_HAVE_SPEN_SUPPORT="true"                   # Device have SPen support
# DEVICE_HAVE_ESIM_SUPPORT="true"                   # Device have esim support
# DEVICE_HAVE_NPU=""                            # Device have NPU

### Build Properties
# DEVICE_FIRST_API_VERSION=""                   # ro.vendor.build.version.release
# DEVICE_FIRST_SDK_VERSION=""                   # ro.vendor.build.version.sdk
# DEVICE_VNDK_VERSION="30"                        # VNDK version
# DEVICE_SINGLE_SYSTEM_IMAGE=""                 # ro.product.system.device

### External
# DEVICE_FINGERPRINT_SENSOR_TYPE=""             # Biometric sensor type
# DEVICE_HAVE_LEGACY_FACE_HAL=""                # Have legacy Samsung 2.0 biometric face libraries

