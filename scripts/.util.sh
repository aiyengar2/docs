#!/bin/bash
set -e

source $(dirname $0)/.repo.sh

RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
RESET="\033[0m"

EXIT_CODE=0
error() {
    echo -e "${RED}ERROR:${RESET} $1" >&2
    EXIT_CODE=1
}

fatal() {
    echo -e "${RED}FATAL:${RESET} $1" >&2
    exit 1  # Immediate exit
}

warning() {
    echo -e "${YELLOW}WARNING:${RESET} $1"
}

info() {
    echo -e "${BLUE}INFO:${RESET} $1"
}

defer_exit() {
    if [[ $EXIT_CODE -eq 0 ]]; then
        return
    fi
    exit $EXIT_CODE
}

init() {    
    trap defer_exit EXIT  # Ensure defer_exit is called at the end unless the script exits earlier

    for command in "$@"; do
        if ! command -v "$command" >/dev/null 2>&1; then
            error "Please install '$command' before running make."
            exit 1
        fi
    done
}

# Move script to root of repository and check dependencies
cd $(dirname $0)/..
init "${DEPENDENCIES[@]}"