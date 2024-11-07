HERE_L3D9="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"

source "$HERE_L3D9"/helpers.sh
if [ -f "$HERE_L3D9"/VARS.production.sh ]; then
    source "$HERE_L3D9"/VARS.production.sh
elif [ -f "$HERE_L3D9"/VARS.staging.sh ]; then
    source "$HERE_L3D9"/VARS.staging.sh
elif [ -f "$HERE_L3D9"/VARS.sh ]; then
    source "$HERE_L3D9"/VARS.sh
else
    echo "No VARS.sh file found!" >&2
    exit 1
fi
source "$HERE_L3D9"/fixed.VARS.sh