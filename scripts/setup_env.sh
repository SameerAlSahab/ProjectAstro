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


VALIDATE_DEVICE_VARS() {
    local missing_vars=()
    local error_messages=(
        ["CODENAME"]="A specific device codename must be defined."
        ["MODEL"]="The main firmware model identifier (\$MODEL)."
        ["STOCK_MODEL"]="The target stock firmware model identifier (\$STOCK_MODEL)."
        ["FILESYSTEM"]="The desired target filesystem type (\$FILESYSTEM) must needed for repack images"
    )

    for var_name in "${!error_messages[@]}"; do
        if [[ -z "${!var_name}" ]]; then
            missing_vars+=("$var_name:${error_messages[$var_name]}")
        fi
    done

    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        LOG "Cannot continue. Missing required environment variables:"
        for entry in "${missing_vars[@]}"; do
            IFS=':' read -r var_name error_msg <<< "$entry"
            echo -e "  ${RED}✗${NC} ${var_name}: ${error_msg}"
        done
        echo
        ERROR_EXIT "Critical configuration parameters are not given. Aborting build environment."
        return 1
    fi
    
    return 0
}


SETUP_DEVICE_ENV() {
    LOG_BEGIN "Setting up Device environment"


    if ! VALIDATE_DEVICE_VARS; then
        LOG_WARN "Failed to validate device environment variables."
        return 1
    fi
    
    # Only export variables that are actually set
    local vars_to_export=(CODENAME MODEL STOCK_MODEL VNDK FILESYSTEM PLATFORM EXTRA_MODEL)
    for var in "${vars_to_export[@]}"; do
        if [[ -n "${!var}" ]]; then
            export "$var"
        fi
    done

    echo -e "  ${BLUE}DEVICE INFO:${NC}"
    echo -e "    -> Device:               ${BOLD}${MODEL_NAME}${NC}"
    echo -e "    -> Codename:             ${BOLD}${CODENAME}${NC}"
    echo -e "    -> Stock Model:          ${BOLD}${STOCK_MODEL}${NC}"

    echo -e ""
    echo -e "  ${BLUE}BUILD PARAMETERS:${NC}"
    echo -e "    -> Source Model:         ${BOLD}${MODEL}${NC}"
    echo -e "    -> Extra Model:          ${EXTRA_MODEL:-[None]}"
    echo -e "    -> Target Filesystem:    ${FILESYSTEM}"
    echo -e "    -> VNDK Version:         ${VNDK:-[Not given]}"
    echo -e "    -> Debug Mode:           ${DEBUG_BUILD}"
    
    # TODO : Add more if possible in future.
    echo -e ""

    # Skip user input in CI environments
    if ! IS_GITHUB_ACTIONS; then
        echo -e "Imported config. Press ${GREEN}ENTER${NC} to proceed with the build, or ${RED}Ctrl+C${NC} to abort."
        read -r user_input
    else
        LOG_INFO "CI environment detected, proceeding with build automatically."
    fi

    INIT_BUILD_ENV
}


# Format: "DebianPkgName|ArchPkgName|PrettyName|Critical(true/false)"
dependencies_config=(
    "openjdk-17-jdk|jdk17-openjdk|Java 17+ (Java is required for APK/JAR patching)|true"
    "python3|python|Python 3 (For Python modules)|true"
    "xmlstarlet|xmlstarlet|XML manipulation (Editing xml files)|true"
    "lz4|lz4|LZ4 compression (for decompression)|true"
    "p7zip-full|p7zip|7-Zip (For extraction)|true"
    "bc|bc|BC calculator (Size calculations)|true"
    "zip|zip|Zip utility (For zipping)|true"
    "e2fsprogs|e2fsprogs|EXT4 filesystem tools|true"
    "attr|attr|xattr (SELinux configs)|true"
    "zipalign|android-sdk-build-tools|Zipalign (APKs alignment)|true"
    "f2fs-tools|f2fs-tools|(Tools for F2FS)|true" 
	"nodejs|nodejs|Node.js (JS-based utilities)|true"
	"jq|jq|(For JQ)|true"
	"ffmpeg|ffmpeg|(Video conversion)|true"
	"webp|libwebp-utils|(WEBP conversion)|true"
	"acl|acl|grants regular user permissions|true"
)

DISTRO_TYPE=""

# Detect the Linux distribution type
# Reference: https://www.freedesktop.org/software/systemd/man/os-release.html
GET_DISTRO_TYPE() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
            echo "arch"
            return
        elif [[ "$ID" == "debian" || "$ID_LIKE" == "debian" || "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu" ]]; then
            echo "debian"
            return
        fi
    fi

    if command -v pacman &>/dev/null; then
        echo "arch"
    elif command -v dpkg &>/dev/null; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Check and install all required dependencies
CHECK_ALL_DEPENDENCIES() {

if find "$PREBUILTS" -type f ! -executable | grep -q .; then
    find "$PREBUILTS" -type f ! -executable -exec chmod +x {} + 2>/dev/null || true
fi


    DISTRO_TYPE=$(GET_DISTRO_TYPE)


    if [[ "$DISTRO_TYPE" == "unknown" ]]; then
        ERROR_EXIT "Unsupported operating system. Cannot auto-install dependencies."
    fi

    LOG_BEGIN "System is $DISTRO_TYPE. Verifying dependencies..."

    local all_installed=true
    local pkg_string pretty_name deb_pkg arch_pkg pkg_name critical

    if [[ "$DISTRO_TYPE" == "debian" ]]; then
        SUDO apt-get update &>/dev/null
    fi

    for pkg_string in "${dependencies_config[@]}"; do
        IFS='|' read -r deb_pkg arch_pkg pretty_name critical <<< "$pkg_string"

        if [[ "$DISTRO_TYPE" == "arch" ]]; then
            pkg_name="$arch_pkg"
        else
            pkg_name="$deb_pkg"
        fi

        if ! CHECK_DEPENDENCY "$pkg_name" "$pretty_name" "$critical"; then
            if [[ "$critical" == "true" ]]; then
                all_installed=false
            fi
        fi
    done

    if "$all_installed"; then
        LOG_END "All dependencies are installed and ready."
    else
        ERROR_EXIT "Critical dependencies failed to install. Check your internet or package manager."
    fi
}


CHECK_DEPENDENCY() {
    local pkg_name="$1"
    local pretty_name="${2:-$pkg_name}"
    local critical="${3:-false}"


    if [[ "$DISTRO_TYPE" == "arch" ]]; then
        pacman -Q "$pkg_name" &>/dev/null && return 0
    else
        dpkg -s "$pkg_name" &>/dev/null && return 0
    fi

    LOG_BEGIN "Installing dependency: $pretty_name..."
    local install_success=false

    # Arch
    if [[ "$DISTRO_TYPE" == "arch" ]]; then
        # Try pacman first (Official Repos)
        if SUDO pacman -S --noconfirm --needed "$pkg_name" &>/dev/null; then
            install_success=true
        else
            # Try AUR helper if pacman fails
            if ! command -v yay &>/dev/null; then
                SUDO pacman -S --noconfirm yay
            fi

            if SUDO -u "$(logname)" yay -S --noconfirm --needed --answerclean None --answerdiff None "$pkg_name" &>/dev/null; then
                install_success=true
            fi
        fi

    # Debian/Ubuntu
    elif [[ "$DISTRO_TYPE" == "debian" ]]; then
        if SUDO apt-get install -y "$pkg_name" &>/dev/null; then
            install_success=true
        fi
    fi


    if $install_success; then
        return 0
    else
        if [[ "$critical" == "true" ]]; then
            ERROR_EXIT "Failed to install required dependency: $pretty_name ($pkg_name)"
        else
            LOG_WARN "Failed to install optional dependency: $pretty_name"
            return 1
        fi
    fi
}


SUDO() {
    # Already root 
    if [[ $EUID -eq 0 ]]; then
        "$@"
        return
    fi

    # Check if sudo auth is cached
    if ! sudo -n true 2>/dev/null; then
        echo
        LOG_INFO "Root access is required for this operation."
		echo

        # Ask once
        sudo -v || {
            ERROR_EXIT "Sudo authentication failed. Aborting."
        }
    fi

    # Run command with sudo
    sudo "$@"
}

