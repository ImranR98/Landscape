#!/bin/bash
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HELPERS_PATH"

bash "$HERE"/install.sh
deletePodsByGrep loki-gateway