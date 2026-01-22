#TEE have things of bootloader
#We are building using latest firmware (latest binary and one ui 8)
# Latest unlockeable BL is based on binary I (one ui 7) so, we can use OneUI 8 vendor with vendor/tee folder from OneUI 7 (binary I)
# Requires one ui 7 libsec-ril.so to have working ril
REMOVE "vendor" "tee"
