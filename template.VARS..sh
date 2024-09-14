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

export NTFY_SERVICE_USER_TOKEN="token_here"

export AUTHELIA_ADMIN_DISPLAYNAME="Admin"
export AUTHELIA_ADMIN_PASSWORD_HASH='$argon2id$v=19$m=65536,t=3,p=abc'
export AUTHELIA_ADMIN_EMAIL="contact@example.org"
export AUTHELIA_DB_ENCRYPTION_KEY="abc"
export AUTHELIA_DB_PASSWORD="abc"
export AUTHELIA_REDIS_PASSWORD="abc"
export AUTHELIA_SUBDOMAIN="auth.staging"
export AUTHELIA_TOP_DOMAIN="$SERVICES_TOP_DOMAIN"
export AUTHELIA_OIDC_HMAC_SECRET="abc"
export AUTHELIA_JWKS_KEY="-----BEGIN PRIVATE KEY-----
              abc
              -----END PRIVATE KEY-----"
export AUTHELIA_IMMICH_CLIENT_SECRET='$pbkdf2-sha512$abc'

export CROWDSEC_BOUNCER_KEY="abc"
export CROWDSEC_LAPI_SECRET="abc"

export IMMICH_OAUTH_CLIENT_SECRET="abc"
export IMMICH_DB_PASSWORD="abc"

export MONEROD_RPC_LOGIN="admin:abc"

export MOSQUITTO_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
    abc
    -----END PRIVATE KEY-----"
export MOSQUITTO_CERTIFICATE="-----BEGIN CERTIFICATE-----
    abc
    -----END CERTIFICATE-----"
export MOSQUITTO_CREDENTIALS='admin:abc'

export NEXTCLOUD_DB_PASSWORD="abc"
export NEXTCLOUD_ADMIN_USER="admin"
export NEXTCLOUD_ADMIN_PASSWORD="abc"

export PLAUSIBLE_DB_PASSWORD="abc"
export PLAUSIBLE_SECRET_KEY="abc"
export PLAUSIBLE_TOTP_VAULT_KEY="abc"

export STRELAYSRV_PROVIDED_BY_TEXT="example.org"

# TODO: Provide instructions on how to generate some of these (or provide links to app-specific docs)