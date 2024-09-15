#!/bin/bash
set -e
SERVICES_USER="${MAIN_NODE_HOSTNAME_LOWERCASE}_services"
SERVICES_TOPIC="${SERVICES_USER}_*"
echo 'NOTE: You may need to create a user, generate a token, and replace it in VARS.sh. Example of helpful commands (run in the container):

kubectl -n production exec --stdin --tty "$(kubectl -n production get pod | grep authelia | grep -v redis | grep -v postgres | awk '{print \$1}')" -- cat /config/notification.txt'

echo "
ntfy user add $USER
ntfy access $USER \"*\" rw
ntfy user change-role $USER admin

ntfy user add $SERVICES_USER
ntfy access $SERVICES_USER \"$SERVICES_TOPIC\" rw
ntfy token add $SERVICES_USER"