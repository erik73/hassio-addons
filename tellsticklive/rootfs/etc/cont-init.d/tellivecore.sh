#!/usr/bin/with-contenv bashio

# This script will create the config file needed to connect to Telldus Live

TELLIVE="/etc/tellive.conf"
UUID=$(bashio::config 'live_uuid')

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
