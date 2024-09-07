#!/bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export MAIN_NODE_HOSTNAME="Frontier"
export PROXY_NODE_HOSTNAME="Lifeline"
export MAIN_NODE_HOSTNAME_LOWERCASE="${MAIN_NODE_HOSTNAME,,}"
export PROXY_NODE_HOSTNAME_LOWERCASE="${PROXY_NODE_HOSTNAME,,}"
export STATE_DIR="$HERE/state"
export MAIN_PARENT_DIR="$HERE/mock-data"

export SERVICES_DOMAIN="staging.imranr.dev"
export SERVICES_TOP_DOMAIN="imranr.dev"
export SERVICES_TLS_NAME="$(echo "$SERVICES_TOP_DOMAIN" | sed 's/\./-/g')"

export PROXY_USER="imranr"
export PROXY_HOST="staging.imranr.dev"
export PROXY_SSH_STRING="$PROXY_USER"@"$PROXY_HOST"

export DOMAIN_OWNER_EMAIL="contact@imranr.dev"

export CLOUDFLARE_TOKEN="bIXJXhT5QCqzEcERBl1SycTCTYijFuFQVBIvvIyC"

export NTFY_SERVICE_USER_TOKEN="tk_e4sjkxevnngm30q2t9n41yv6dp1qi"

export AUTHELIA_ADMIN_DISPLAYNAME="Imran"
export AUTHELIA_ADMIN_PASSWORD_HASH='$argon2id$v=19$m=65536,t=3,p=4$dVmAn9W/eMZZ8o/12U3ZZw$E1LbeFpxPHPD37YG8tWi3+1/+7bD8SmAZwPhQ+ZGbTw'
export AUTHELIA_ADMIN_EMAIL="contact@imranr.dev"
export AUTHELIA_DB_ENCRYPTION_KEY="bbf112811c99c821a7ca4120491bc2eb63579eac7dfcc14dfa4e53ff5a911ddc"
export AUTHELIA_DB_PASSWORD="fa0a28c575404f023570f47ae050c671b5a238c0433dd6391d3c37f523603dd4"
export AUTHELIA_REDIS_PASSWORD="d0bacbcc807541cb08a6c4b51b7cba366046dfe658c354376f752d3e55155ad3"
export AUTHELIA_SUBDOMAIN="auth.staging"
export AUTHELIA_TOP_DOMAIN="$SERVICES_TOP_DOMAIN"
export AUTHELIA_OIDC_HMAC_SECRET="483a0571ef6cbb99336571b7b053cbfd6f88f5c36d2e0c02d8db0b7d7b09285a"
export AUTHELIA_JWKS_KEY="-----BEGIN PRIVATE KEY-----
              MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7myWf4hzXnl1Z
              VXnxIPAvS3w632Lpc7zqwlUZb/rNLm6ALSPKCSEXjcAMS9b1amshTenEZ59e60RG
              wnBfRnYhmHRfyEC57ZdOfCOqEW64u7mXSHC1nIldREJV6khT3MlMiBLdp5BKRtB0
              kZjiX/blx4zHuHc/ddFR5te1/CB6stOk5Wbcm3jg9kAYpONFZHB8UijLTXJGQQhI
              rRBA8ccW3olMvxgxkXIH8jDsIljxP/YjgG5EHIcMe2HrF6nCl+GbbOxJWjRxpNWa
              cW0PM3EccibCXJxH1Ewh5IFAotW+/Pe1UNZvGvSgg32PGrOSWQAlFrIbrH7G2ZCM
              LUlYKBgXAgMBAAECggEAYdUGSdogMFDlXTC15ojGt+MlZY4YhqVUXxf4SMucfmM4
              PJ9Nio44M5A4FjF2Z4SXWUbIISPoeBc4A65h601TTTGzfj9vgYXk4YjbEFUG6E78
              +WdNX2fCOmDeNu91yEXas45CSFSZaiKDkkZa87IXjrwBLiWEChPmlE9NLhnM1i6F
              VoS1UqpYgRgmOMv4GbGCqfp94sYvn31esAQrP9viNupPfN+bZjq0XCilWi2HdGGI
              roJr8voHmhGuRriKktfNAwpdfxiJFU8rixT+npP3queNJvWPLlW8x6s3l0Rcx+eU
              yZIB34tuZ/uucXBiRDkDxAq5WvdnkqalGDdECe7UAQKBgQDzny8xmEtCYV4Paa8u
              /FPnOKhZFd/u3Gv3lDJUa3sRmZcXQ8FjoCSf2Vlsva3AISZkBzr3PaKK4xqWnRhR
              QtUM3X4fxlWB9O/94bT8bsE6nzgnHTdsOji7zoi+liSbRAgTWjDIRaTe6Xl56iFl
              nmpgoC0H9ypW4SJGIw+4C7aSvQKBgQDFI1v99e8M8c6MHz409kvE+8ZG3DqPHb/8
              Ou4QqFi7GfMF4F5cy0RaKRsm6rfwxMRCaORthEZAFgM/ncQ/9t/V+qQ/f0H/zoCU
              42YTPJdwgU6sHuSK3tRKHOL0/AWCTGwMQefhNN4CohwQQBGbOMLwFJ/bPRJvu2wW
              KhoAB/zNYwKBgQC6Fc5LmKNrycm6BiTMw+omxI06ts28utsxWh5zg0GW+PWCzLtM
              KMew3alDuUKdbfTQFQHCVm7wnXXys34em+j2kbzD8o/f20LxbtT6uHKaH4IZxmRO
              I86wDZs/0JmXi4iLl6mJYEEGD9o8+EyYPT/OHKso2W+auw6d+iwIjdHgFQKBgGw3
              pOAciUWJ1+CDphpcuetAau+rJVo68pD7qIPsZgkPjaDEMgiubK8xsX4Di0XYPgRW
              oE6eNhIoA1CAwqJ6WxWTqWZR7WEHcv5IdlhJArj3wsAplTvGZrLoeI4TatLEMOvp
              oei2pMi9RLqG8SNMXXZ9W+N1+xDqycLBCdTKjbQRAoGBANi6M+NaK+8aZNwI6e7k
              LtASOuE/AXzTf7Oellmczu8HiYgPRlvkYVy9lby+C1ASjF+dz4xG3mMb5hOKpODH
              FIDyj3i+V0NyxtXkHEPMWBoc8F5ot+49mxooc8SQleXxNKL/R925KBbIqnSUimrd
              1yQZil3faVYl//7bQQc5pOuX
              -----END PRIVATE KEY-----"
export AUTHELIA_IMMICH_CLIENT_SECRET='$pbkdf2-sha512$310000$7CscErycuFXzvu74Kdzelw$RTpLh8NsqJ9eTVH5MFBo4EbsoIMmLLFWdAEwS43eX.pluhH32xsOH1hmqeO1uNSb43OyZ4gNhTi/39sAUAPwVg'

export CROWDSEC_BOUNCER_KEY="96e26fdf5a9ae8775280c96a7d2241ab389f68c0d44b1022ffa300d5dd8bc099"
export CROWDSEC_LAPI_SECRET="eb7528fb92305045dd5a3b4c1dbd64d16040c792e3b2607f9ab6efd2d5e2adb8"

export IMMICH_OAUTH_CLIENT_SECRET="d63017b141d876f34698cae2ca51e95c6063a7e46095e38d2e8d7cd958da1dadad3f2e86"
export IMMICH_DB_PASSWORD="fd2dfdb69ac906e3e8fe4b7ab74cb3f265cc38a794a23f72843b997a2677a727"