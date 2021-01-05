#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Check if SteVe needs to be built
# ==============================================================================

export MAVEN_OPTS="-Xmx100m"

if ! bashio::fs.directory_exists '/data/target'; then
    bashio::log.info "Starting SteVe initial build...."
    cd /usr/src/steve
    mvn package
    cp -f /usr/src/steve/pom.xml /data/
    cp -R -f /usr/src/steve/target/ /data/
fi

diff /usr/src/steve/pom.xml /data/pom.xml
if [ $? -ne 0 ]; then
    bashio::log.info "Starting SteVe rebuild since there is a new verion...."
    cd /usr/src/steve
    mvn package
    rm -rf /data/target
    cp -f /usr/src/steve/pom.xml /data/
    cp -R -f /usr/src/steve/target/ /data/
fi