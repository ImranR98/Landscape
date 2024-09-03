#!/bin/bash -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
helm install --namespace production nextcloud nextcloud/nextcloud -f "$HERE"/values.yaml