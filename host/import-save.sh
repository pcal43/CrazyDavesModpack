#!/bin/bash

set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SAVE_DIR="${SCRIPT_DIR}/saves/CrazyDavesShipwreck"
mkdir -p "${SCRIPT_DIR}/saves"
mkdir "${SAVE_DIR}"
unzip "${1}" -d "${SAVE_DIR}"

