#!/bin/bash
#
#  Copyright (c) 2025 Sameer Al Sahab
#  Licensed under the MIT License. See LICENSE file for details.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#


if ! GET_FEATURE DEVICE_HAVE_ESIM_SUPPORT; then

LOG_BEGIN "Device not support esim , Removing blobs.."

NUKE_BLOAT "EsimKeyString" "EuiccService"

REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml"
REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.euicc.xml"
REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml"
REMOVE "system" "etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml"

FF "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH" ""

else

LOG_BEGIN "Adding esim blobs.."

    ADD_FROM_FW "pa3q" "system" "priv-app/EsimKeyString"
    ADD_FROM_FW "pa3q" "system" "priv-app/EuiccService"

    ADD_FROM_FW "pa3q" "system" "etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml"
    ADD_FROM_FW "pa3q" "system" "etc/permissions/privapp-permissions-com.samsung.euicc.xml"

    ADD_FROM_FW "pa3q" "system" "etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml"
    ADD_FROM_FW "pa3q" "system" "etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml"

    FF_IF_DIFF "stock" "COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH"

fi
