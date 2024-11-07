#!/bin/bash
set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"/init_vars.sh

# Ensure state and other required dirs exist
grep -Eo '\$MAIN_PARENT_DIR[^:]+:' "$(here)"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$MAIN_PARENT_DIR/$(echo $dir | tail -c +18)"
done
grep -Eo '\$STATE_DIR[^:]+:' "$(here)"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$STATE_DIR/$(echo $dir | tail -c +12)"
done
mkdir -p "$STATE_DIR"/logtfy
mkdir -p "$STATE_DIR"/prometheus
mkdir -p "$STATE_DIR"/opencanary
mkdir -p "$STATE_DIR"/filebrowser

# Generate required config files
cat "$(here)"/files/logtfy.json | envsubst >"$STATE_DIR"/logtfy/config.json
cat "$(here)"/files/authelia.config.yaml | envsubst >"$STATE_DIR"/authelia/config/configuration.yaml
echo "$$AUTHELIA_USERS_DATABASE" >"$STATE_DIR"/authelia/config/users_database.yaml
if [ ! -f "$STATE_DIR"/traefik/acme.json ]; then
    echo '[]' >"$STATE_DIR"/traefik/acme.json
fi
cat "$(here)"/files/traefik.dynamic-configuration.yaml | envsubst >"$STATE_DIR"/traefik/dynamic-configuration.yaml
cat "$(here)"/files/prometheus.yaml | envsubst >"$STATE_DIR"/prometheus/prometheus.yaml
cat "$(here)"/files/crowdsec.acquis.yaml | envsubst >"$STATE_DIR"/crowdsec/acquis.yaml
cat "$(here)"/files/crowdsec.notifications-http.yaml | envsubst >"$STATE_DIR"/crowdsec/notifications-http.yaml
cat "$(here)"/files/crowdsec.profiles.yaml | envsubst >"$STATE_DIR"/crowdsec/profiles.yaml
cat "$(here)"/files/opencanary.json | envsubst >"$STATE_DIR"/opencanary/opencanary.json
touch "$STATE_DIR"/filebrowser/filebrowser.db
cat "$(here)"/files/filebrowser.json | envsubst >"$STATE_DIR"/filebrowser/filebrowser.json
cat "$(here)"/files/ntfy.server.yml | envsubst >"$STATE_DIR"/ntfy/server.yml
cp "$(here)"/files/hwaccel.ml.yml "$STATE_DIR"/immich
cp "$(here)"/files/hwaccel.transcoding.yml "$STATE_DIR"/immich
cat "$(here)"/files/mosquitto.conf | envsubst | sudo dd status=none of="$STATE_DIR"/mosquitto/config/mosquitto.conf
echo "$MOSQUITTO_PRIVATE_KEY" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/private_key.pem
echo "$MOSQUITTO_CERTIFICATE" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/certificate.pem
echo "$MOSQUITTO_CREDENTIALS" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/password_file
if [ ! -f "$STATE_DIR"/traefik/mtls/cacert.pem ] || [ ! -f "$STATE_DIR"/traefik/mtls/cakey.pem ]; then
    openssl genrsa -out "$STATE_DIR"/traefik/mtls/cakey.pem 4096
    openssl req -new -x509 -key "$STATE_DIR"/traefik/mtls/cakey.pem -out "$STATE_DIR"/traefik/mtls/cacert.pem
fi
