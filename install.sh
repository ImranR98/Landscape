#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"/init_vars.sh

cat "$(here)"/landscape.docker-compose.yaml | envsubst > "$(here)"/files/landscape.docker-compose.yaml

generateComposeService landscape 1000 > "$(here)"/files/landscape.service
awk -v SCRIPT_DIR="$(here)/files" '{gsub("path_to_here", SCRIPT_DIR); print}' "$(here)"/files/landscape.service > "$(here)"/files/landscape.service.temp
awk -v MY_UID="$(id -u)" '{gsub("1000", MY_UID); print}' "$(here)"/files/landscape.service.temp > "$(here)"/files/landscape.service
rm "$(here)"/files/landscape.service.temp

sudo mv "$(here)"/files/landscape.service /etc/systemd/system/landscape.service
sudo systemctl daemon-reload
sudo systemctl enable landscape.service
sudo systemctl stop landscape.service || :
sleep 5
sudo systemctl start landscape.service