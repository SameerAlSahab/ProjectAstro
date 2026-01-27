#!/usr/bin/env bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#


MANIFEST="$WORKSPACE/vendor/etc/vintf/manifest.xml"

if grep -q "vendor.samsung.hardware.biometrics.face" "$MANIFEST" && grep -q "<version>2.0</version>" "$MANIFEST"; then

    if GET_FEATURE SOURCE_HAVE_LEGACY_FACE_HAL; then
        if GET_FEATURE DEVICE_HAVE_LEGACY_FACE_HAL; then
            LOG_INFO "Ignoring biometrics patch."
        else
            LOG_WARN "Missing patches."
        fi
    else

        if GET_FEATURE DEVICE_HAVE_LEGACY_FACE_HAL; then
            LOG "Removing old face unlock 2.0 HALs..."
            REMOVE "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@2.0-service"
            REMOVE "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@2.0-service.rc"

            LOG "Adding new working 3.0 HALs..."
            ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service"
            ADD_FROM_FW "dm3q" "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so"
            ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so"
            ADD_FROM_FW "dm3q" "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc"

            ADD_CONTEXT "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc" "vendor_configs_file"
            ADD_CONTEXT "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so" "vendor_file"
            ADD_CONTEXT "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so" "vendor_file"
            ADD_CONTEXT "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service" "hal_face_default_exec"

            if ! grep -q "<version>3.0</version>" "$MANIFEST"; then
                sed -i '/<version>2.0<\/version>/i \        <version>3.0</version>' "$MANIFEST"
                sed -i 's|@2.0::ISehBiometricsFace/default|@3.0::ISehBiometricsFace/default|g' "$MANIFEST"
            fi
        else
            LOG_INFO "Device already has latest hals. No patch required."
        fi
    fi
fi
