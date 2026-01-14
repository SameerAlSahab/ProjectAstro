#OMC Edit Plugin for Dynamic Installer
#by @BlassGO

#Needs cscfeature variable
#Also need auto_mount_partitions for Old devices

#Mount
try_mount /sec_efs || abort "CANT MOUNT: /sec_efs"
try_mount -e /odm

#Check type of OMC
if exist /system_root/optics/configs /system_root/prism/etc; then ported=true
elif exist "$(find_block -e optics)"; then newdevice=true
elif exist "$(find /product -type d -name "omc")" || exist "$(find /odm -type d -name "omc")"; then partdevice=true
elif exist "$(find /system -type d -name "omc")" || exist /system/csc; then olddevice=true
fi

#save type of device
if defined newdevice; then
   echo2 "DEVICE: NEW DEVICE with /optics /prism"
elif defined partdevice; then
   echo2 "DEVICE: NEW DEVICE with /product /odm"
elif defined olddevice; then
   echo2 "DEVICE: OLD DEVICE"
elif defined ported; then
   echo2 "DEVICE: OLD DEVICE but with /optics /prism"
fi

#Getting OMC PATH
if defined newdevice; then
     try_mount -rw -e /optics /prism || abort " CANT MOUNT: /optics or /prism "
     omc_path=/optics
elif defined partdevice; then
     for omc in /product /odm; do
        tryomc=$(find "$omc" -type f -name "cscfeature.xml" | head -n1)
        if defined tryomc; then
           if is_substring "/conf/" "$tryomc"; then
              conf=true
              omc_path=$(dirname "$(dirname "$(dirname "$tryomc")")")
           else 
              omc_path=$(dirname "$(dirname "$tryomc")")
           fi
        fi
     done
elif defined olddevice; then
     if exist /system/csc; then
        omc_path=/system/csc
     else
        tryomc=$(find /system -type f -name "cscfeature.xml" | head -n1)
        if defined tryomc; then
           omc_path=$(dirname "$(dirname "$tryomc")")
        fi
     fi
fi

#Checking OMC PATH
if ! exist folder "$omc_path"; then abort "CANT GET VALID: OMC_PATH"; fi
echo2 "OMC_PATH: $omc_path"

#Getting OMC configs
mps=$(cat "$(find /sec_efs -type f -name "mps_code.dat" | head -n1)")
if undefined mps; then abort "CANT GET: COUNTRY CODE"; fi
echo2 "COUNTRY_CODE: $mps"

#Getting CSC PATH
csc_path=$(find "$omc_path" -type f -regex ".*/$mps/.*" -name "cscfeature.xml")
if ! exist "$csc_path"; then abort "CANT FIND: cscfeature.xml for $mps"; fi
csc_path=$(dirname "$csc_path")
echo2 "CSC_PATH: $csc_path"

#Checking omc-decoder.jar
#NOTE: $di_apex_list is a reg file that contains ALL mounted .apex files with Dynamic Installer
if exist "$omc_decoder"; then
    echo2 "OMC_DECODER: TRUE"
else
    echo2 "OMC_DECODER: FALSE"
fi
    
#cscfeature.xml locations
native_csc="$csc_path/cscfeature.xml"
   
#Making & Decrypting if needed cscfeature.xml
if exist "$omc_decoder"; then
    if ! run_program "$omc_decoder" "$native_csc" -o "$native_csc"; then echo2 "CANT DECODE: $native_csc"; fi
fi
content=$(string extract '<FeatureSet>' '</FeatureSet>' -f "$native_csc")
if defined content && exist file "$cscfeature"; then replace "$content" "$(cat "$cscfeature")" "$native_csc"; fi

#Remove enforcedeletepackage.txt enforceskippingpackages.txt
find /prism -type f -name enforcedeletepackage.txt -delete
find /prism -type f -name enforceskippingpackages.txt -delete
find /prism -type f -name "*.apk" -delete
find /prism -type f -name "*.qmg" -delete
find /omr -type f -name "*.qmg" -delete