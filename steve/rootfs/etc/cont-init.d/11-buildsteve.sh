#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Check if SteVe needs to be built
# ==============================================================================

if ! bashio::fs.directory_exists '/data/target'; then
    bashio::log.info "Starting SteVe initial build...."
    cd /usr/src/steve
    MAVEN_OPTS="-Xmx100m" mvn package
    cp -f /usr/src/steve/pom.xml /data/
    cp -R -f /usr/src/steve/target/ /data/
fi
unset errexit
cmp -s /usr/src/steve/pom.xml /data/pom.xml
if [ $? -eq 1 ]
then
    bashio::log.info "Starting SteVe rebuild since there is a new verion...."
    cd /usr/src/steve
    MAVEN_OPTS="-Xmx100m" mvn package
    rm -rf /data/target
    cp -f /usr/src/steve/pom.xml /data/
    cp -R -f /usr/src/steve/target/ /data/
fi
set -o errexit