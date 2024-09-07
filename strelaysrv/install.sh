#!/bin/bash
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE"/../helpers.sh

SSH_USER=$USER
SSH_HOST=staging.imranr.dev
SSH_STRING="$SSH_USER@$SSH_HOST"

generateComposeService strelaysrv > "$HERE"/files/strelaysrv.service
rsync -r "$HERE"/files/ "$SSH_STRING":~/strelaysrv/
ssh -A -t "$SSH_STRING" "bash '/home/$SSH_USER/strelaysrv/install.sh'"