#!/bin/bash
set -e

HERE_M0F4="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"
source "$HERE_M0F4"/init_vars.sh

# Ensure state and other required dirs exist
grep -Eo '\$MAIN_PARENT_DIR[^:]+:' "$HERE_M0F4"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$MAIN_PARENT_DIR/$(echo $dir | tail -c +18)"
done
grep -Eo '\$STATE_DIR[^:]+:' "$HERE_M0F4"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$STATE_DIR/$(echo $dir | tail -c +12)"
done
mkdir -p "$STATE_DIR"/logtfy
mkdir -p "$STATE_DIR"/prometheus
mkdir -p "$STATE_DIR"/opencanary
mkdir -p "$STATE_DIR"/filebrowser
mkdir -p "$STATE_DIR"/plausible

# Generate required config files
cat "$HERE_M0F4"/files/logtfy.json | envsubst >"$STATE_DIR"/logtfy/config.json
cat "$HERE_M0F4"/files/authelia.config.yaml | envsubst >"$STATE_DIR"/authelia/config/configuration.yml
echo "$AUTHELIA_USERS_DATABASE" >"$STATE_DIR"/authelia/config/users_database.yml
if [ ! -f "$STATE_DIR"/traefik/acme.json ]; then
    echo '{}' >"$STATE_DIR"/traefik/acme.json
fi
chmod 600 "$STATE_DIR"/traefik/acme.json
cat "$HERE_M0F4"/files/traefik.dynamic-configuration.yaml | envsubst >"$STATE_DIR"/traefik/dynamic-configuration.yaml
cat "$HERE_M0F4"/files/prometheus.yaml | envsubst >"$STATE_DIR"/prometheus/prometheus.yaml
cat "$HERE_M0F4"/files/crowdsec.acquis.yaml | envsubst >"$STATE_DIR"/crowdsec/acquis.yaml
cat "$HERE_M0F4"/files/crowdsec.notifications-http.yaml | envsubst >"$STATE_DIR"/crowdsec/notifications-http.yaml
cat "$HERE_M0F4"/files/crowdsec.profiles.yaml | envsubst >"$STATE_DIR"/crowdsec/profiles.yaml
cat "$HERE_M0F4"/files/opencanary.json | envsubst >"$STATE_DIR"/opencanary/opencanary.json
touch "$STATE_DIR"/filebrowser/filebrowser.db
cat "$HERE_M0F4"/files/filebrowser.json | envsubst >"$STATE_DIR"/filebrowser/filebrowser.json
cat "$HERE_M0F4"/files/ntfy.server.yml | envsubst >"$STATE_DIR"/ntfy/server.yml
cp "$HERE_M0F4"/files/immich.hwaccel.ml.yml "$STATE_DIR"/immich/hwaccel.ml.yml
cp "$HERE_M0F4"/files/immich.hwaccel.transcoding.yml "$STATE_DIR"/immich/hwaccel.transcoding.yml
cp "$HERE_M0F4"/files/plausible.logs.xml "$STATE_DIR"/plausible/logs.xml
cp "$HERE_M0F4"/files/plausible.ipv4-only.xml "$STATE_DIR"/plausible/ipv4-only.xml
cat "$HERE_M0F4"/files/mosquitto.conf | envsubst | sudo dd status=none of="$STATE_DIR"/mosquitto/config/mosquitto.conf
echo "$MOSQUITTO_PRIVATE_KEY" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/private_key.pem
echo "$MOSQUITTO_CERTIFICATE" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/certificate.pem
echo "$MOSQUITTO_CREDENTIALS" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/password_file
if [ ! -f "$STATE_DIR"/traefik/mtls/cacert.pem ] || [ ! -f "$STATE_DIR"/traefik/mtls/cakey.pem ]; then
    openssl genrsa -out "$STATE_DIR"/traefik/mtls/cakey.pem 4096
    openssl req -new -x509 -key "$STATE_DIR"/traefik/mtls/cakey.pem -out "$STATE_DIR"/traefik/mtls/cacert.pem
fi
bash "$HERE_M0F4"/files/frpc.generate.sh