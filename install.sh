#!/bin/bash
set -e

source ""$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)""/init_vars.sh

generateComposeService landscape 1000 > "$(here)"/files/landscape.service
awk -v SCRIPT_DIR="$HERE" '{gsub("path_to_here", SCRIPT_DIR); print}' "$HERE"/files/landscape.service | sudo tee /etc/systemd/system/landscape.service.temp
awk -v MY_UID="$(id -u)" '{gsub("1000", MY_UID); print}' /etc/systemd/system/landscape.service.temp | sudo tee /etc/systemd/system/landscape.service
sudo systemctl daemon-reload
sudo systemctl enable landscape.service
sudo systemctl stop landscape.service || :
sleep 5
sudo systemctl start landscape.service