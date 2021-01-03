#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Configures SteVe
# ==============================================================================


# Modify config files
sed -i 's/^db.ip .*$/db.ip = core-mariadb/' usr/src/steve/src/main/resources/config/prod/main.properties
