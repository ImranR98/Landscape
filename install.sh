# TODO:
# - Manual update script instead of watchtower
# - mTLS
# - Generally go through and optimize everything, confirm parity with existing system
# - Plan and do migration

#!/bin/bash
set -e

HERE_LX1A="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE_LX1A"/prep_env.sh

# Install Docker
if [ -z "$(docker compose version 2>/dev/null || :)" ]; then
    sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo --overwrite &&
        sudo dnf -q install docker-ce docker-compose-plugin -y &&
        sudo systemctl enable --now -q docker && sleep 5 &&
        sudo systemctl is-active docker &&
        sudo usermod -aG docker $USER
fi

# Ensure state and other required dirs exist
grep -Eo '\$MAIN_PARENT_DIR[^:]+:' "$HERE_LX1A"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$MAIN_PARENT_DIR/$(echo $dir | tail -c +18)"
done
grep -Eo '\$STATE_DIR[^:]+:' "$HERE_LX1A"/landscape.docker-compose.yaml | awk -F: '{print $1}' | grep -E '/[^(/|.)]+$' | while read dir; do
    mkdir -p "$STATE_DIR/$(echo $dir | tail -c +12)"
done
mkdir -p "$STATE_DIR"/logtfy
mkdir -p "$STATE_DIR"/prometheus
mkdir -p "$STATE_DIR"/opencanary
mkdir -p "$STATE_DIR"/filebrowser
mkdir -p "$STATE_DIR"/plausible
mkdir -p "$STATE_DIR"/frpc

# Generate required config files
cat "$HERE_LX1A"/files/logtfy.json | envsubst >"$STATE_DIR"/logtfy/config.json
cat "$HERE_LX1A"/files/authelia.config.yaml | envsubst >"$STATE_DIR"/authelia/config/configuration.yml
echo "$AUTHELIA_USERS_DATABASE" >"$STATE_DIR"/authelia/config/users_database.yml
if [ ! -f "$STATE_DIR"/traefik/acme.json ]; then
    echo '{}' >"$STATE_DIR"/traefik/acme.json
fi
chmod 600 "$STATE_DIR"/traefik/acme.json
cat "$HERE_LX1A"/files/traefik.dynamic-configuration.yaml | envsubst >"$STATE_DIR"/traefik/dynamic-configuration.yaml
cat "$HERE_LX1A"/files/prometheus.yaml | envsubst >"$STATE_DIR"/prometheus/prometheus.yaml
cat "$HERE_LX1A"/files/crowdsec.acquis.yaml | envsubst >"$STATE_DIR"/crowdsec/acquis.yaml
cat "$HERE_LX1A"/files/crowdsec.notifications-http.yaml | envsubst >"$STATE_DIR"/crowdsec/notifications-http.yaml
cat "$HERE_LX1A"/files/crowdsec.profiles.yaml | envsubst >"$STATE_DIR"/crowdsec/profiles.yaml
cat "$HERE_LX1A"/files/opencanary.json | envsubst >"$STATE_DIR"/opencanary/opencanary.json
touch "$STATE_DIR"/filebrowser/filebrowser.db
cat "$HERE_LX1A"/files/filebrowser.json | envsubst >"$STATE_DIR"/filebrowser/filebrowser.json
cat "$HERE_LX1A"/files/ntfy.server.yml | envsubst >"$STATE_DIR"/ntfy/server.yml
cp "$HERE_LX1A"/files/immich.hwaccel.ml.yml "$STATE_DIR"/immich/hwaccel.ml.yml
cp "$HERE_LX1A"/files/immich.hwaccel.transcoding.yml "$STATE_DIR"/immich/hwaccel.transcoding.yml
cp "$HERE_LX1A"/files/plausible.logs.xml "$STATE_DIR"/plausible/logs.xml
cp "$HERE_LX1A"/files/plausible.ipv4-only.xml "$STATE_DIR"/plausible/ipv4-only.xml
cat "$HERE_LX1A"/files/mosquitto.conf | envsubst | sudo dd status=none of="$STATE_DIR"/mosquitto/config/mosquitto.conf
echo "$MOSQUITTO_PRIVATE_KEY" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/private_key.pem
echo "$MOSQUITTO_CERTIFICATE" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/certificate.pem
echo "$MOSQUITTO_CREDENTIALS" | sudo dd status=none of="$STATE_DIR"/mosquitto/config/password_file
if [ ! -f "$STATE_DIR"/traefik/mtls/cacert.pem ] || [ ! -f "$STATE_DIR"/traefik/mtls/cakey.pem ]; then
    openssl genrsa -out "$STATE_DIR"/traefik/mtls/cakey.pem 4096
    openssl req -new -x509 -key "$STATE_DIR"/traefik/mtls/cakey.pem -out "$STATE_DIR"/traefik/mtls/cacert.pem
fi
if [ ! -f "$STATE_DIR"/frpc/frpc.ini ]; then
    bash "$HERE_LX1A"/files/frpc.generate.sh
    mv "$HERE_LX1A"/files/frpc.ini "$STATE_DIR"/frpc
fi

# Generate compose file
cat "$HERE_LX1A"/landscape.docker-compose.yaml | envsubst >"$STATE_DIR"/landscape.docker-compose.yaml

# Generate compose service
generateComposeService landscape 1000 >"$STATE_DIR"/landscape.service
awk -v SCRIPT_DIR="$STATE_DIR" '{gsub("path_to_here", SCRIPT_DIR); print}' "$STATE_DIR"/landscape.service >"$STATE_DIR"/landscape.service.temp
awk -v MY_UID="$(id -u)" '{gsub("1000", MY_UID); print}' "$STATE_DIR"/landscape.service.temp >"$STATE_DIR"/landscape.service
rm "$STATE_DIR"/landscape.service.temp
sudo mv "$STATE_DIR"/landscape.service /etc/systemd/system/landscape.service

# If needed, start up HomeAssistant so it generates its config file, then modify it to add the http prop
if [ ! -f "$STATE_DIR"/homeassistant/configuration.yaml ] || [ -z "$(grep -Eo '^http' "$STATE_DIR"/homeassistant/configuration.yaml)" ]; then
    docker compose -p landscape -f "$STATE_DIR"/landscape.docker-compose.yaml up -d homeassistant
    echo "Waiting for HA config file to be generated..."
    while [ ! -f "$STATE_DIR"/homeassistant/configuration.yaml ]; do
        sleep 1
    done
    cat "$HERE_LX1A"/files/homeassistant.config.http.yaml | sudo dd status=none of="$STATE_DIR"/homeassistant/configuration.yaml oflag=append conv=notrunc
    docker compose -p landscape -f "$STATE_DIR"/landscape.docker-compose.yaml down homeassistant
fi

If no Crowdsec bouncer key has been defined, start Crowdsec, generate a key, and save it
if [ -z "$CROWDSEC_BOUNCER_KEY" ]; then
    docker compose -p landscape -f "$STATE_DIR"/landscape.docker-compose.yaml up -d crowdsec
    sleep 10 # Hopefully enough time for any initialization to occur
    docker exec crowdsec cscli bouncers remove crowdsecBouncer || :
    export CROWDSEC_BOUNCER_KEY="$(docker exec crowdsec cscli bouncers add crowdsecBouncer | head -3 | tail -1 | awk '{print $1}')"
    echo "export CROWDSEC_BOUNCER_KEY='$CROWDSEC_BOUNCER_KEY'" >>"$STATE_DIR"/generated.VARS.sh
    docker compose -p landscape -f "$STATE_DIR"/landscape.docker-compose.yaml down -d crowdsec
fi

# Re-generate the compose file to account for any env. var. changes
cat "$HERE_LX1A"/landscape.docker-compose.yaml | envsubst >"$STATE_DIR"/landscape.docker-compose.yaml

# Start the service
sudo systemctl daemon-reload
sudo systemctl enable landscape.service
sudo systemctl stop landscape.service || :
sleep 5
sudo systemctl start landscape.service
