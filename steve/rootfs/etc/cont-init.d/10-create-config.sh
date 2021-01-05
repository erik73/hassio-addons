#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Configures SteVe
# ==============================================================================

export host
export password
export port
export username
export database

host=$(bashio::services "mysql" "host")
password=$(bashio::services "mysql" "password")
port=$(bashio::services "mysql" "port")
username=$(bashio::services "mysql" "username")
adminuser=$(bashio::config 'admin_user')
adminpassword=$(bashio::config 'admin_password')
timezone=$(bashio::config 'timezone')
httpport=$(bashio::config 'httpport')

# Modify config files
sed -i 's/^db.ip .*$/db.ip = '$host'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.user .*$/db.user = '$username'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.password .*$/db.password = '$password'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^server.host .*$/server.host = 0.0.0.0/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^http.port .*$/http.port = '$httpport'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^auth.user .*$/auth.user = '$adminuser'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^auth.password .*$/auth.password = '$adminpassword'/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^    private final String timeZoneId .*$/    private final String timeZoneId = "'$timezone'";/' /usr/src/steve/src/main/java/de/rwth/idsg/steve/SteveConfiguration.java

database=$(\
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
        --skip-column-names \
        -e "SHOW DATABASES LIKE 'stevedb';"
)

if ! bashio::var.has_value "${database}"; then
    bashio::log.info "Creating database for SteVe"
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
            < /usr/src/steve/createdb.sql
fi