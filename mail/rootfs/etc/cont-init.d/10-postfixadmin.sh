#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: mailserver
# Configures mailserver
# ==============================================================================
declare host
declare password
declare port
declare username
declare database

chmod +x /usr/local/bin/quota-warning.sh

chown vmail:vmail /var/mail; \

# Ensures the data of the Postfix and Dovecot is stored outside of the container
if ! bashio::fs.directory_exists '/data/mail'; then
    mkdir -p /data/mail
fi
rm -fr /var/mail
ln -s /data/mail /var/mail
chown vmail:vmail /var/mail

if ! bashio::fs.file_exists "/data/config.secret.inc.php"; then
    cat > /data/config.secret.inc.php <<EOT
<?php
\$cfg['blowfish_secret'] = '$(tr -dc 'a-zA-Z0-9~!@#$%^&*_()+}{?></";.,[]=-' < /dev/urandom | fold -w 32 | head -n 1)';
EOT
fi
chmod 644 /data/config.secret.inc.php

host=$(bashio::services "mysql" "host")
password=$(bashio::services "mysql" "password")
port=$(bashio::services "mysql" "port")
username=$(bashio::services "mysql" "username")

database=$(\
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
        --skip-column-names \
        -e "SHOW DATABASES LIKE 'postfixadmin';"
)

if ! bashio::var.has_value "${database}"; then
    bashio::log.info "Creating database for postfixadmin"
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
            < /etc/postfix/createdb.sql

export SERVICE_HOST
export SERVICE_PASSWORD
export SERVICE_PORT
export SERVICE_USERNAME

SERVICE_HOST=$(bashio::services "mysql" "host")
SERVICE_PASSWORD=$(bashio::services "mysql" "password")
SERVICE_PORT=$(bashio::services "mysql" "port")
SERVICE_USERNAME=$(bashio::services "mysql" "username")

php /var/www/postfixadmin/public/upgrade.php
/var/www/postfixadmin/scripts/postfixadmin-cli admin add superadmin@hilton.zapto.org --superadmin 1 --active 1 --password Duchesse87 --password2 Duchesse87
fi
