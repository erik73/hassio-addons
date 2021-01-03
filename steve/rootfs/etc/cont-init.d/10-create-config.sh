#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Configures SteVe
# ==============================================================================


# Modify config files
sed -i 's/^db.ip .*$/db.ip = core-mariadb/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.user .*$/db.user = stevedbuser/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.password .*$/db.password = Nisse123/' /usr/src/steve/src/main/resources/config/prod/main.properties
