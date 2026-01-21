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


LOG_WIDTH=80
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' 
BOLD='\033[1m'
DIM='\033[2m'

INDENT_STEP=2
BASE_INDENT=2


LOG_BEGIN() {
    local TITLE="$1"
    printf "%*s${YELLOW}-> %s${NC}\n\n" "$BASE_INDENT" "" "$TITLE"
}


LOG_END() {
    local i=0
    local indent

    echo
    for TITLE in "$@"; do
        indent=$((BASE_INDENT + (i * INDENT_STEP)))
        printf "%*s${GREEN}✔ %s${NC}\n" "$indent" "" "$TITLE"
        ((i++))
    done
    echo
}




# Display error TITLE and exit
ERROR_EXIT() {
    local TITLE="$1"

    printf "${RED}> %s${NC}\n" "$TITLE"
    exit
}



# Check if a command exists
COMMAND_EXISTS() {
    command -v "$1" >/dev/null 2>&1
}


# Get current timestamp in HH:MM:SS format
_TIMESTAMP() {
    date '+%H:%M:%S'
}


_GET_DURATION() {
    local start=$1
    local end=$2
    local dt=$((end - start))
    local ds=$((dt % 60))
    local dm=$(((dt / 60) % 60))
    local dh=$((dt / 3600))
    
    if [ $dh -gt 0 ]; then
        printf "%02d:%02d:%02d" $dh $dm $ds
    else
        printf "%02d:%02d" $dm $ds
    fi
}


# Print a divider line with specified character
_PRINT_DIVIDER() {
    local char="${1:--}"
    printf "${GRAY}%*s${NC}\n" "$LOG_WIDTH" "" | tr ' ' "$char"
}




LOG_INFO() {
    printf "    ${CYAN}· %s${NC}\n" "$*"
}


LOG_WARN() {
    printf "    ${YELLOW}! %s${NC}\n" "$*"
}



LOG() {
    local TITLE="$1"
    echo -e "$TITLE"
}


RUN_CMD() {
    local DESCRIPTION="$1"
    shift
    local COMMAND="$*"

    local tmp_log spin='-\|/' i=0 pid

    tmp_log=$(mktemp)


    printf "    ${BLUE}▶${NC} %s... " "$DESCRIPTION"

    eval "$COMMAND" >"$tmp_log" 2>&1 &
    pid=$!

    if IS_INTERACTIVE; then
        tput civis 2>/dev/null
        while kill -0 "$pid" 2>/dev/null; do
            i=$(( (i + 1) % 4 ))
            printf "\b${CYAN}%s${NC}" "${spin:$i:1}"
            sleep 0.1
        done
        tput cnorm 2>/dev/null
    fi

    wait "$pid"
    local exit_code=$?

    if (( exit_code == 0 )); then
        printf "\b${GREEN}[OK]${NC}\n"
        rm -f "$tmp_log"
    else
        printf "\b${RED}[FAIL]${NC}\n\n"

        printf "    ${RED}└─ ERROR OUTPUT:${NC}\n"
        _PRINT_DIVIDER "="
        sed 's/^/    | /' "$tmp_log"
        _PRINT_DIVIDER "="

        rm -f "$tmp_log"
        ERROR_EXIT "Failed during: $DESCRIPTION"
    fi
}



# Execute command silently
SILENT() {
    "$@" > /dev/null 2>&1
}


CONFIRM_ACTION() {
    local PROMPT="$1"
    local DEFAULT="${2:-false}"

    if IS_GITHUB_ACTIONS; then
        [[ "$DEFAULT" == "true" ]] && return 0 || return 1
    fi

    local suffix="[y/N]"
    [[ "$DEFAULT" == "true" ]] && suffix="[Y/n]"

    echo -ne "${MAGENTA}[?]${NC} $PROMPT $suffix: "
    read -r response
    [[ -z "$response" ]] && [[ "$DEFAULT" == "true" ]] && return 0

    case "${response,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}


_CHOICE() {
    local PROMPT="$1"; shift
    local options=("$@")
    local idx

    echo >&2
    printf "${BOLD}${WHITE}%s${NC}\n" "$PROMPT" >&2
    for i in "${!options[@]}"; do
        printf "  ${CYAN}[%d]${NC} %s\n" $((i+1)) "${options[$i]}" >&2
    done

    while true; do
        printf "${GREEN}>${NC} Select (1-${#options[@]}): " >&2
        read -r idx
        if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le ${#options[@]} ]; then
            echo "$idx"
            return 0
        fi
    done
}


_UPDATE_LOG() {
    local TITLE="$1"
    local END_FLAG="$2"

    printf "\r\e[2K${WHITE}%b${NC}" "$TITLE"

    if [[ "$END_FLAG" == "DONE" || "$END_FLAG" == "END" ]]; then
        echo ""
    fi
}

IS_INTERACTIVE() {
    [[ -t 1 && -t 2 ]] && ! IS_GITHUB_ACTIONS
}
