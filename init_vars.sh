here() { cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd; }
export -f here
source "$(here)"/helpers.sh
if [ -f "$(here)"/VARS.production.sh ]; then
    source "$(here)"/VARS.production.sh
elif [ -f "$(here)"/VARS.staging.sh ]; then
    source "$(here)"/VARS.staging.sh
elif [ -f "$(here)"/VARS.sh ]; then
    source "$(here)"/VARS.sh
else
    echo "No VARS.sh file found!" >&2
    exit 1
fi
source "$(here)"/fixed.VARS.sh