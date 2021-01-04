#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Configures SteVe
# ==============================================================================


# Modify config files
sed -i 's/^db.ip .*$/db.ip = core-mariadb/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.user .*$/db.user = stevedbuser/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^db.password .*$/db.password = Nisse123/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^server.host .*$/server.host = 0.0.0.0/' /usr/src/steve/src/main/resources/config/prod/main.properties
sed -i 's/^http.port .*$/http.port = 8180/' /usr/src/steve/src/main/resources/config/prod/main.properties
# sed -i 's/^    private final String timeZoneId .*$/    private final String timeZoneId = ZoneId.systemDefault().getId();/' /usr/src/steve/src/main/java/de/rwth/idsg/steve/SteveConfiguration.java
sed -i 's/^    private final String timeZoneId .*$/    private final String timeZoneId = "CET";/' /usr/src/steve/src/main/java/de/rwth/idsg/steve/SteveConfiguration.java