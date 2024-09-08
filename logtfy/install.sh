#!/bin/bash
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE"/../helpers.sh

docker pull imranrdev/logtfy
docker run --rm imranrdev/logtfy k8s >"$HERE"/prepLogtfy.sh
docker run --rm imranrdev/logtfy role >"$HERE"/role.yaml
if [ -d "$HERE"/logtfy.json ]; then
    rmdir "$HERE"/logtfy.json
fi
bash "$HERE"/prepLogtfy.sh production
echo "KUBE_API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')" >"$HERE"/.env
generateComposeService logtfy 1000 | awk -v SCRIPT_DIR="$HERE" '{gsub("path_to_here", SCRIPT_DIR); print}' | sudo tee /etc/systemd/system/logtfy.service.temp
awk -v MY_UID="$UID" '{gsub("User=1000", MY_UID); print}' /etc/systemd/system/logtfy.service.temp | sudo tee /etc/systemd/system/logtfy.service
sudo rm /etc/systemd/system/logtfy.service.temp
cat "$HERE"/logtfy.template.json | envsubst >"$HERE"/logtfy.json
cat "$HERE"/logtfy.docker-compose.template.yaml | envsubst >"$HERE"/logtfy.docker-compose.yaml
sudo systemctl enable logtfy.service
sudo systemctl restart logtfy.service
