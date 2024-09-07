function contains() {
    local item="$1"
    shift
    local arr=("$@")

    for element in "${arr[@]}"; do
        if [[ "$element" == "$item" ]]; then
            return 0
        fi
    done

    return 1
}

function rsyncWithChownContent() {
    ORIGIN="$1"
    if [ ! -d "$ORIGIN" ]; then
        echo "No/Invalid origin directory!" >&2
        exit 1
    fi
    DESTINATION="$2"
    if [ ! -d "$DESTINATION" ]; then
        echo "No/Invalid destination directory!" >&2
        exit 1
    fi
    OWNER="$3"
    GROUP="$4"
    if [ -z "$OWNER" ]; then
        OWNER=1000
    fi
    if [ -z "$GROUP" ]; then
        GROUP=1000
    fi
    mkdir -p "$DESTINATION"
    sudo rsync -ar "$ORIGIN"/ "$DESTINATION"/
    sudo chown "$OWNER" -R "$DESTINATION"/*
    sudo chgrp "$GROUP" -R "$DESTINATION"/*
}

function syncRemoteEnvFileIfUndefined() {
    # Given an env file on a remote server (any file where each line is '<varname>=<varvalue>'),
    # If the file already defines a given var, don't change it,
    # But if not, update it with a given value
    # Then sync (replace) a given local env file with the remote one
    SSH_STRING="$1"
    PATH_ON_REMOTE="$2"
    ENV_VAR_NAME="$3"
    VALUE_IF_UNDEFINED="$4"
    LOCAL_ENV_FILE="$5"

    ssh "$SSH_STRING" "mkdir -p "$(dirname "$PATH_ON_REMOTE")""
    FILE_CONTENT="$(ssh "$SSH_STRING" "cat '$PATH_ON_REMOTE' 2>/dev/null || :")"
    VAR_VAL="$((echo "$FILE_CONTENT" | grep -E "^$ENV_VAR_NAME=") || :)"
    if [ -z "$VAR_VAL" ]; then
        VAR_VAL="$ENV_VAR_NAME=$VALUE_IF_UNDEFINED"
        ssh "$SSH_STRING" "echo '$VAR_VAL' >> '$PATH_ON_REMOTE'"
    fi

    scp "$SSH_STRING":"$PATH_ON_REMOTE" "$LOCAL_ENV_FILE"
}

pullComposeImages() {
    COMPOSE_FILE="$1"
    grep '    image: ' "$COMPOSE_FILE" | awk '{print $NF}' | while read item; do
        docker pull "$item"
    done
    echo "NOTE: This script assumes all images in "$(dirname "$COMPOSE_FILE")" are tagged with a non version-specific tag (like 'latest')."
}