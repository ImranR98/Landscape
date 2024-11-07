#!/bin/bash
set -e

HERE_LX1A="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"
source "$HERE_LX1A"/init_vars.sh

cat "$HERE_LX1A"/landscape.docker-compose.yaml | envsubst > "$HERE_LX1A"/files/landscape.docker-compose.yaml

generateComposeService landscape 1000 > "$HERE_LX1A"/files/landscape.service
awk -v SCRIPT_DIR="$HERE_LX1A/files" '{gsub("path_to_here", SCRIPT_DIR); print}' "$HERE_LX1A"/files/landscape.service > "$HERE_LX1A"/files/landscape.service.temp
awk -v MY_UID="$(id -u)" '{gsub("1000", MY_UID); print}' "$HERE_LX1A"/files/landscape.service.temp > "$HERE_LX1A"/files/landscape.service
rm "$HERE_LX1A"/files/landscape.service.temp

sudo mv "$HERE_LX1A"/files/landscape.service /etc/systemd/system/landscape.service
sudo systemctl daemon-reload
sudo systemctl enable landscape.service
sudo systemctl stop landscape.service || :
sleep 5
sudo systemctl start landscape.service