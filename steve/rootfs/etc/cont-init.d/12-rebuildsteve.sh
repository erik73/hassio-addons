#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: SteVe
# Check if SteVe needs to be built
# ==============================================================================

builtversion="$(xmlstarlet sel -N x=http://maven.apache.org/POM/4.0.0 -t -v "/x:project/x:version" /data/pom.xml)"
packageversion="$(xmlstarlet sel -N x=http://maven.apache.org/POM/4.0.0 -t -v "/x:project/x:version" /usr/src/steve/pom.xml)"

if [ "$builtversion" != "$packageversion" ]; then
    bashio::log.info "Starting SteVe rebuild since there is a new verion...."
    cd /usr/src/steve
    MAVEN_OPTS="-Xmx100m" mvn package
    rm -rf /data/target
    cp -f /usr/src/steve/pom.xml /data/
    cp -R -f /usr/src/steve/target/ /data/
fi