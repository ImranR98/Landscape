#!/bin/bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export MAIN_NODE_HOSTNAME="Frontier"
export PROXY_NODE_HOSTNAME="Lifeline"
export MAIN_NODE_HOSTNAME_LOWERCASE="${MAIN_NODE_HOSTNAME,,}"
export PROXY_NODE_HOSTNAME_LOWERCASE="${PROXY_NODE_HOSTNAME,,}"
export STATE_DIR="$HERE/state"
export MAIN_PARENT_DIR="$HERE/mock-data"

export LOCAL_IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -1)"

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

export MONEROD_RPC_LOGIN="imranr:zoom4321"

export MOSQUITTO_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQChRDheGpQPFA8C
    ciDPO7sXas7YPAGdSbNvRdGhL5nHv8cn3ohBK7CTeYYvRKRmvqSuwBFSVjXG2ovz
    uBD6sPhSTYJMaMfa4cfapWAQNVNh/9jui3xhF1Rx8NnOjIUMUPk29HJXy9xI0oQD
    XMiMp3DI7jpvW1vsSngiJq1ReimhU4O6ePi/cwUiPo4g0YyhSQbV9tHvPVZATnLR
    CJAAPozqkE/YeB0HCANl6oi7Im2uhwrI99OJmp+wU7c5snKwpHRwgXCevv7vKOfY
    AZNddQMBZBZG4nrfYgR3dN4ZAErAPKG/h6s1+bhMuSCxV8pSIyWTb/mz+tkySdCR
    LiQKfkDzAgMBAAECggEAG8nioKyZyMNfFr/N0YfsZEueWvp0GMNjbRAt4EWQjTAJ
    xF//QKOjqLXvHmQIpD/Dpu0nzvVWDO8J4LReEKTAFYaPplUD4z62roGCvShDNwbc
    PbbBdwWLIpsrHQFvx8CIQST8Mw7I5a+I2f95+2q675TFcvzeKShn7RKXGQwg8lBo
    tU+lTIBpcRIszyi7tiMzOkxhvW7yaHm1zPzZw27s9g7iL1f1SQJQQL5KC/tn0QqP
    dmLmYd350FrX6NA/Qavb2jrvjk6nI0T1jCUI8wlkfFkASgy1vVO9ivch/URuMiGd
    fIE7HGRlXBwfkq5fWe3K04mBpPB1HHtfQ8HWMFJjcQKBgQDTWinZCc0ltc+uIrMg
    If61psGfBtnSQhdaCb5Dm7TWk8OxIupibi2KCSL4NG1Owe6Evqz7KB4OjSDh+CcJ
    CEvKDugHxh+9C274u5pHrGTNs+4CcjWMz691iHsWjvu3HMn9mS8Y2PHHoFiUTMan
    Gi9c94oP7Az3k/KorW6O+8q2iwKBgQDDVXFRQq2DceHgh3Uc13OiX4Yr3KdA/y/z
    J6nmGqrBLNe44vqX6hXQuiP3wRek+l602ktH/DGbq8lZPgEy5DCNaIpuJSuXK/hM
    488GxsuIQQcTd4dq67vVNrrrajn/MJDpsf4tRMOH7nf+yNr9/UgpsURwPir+3N9+
    DR3oqCJUOQKBgBm3MLxNqv5ZnslLQ4w3Vqx3e7uDs+EXVYwI/3NucJRjKj5VRztu
    uG/BKNYWWu5oPkM8iAOPIAkZNtUHwogg0EfnhGfdvWLdD0WIXf82hJVavSzjBIz7
    gBfG4WMfRpVDFXibuNVHIDPv2JdCuDEAyJ6BJ/VD/VfqUm4fnAIdtM59AoGBAJDk
    PzMct6KKBhfLwtZLBs5J9zdv7GytHf9Ky58Q5tp2DepqC6JGFDqI6IctpwFMapXS
    Wwchjha//ZICCVebplwuUIjVb5kqF3vJe9a1/WGrgrkw77Ui+Wh1uX9Ig47EkqmW
    y0j++d9Jx56plK/UggPTJ0XvB2uXoPxadHYQya4ZAoGATi2Nwu2EYugKNLlo1FxK
    qyTIsBLrAvuWuRRpZr5zOSmJinQDW2amWtq46N/KOzsHr/TJA8SnbhUx8U96WM75
    fNEzL9fOybpdtfX/1HYw9sXwpa6+a+mlUCPFqAyVpqhD5ZzUf7O2vTCECaS9bHRS
    wpgoV3KHxPEczdLazOJ+VhM=
    -----END PRIVATE KEY-----"
export MOSQUITTO_CERTIFICATE="-----BEGIN CERTIFICATE-----
    MIIDtTCCAp2gAwIBAgIUVPubSH/qMEML5q7R/YAPi70JAogwDQYJKoZIhvcNAQEL
    BQAwajELMAkGA1UEBhMCQ0ExEDAOBgNVBAgMB1Rvcm9udG8xEDAOBgNVBAcMB1Rv
    cm9udG8xEzARBgNVBAoMCkltcmFuUi5ERVYxDTALBgNVBAsMBE1haW4xEzARBgNV
    BAMMCmltcmFuci5kZXYwHhcNMjQwOTAyMjIyMTAzWhcNMjQxMDAyMjIyMTAzWjBq
    MQswCQYDVQQGEwJDQTEQMA4GA1UECAwHVG9yb250bzEQMA4GA1UEBwwHVG9yb250
    bzETMBEGA1UECgwKSW1yYW5SLkRFVjENMAsGA1UECwwETWFpbjETMBEGA1UEAwwK
    aW1yYW5yLmRldjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKFEOF4a
    lA8UDwJyIM87uxdqztg8AZ1Js29F0aEvmce/xyfeiEErsJN5hi9EpGa+pK7AEVJW
    Ncbai/O4EPqw+FJNgkxox9rhx9qlYBA1U2H/2O6LfGEXVHHw2c6MhQxQ+Tb0clfL
    3EjShANcyIyncMjuOm9bW+xKeCImrVF6KaFTg7p4+L9zBSI+jiDRjKFJBtX20e89
    VkBOctEIkAA+jOqQT9h4HQcIA2XqiLsiba6HCsj304man7BTtzmycrCkdHCBcJ6+
    /u8o59gBk111AwFkFkbiet9iBHd03hkASsA8ob+HqzX5uEy5ILFXylIjJZNv+bP6
    2TJJ0JEuJAp+QPMCAwEAAaNTMFEwHQYDVR0OBBYEFJIFr5mkgyV18edOM4TFo0E2
    xE2iMB8GA1UdIwQYMBaAFJIFr5mkgyV18edOM4TFo0E2xE2iMA8GA1UdEwEB/wQF
    MAMBAf8wDQYJKoZIhvcNAQELBQADggEBAGgVirgzcSEGqFW7km5ikUB8ixpcdWvd
    yKnwOOTygRmf9Hk3qAK2elO7dKlu4Iz+2xD6zL9yvqJRLFmv5Lj+ZcDK8hfwO7NV
    ImP3HlYstuLkesR1mk0K2B0xmgX6Qly6q6WgjUGXoVPb7ASGNxiYmLtRFiwAde0d
    qUYKqnqOwx79xrql9LqN3mbD4FsMmkalTBZRwGvf00JcVV07TT3BckEQLksSf4kx
    p/36NqxpyFog38qy6+4gkHcDXWiLQRpXVkTHseQ5ObZPG3wr4b3uvnkq0aJxQT8v
    QGd1R14vfcBTS3ceWLCSX9Bxhhr5r530wqFwOWFKNtOCkCX25OlRr24=
    -----END CERTIFICATE-----"
export MOSQUITTO_CREDENTIALS='imranr:$7$101$/UX0d8KZVUjyFV0V$CMypWaIII96FRb/lSMVsXda49lTm1DivKJGoN/zmsaa432EmqAAb9ToO9ykJI/ehj+7ZFwDasHZ56OQ8Mmmk5w=='

export NEXTCLOUD_DB_PASSWORD="96c57151976660baa48854b5ea010ee2f61bc6e0e83f87c9200de50e79aabbc2"
export NEXTCLOUD_ADMIN_USER="imranr"
export NEXTCLOUD_ADMIN_PASSWORD="zoom4321.Nextcloud"

export PLAUSIBLE_DB_PASSWORD="e2afdb4872c0056ceb5c2db51693a2174d0c454147d7633b5b4aa379e281a28f"
export PLAUSIBLE_SECRET_KEY="HEJkT3HCVfH9nhWJTB6NPq9faPvWZB69H51JJGQEWGVe2YNuOnoILpH3M+L/Cc8m"
export PLAUSIBLE_TOTP_VAULT_KEY="cwcunViPJi3h5Vz9MXakMo2cmeEkIasIw7dxFwcUpgA="

export STRELAYSRV_PROVIDED_BY_TEXT="ImranR.DEV (staging)"