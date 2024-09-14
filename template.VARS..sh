#!/bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export MY_UID="$UID" # For some reason, using $UID directly in yaml files (via envsubst) causes errors but this weirdly fixes it
export MAIN_NODE_HOSTNAME="controlplane"
export PROXY_NODE_HOSTNAME="proxy"
export MAIN_NODE_HOSTNAME_LOWERCASE="${MAIN_NODE_HOSTNAME,,}"
export PROXY_NODE_HOSTNAME_LOWERCASE="${PROXY_NODE_HOSTNAME,,}"
export STATE_DIR="$HERE/state"
export MAIN_PARENT_DIR="$HERE/mock-data"
export ADMIN_PUBLIC_SSH_KEY="ssh-ed25519 abcdefg admin@home"

export TRAEFIK_TRUSTED_IP_RANGE="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -1)"

export SERVICES_DOMAIN="staging.example.org"
export SERVICES_TOP_DOMAIN="example.org"
export SERVICES_TLS_NAME="$(echo "$SERVICES_TOP_DOMAIN" | sed 's/\./-/g')"

export PROXY_USER="admin"
export PROXY_HOST="staging.example.org"
export PROXY_SSH_STRING="$PROXY_USER"@"$PROXY_HOST"
export PROXY_HOME="/home/$PROXY_USER"
if [ "$PROXY_USER" = root ]; then
    export PROXY_HOME="/root"
fi

export DOMAIN_OWNER_EMAIL="contact@example.org"

export CLOUDFLARE_TOKEN="token_here"

export NTFY_SERVICE_USER_TOKEN="token_here" # Generated through Ntfy CLI after initial setup

export AUTHELIA_USERS_DATABASE="users:
      admin:
        disabled: false
        displayname: \"Admin\"
        password: \"\$argon2id\$v=19\$m=65536,t=3,p=abc\" # yamllint disable-line rule:line-length
        email: contact@$SERVICES_TOP_DOMAIN
        groups:
          - admins" # docker run -it authelia/authelia:latest authelia crypto hash generate argon2
export AUTHELIA_DB_ENCRYPTION_KEY="abc" # echo $RAND | sha256sum | awk '{print $1}'
export AUTHELIA_DB_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'
export AUTHELIA_REDIS_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'
export AUTHELIA_SUBDOMAIN="auth.staging"
export AUTHELIA_TOP_DOMAIN="$SERVICES_TOP_DOMAIN"
export AUTHELIA_OIDC_HMAC_SECRET="abc" # echo $RAND | sha256sum | awk '{print $1}'
export AUTHELIA_JWKS_KEY="-----BEGIN PRIVATE KEY-----
              abc
              -----END PRIVATE KEY-----" #openssl genrsa -out private.pem 2048 # openssl rsa -in private.pem -outform PEM -pubout -out public.pem
export AUTHELIA_IMMICH_CLIENT_SECRET='$pbkdf2-sha512$abc' # docker run authelia/authelia:latest authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986

export CROWDSEC_BOUNCER_KEY="abc" # echo $RAND | sha256sum | awk '{print $1}'
export CROWDSEC_LAPI_SECRET="abc" # echo $RAND | sha256sum | awk '{print $1}'
export CROWDSEC_DB_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'

export IMMICH_OAUTH_CLIENT_SECRET="abc" # echo $RAND | sha256sum | awk '{print $1}'
export IMMICH_DB_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'

export OPENCANARY_NTFY_OFFICIAL_TOPIC="abc123"

export MONEROD_RPC_LOGIN="admin:abc"

export MOSQUITTO_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
    abc
    -----END PRIVATE KEY-----" # openssl req  -nodes -new -x509  -keyout private_key.pem -out certificate.pem -subj "/C=CA/ST=Toronto/L=Toronto/O=$SERVICES_TOP_DOMAIN/OU=Main/CN=$SERVICES_TOP_DOMAIN"
export MOSQUITTO_CERTIFICATE="-----BEGIN CERTIFICATE-----
    abc
    -----END CERTIFICATE-----"
export MOSQUITTO_CREDENTIALS='admin:abc'

export NEXTCLOUD_DB_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'
export NEXTCLOUD_ADMIN_USER="admin"
export NEXTCLOUD_ADMIN_PASSWORD="abc"

export PLAUSIBLE_DB_PASSWORD="abc" # echo $RAND | sha256sum | awk '{print $1}'
export PLAUSIBLE_SECRET_KEY="abc" # openssl rand -base64 48
export PLAUSIBLE_TOTP_VAULT_KEY="abc" # openssl rand -base64 32

export STRELAYSRV_PROVIDED_BY_TEXT="example.org"