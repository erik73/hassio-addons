#!/usr/bin/with-contenv bashio

# This script will create the config file needed to connect to Telldus Live

TELLIVE="/etc/tellive.conf"
UUID=$(bashio::config 'liveuuid')

{
    echo "[settings]"
    echo "uuid = ${UUID}"
    echo "debug = False"
} > "${TELLIVE}"

for device in $(bashio::config 'devices|keys'); do
    DEV_ID=$(bashio::config "devices[${device}].id")
    
    (
        echo "device_${DEV_ID}_enabled = True"
    ) >> "${TELLIVE}"
done

#Sensors

for device in $(bashio::config 'sensors|keys'); do
    SENSOR_ID=$(bashio::config "sensors[${device}].id")
    SENSOR_NAME=$(bashio::config "sensors[${device}].name")
    SENSOR_PROTO=$(bashio::config "sensors[${device}].protocol")
    SENSOR_MODEL=$(bashio::config "sensors[${device}].model")
    (
        echo "sensor_${SENSOR_PROTO}_${SENSOR_MODEL}_${SENSOR_ID} = ${SENSOR_NAME}"
    ) >> "${TELLIVE}"
done

# 
#if bashio::config.true "enablelive"; then
#    bashio::log.info "Telldus Live enabled."
#
#    if bashio::config.has_value "liveuuid"; then
#        # If uuid exists in the config we will start the service via servises.d
#        bashio::log.info "UUID has been entered in config options. Exit config script and start as a service..."
#    else
#        bashio::log.info "UUID has not been entered in config. Generating registration URL"
#        bashio::log.info "Follow the link below to register this addon with Telldus Live."
#        bashio::log.info "copy the uuid string in the url and set liveuuid config option to match that."
#        tellive_core_connector /etc/tellive.conf
#    fi
#fi
