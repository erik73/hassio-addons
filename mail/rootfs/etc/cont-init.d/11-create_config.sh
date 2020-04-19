#!/usr/bin/with-contenv bashio

export SERVICE_HOST
export SERVICE_PASSWORD
export SERVICE_PORT
export SERVICE_USERNAME

SERVICE_HOST=$(bashio::services "mysql" "host")
SERVICE_PASSWORD=$(bashio::services "mysql" "password")
SERVICE_PORT=$(bashio::services "mysql" "port")
SERVICE_USERNAME=$(bashio::services "mysql" "username")

sed -i 's/^user .*$/user = '$SERVICE_USERNAME'/' /etc/postfix/sql/*.cf
sed -i 's/^password .*$/password = '$SERVICE_PASSWORD'/' /etc/postfix/sql/*.cf
sed -i 's/^hosts .*$/hosts = '$SERVICE_HOST'/' /etc/postfix/sql/*.cf

sed -i 's/^connect .*$/connect = host='$SERVICE_HOST' dbname=postfixadmin user='$SERVICE_USERNAME' password='$SERVICE_PASSWORD'/' /etc/dovecot/*.ext
