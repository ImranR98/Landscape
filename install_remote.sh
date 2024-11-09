#!/bin/bash
set -e

HERE_M3U8="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"
source "$HERE_M3U8"/prep_env.sh

# Install Docker
ssh -A -t "$PROXY_SSH_STRING" bash -l <<-EOF
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
if [ -z "\$VERSION_CODENAME" ]; then
    VERSION_CODENAME="\$(cat /etc/lsb-release | grep CODENAME | awk -F= '{print \$2}')"
fi
echo \
    "deb [arch="\$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "\$VERSION_CODENAME")" stable" |
sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker \$USER
EOF

# Install FRPS
syncRemoteEnvFileIfUndefined "$PROXY_SSH_STRING" "$PROXY_HOME/frps/frps-tokens.txt" "$MAIN_NODE_HOSTNAME_LOWERCASE" "$(echo $RANDOM | sha512sum | awk '{print $1}')$(echo $RANDOM | sha512sum | awk '{print $1}')" "$HERE_M3U8"/files/frps-tokens.txt
generateComposeService frps 1000 > "$HERE_M3U8"/files/frps.service
scp "$HERE_M3U8"/files/.gitignore "$PROXY_SSH_STRING":~/frps/.gitignore
scp "$HERE_M3U8"/files/frps-tokens.txt "$PROXY_SSH_STRING":~/frps/frps-tokens.txt
scp "$HERE_M3U8"/files/frps.docker-compose.yaml "$PROXY_SSH_STRING":~/frps/frps.docker-compose.yaml
scp "$HERE_M3U8"/files/frps.service "$PROXY_SSH_STRING":~/frps/frps.service
scp "$HERE_M3U8"/files/frps.install.sh "$PROXY_SSH_STRING":~/frps/install.sh
scp "$HERE_M3U8"/files/openTCPPort.sh "$PROXY_SSH_STRING":~/frps/openTCPPort.sh
rm "$HERE_M3U8"/files/frps.service
rm "$HERE_M3U8"/files/frps-tokens.txt
ssh -A -t "$PROXY_SSH_STRING" "bash '$PROXY_HOME/frps/install.sh'"

# Install strelaysrv
generateComposeService strelaysrv 1000 > "$HERE_M3U8"/files/strelaysrv.service
cat "$HERE_M3U8"/files/strelaysrv.docker-compose.template.yaml | envsubst > "$HERE_M3U8"/files/strelaysrv.docker-compose.yaml
ssh -A -t "$PROXY_SSH_STRING" "mkdir -p '$PROXY_HOME/strelaysrv'"
scp "$HERE_M3U8"/files/.gitignore "$PROXY_SSH_STRING":~/strelaysrv/.gitignore
scp "$HERE_M3U8"/files/strelaysrv.install.sh "$PROXY_SSH_STRING":~/strelaysrv/install.sh
scp "$HERE_M3U8"/files/strelaysrv.service "$PROXY_SSH_STRING":~/strelaysrv/strelaysrv.service
scp "$HERE_M3U8"/files/strelaysrv.docker-compose.yaml "$PROXY_SSH_STRING":~/strelaysrv/strelaysrv.docker-compose.yaml
rm "$HERE_M3U8"/files/strelaysrv.service
rm "$HERE_M3U8"/files/strelaysrv.docker-compose.yaml
ssh -A -t "$PROXY_SSH_STRING" "bash '$PROXY_HOME/strelaysrv/install.sh'"

# Install Logtfy
cat "$HERE_M3U8"/files/logtfy.json | envsubst >"$HERE_M3U8"/files/logtfy.remote.temp.json
jq '.moduleCustomization |= map(select(.module == "ssh_logins" or .module == "port_checker"))
    | .moduleCustomization[] |= if .module == "ssh_logins" then . + {loggerArg: "ssh"} 
    else . + {loggerArg: "localhost 8888", enabled: true} end' "$HERE_M3U8"/files/logtfy.remote.temp.json | jq '.ntfyConfig.defaultConfig as $default | .ntfyConfig.fallbackConfig as $fallback | .ntfyConfig.defaultConfig = $fallback | .ntfyConfig.fallbackConfig = $default' >"$HERE_M3U8"/files/logtfy.remote.json
cat "$HERE_M3U8"/files/logtfy.remote.docker-compose.yaml | envsubst >"$HERE_M3U8"/files/logtfy.remote.docker-compose.temp.yaml
generateComposeService logtfy >"$HERE_M3U8"/files/logtfy.remote.service
ssh -A -t "$PROXY_SSH_STRING" "mkdir -p '$PROXY_HOME/logtfy'"
scp "$HERE_M3U8"/files/.gitignore "$PROXY_SSH_STRING":~/logtfy/.gitignore
scp "$HERE_M3U8"/files/logtfy.remote.json "$PROXY_SSH_STRING":~/logtfy/logtfy.json
scp "$HERE_M3U8"/files/logtfy.remote.service "$PROXY_SSH_STRING":~/logtfy/logtfy.service
scp "$HERE_M3U8"/files/logtfy.remote.docker-compose.temp.yaml "$PROXY_SSH_STRING":~/logtfy/logtfy.docker-compose.yaml
scp "$HERE_M3U8"/files/logtfy.remote.install.sh "$PROXY_SSH_STRING":~/logtfy/install.sh
rm "$HERE_M3U8"/files/logtfy.remote.json
rm "$HERE_M3U8"/files/logtfy.remote.temp.json
rm "$HERE_M3U8"/files/logtfy.remote.service
rm "$HERE_M3U8"/files/logtfy.remote.docker-compose.temp.yaml
ssh -A -t "$PROXY_SSH_STRING" "bash '$PROXY_HOME/logtfy/install.sh'"