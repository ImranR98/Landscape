#!/bin/bash
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
helm repo update
helm upgrade --install --namespace production traefik traefik/traefik --values <(cat "$HERE"/values.yaml | envsubst)
