#!/bin/bash
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SSH_USER=$USER
SSH_HOST=staging.imranr.dev
SSH_STRING="$SSH_USER@$SSH_HOST"

jq '.moduleCustomization = [.moduleCustomization[] | select(.module == "ssh_logins") | .loggerArg = "ssh"]' "$HERE"/../logtfy.json > "$HERE"/files/logtfy.json

rsync -r "$HERE"/files/ "$SSH_STRING":~/logtfy/
ssh -A -t "$SSH_STRING" "bash '/home/$SSH_USER/logtfy/install.sh'"