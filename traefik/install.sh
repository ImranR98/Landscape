#!/bin/bash -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
LOCAL_IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -1)"
sed -i "s/192.168.8.154/$LOCAL_IP/" "$HERE"/traefik/values.yaml
helm install --namespace production traefik traefik/traefik --values "$HERE"/values.yaml
