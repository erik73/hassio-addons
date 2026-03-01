# Home Assistant Community Add-on: InfluxDB3

InfluxDB is an open source time series database optimized for high-write-volume.
It's useful for recording metrics, sensor data, events,
and performing analytics. It exposes an HTTP API for client interaction and is
often used in combination with Grafana to visualize the data.

This app runs the InfluxDB3.x build channel.

Important: This app requires a free license from InfluxData.
It is required that you provide your email address in the app configuration,
and once the app it started, you will get an email where you can activate
your license. It is free as long as it is for home use.

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield]

## Installation

Follow these steps to get the app installed on your system:

Add the repository `https://github.com/erik73/hassio-addons`.
Find the "InfluxDB3" app and click it.
Click on the "INSTALL" button.

## First Run

Make sure, that the required port `8181` is not in use by another app
It is also possible to alter it to another port in the configuration.

Please read above regarding the requirement for a license.
When the app is started fore the first time, it will generate an
automated license request to InfluxData, and the app will wait for you
to activate it via the activation link you recieve on your provided email
account. Once you click the activaton link, InfluxDB3 will start.

Please save the `Token` and the `HTTP Requests Header` since you will
need them later in your homeassistant configuration, and for data migration.

## Administrative Access

There is no GUI provided with InfluxDB3. To create you database, you need
to install InfluxDB 3 Explorer. I used docker desktop on my Windows desktop
computer and installed it with the following command line input:

```yaml
docker run --detach --name influxdb3-explorer --publish 8888:80 influxdata/influxdb3-ui:latest --mode=admin
```

Point your broser to `http://localhost:8888/` to connect to the admin interface.

## Configuration

Adding the following to your `secrets.yaml` and alter it on your needs.

```yaml
influx_token: <your Token>
```

Adding the following snippet to your `configuration.yaml` and alter it
to your needs.
Especially ignore_attributes and entities. After that,
please restart Homeassistant to take affect of your changes

```yaml
#InfluxDB3
influxdb:
  host: 32b8266a-influxdb3
  port: 8181
  api_version: 2
  max_retries: 3
  default_measurement: state
  token: !secret influx_token
  # Required, but not validated
  organization: d1c92e4eef98a5b6
  bucket: <Your database name, for example HomeAssistant>
  ssl: false
  verify_ssl: false
  ignore_attributes:
    - device_class
    - device_type
    - icon
    - source
    - state_class
    - status
    - child_lock
    - linkquality
    - update_str
    - update_available
    - indicator_mode
    - voltage
    - power
    - power_outage_memory
    - latest_version
    - installed_version
    - update
    - power_outage_memory
    - energy
    - current
    - battery
    - humidity
    - temperature
  include:
    entities:
      - sensor.rf433_temp_garten
      - sensor.RF433_temp_pool
      - sensor.stromzaehler_powerconsumption
```

### Options

- log_level : setting up a general loglevel for the plugin
- influxd_log_level : you can set up a separate loglevel for the influxd service.
  thats because the service supports less options as log_level and they are named
  different
- InfluxDB server: defines the PORT on which the InfluxDB is accessable beside
  the INGRESS Implementation without HomeAssistant

## Known issues and limitations

The current INGRESS Implementation is on an early stage.

## Changelog & Releases

Please see the changelog

## InfluxDB -> InfluxDB3 Migration

### Export data from InfluxDB1.x

Open a shell on your homeassistant system and execute the following commandline
to export all data from your 1.X database to a file

```bash
docker exec addon_a0d7b954_influxdb \
  influx_inspect export \
  -datadir "/data/influxdb/data" \
  -waldir "/data/influxdb/wal" \
  -out "/share/influxdb/home_assistant/export" \
  -database homeassistant \
  -retention autogen \
  -lponly
```

### Importing 1.X File to 2.X

The following steps only works for supervised installations.

For HassIO please have a look as https://github.com/hassio-addons/addon-influxdb/discussions/113#discussioncomment-6947661 (many thanks to https://github.com/mbalasz for the documentation)

I would suggest, opening a direct shell to the new container.
I had some timeouts during import if i execute these the same "docker exec.."
way as the export works
replace @token@ and @orgid@ with your values

```bash
docker exec -it addon_32b8266a_influxdb2 /bin/bash
export INFLUX_TOKEN=@token@
export INFLUX_ORG_ID=@orgid@

influx write \
  --bucket homeassistant \
  --file "/share/influxdb/home_assistant/export" \
```

## V1 compatibility

If you need v1.x compatiblity for e.g. grafana, you have to create a retention
policy for the database and a user for authentification.
Replace the @bucket@ with your value.

#### Retention Policy

```bash
influx v1 dbrp create \
  --db homeassistant \
  --rp autogen \
  --bucket-id @bucket@ \
  --default
```

#### Create User for authentification ====

```bash
influx v1 auth create \
  --read-bucket @bucket@ \
  --write-bucket @bucket@ \
  --username homeassistant
```

---

# Downsampling?

Downsampling reduces the amount of datapoints in your database.
So its easier and faster to work with data over a long period of time.

Personally, i've created 2 buckets.
The first buckets holds a datapoint every 15 minutes and the second bucket holds
a datapoint every 60 minutes.

## 1. Downsample all existing data to the new buckets

```bash
from(bucket: "homeassistant")
  |> range(start: 2020-06-03T00:00:00Z)
  |> filter(fn: (r) => r["_field"] == "value")
  |> aggregateWindow(every: 15m, fn: mean, createEmpty: false)
  |> set(key: "agg_type", value: "mean")
  |> to(bucket: "homeassistant_15m", org: "privat", tagColumns: ["agg_type", "domain", "entity_id", "friendly_name", "source"])
```

```bash
from(bucket: "homeassistant")
  |> range(start: 2020-06-03T00:00:00Z)
  |> filter(fn: (r) => r["_field"] == "value")
  |> aggregateWindow(every: 1h, fn: mean, createEmpty: false)
  |> set(key: "agg_type", value: "mean")
  |> to(bucket: "homeassistant_60m", org: "privat", tagColumns: ["agg_type", "domain", "entity_id", "friendly_name", "source"])
```

## 2. Create a Influx Task for downsampling all future data

```bash
option task = {name: "Downsample_15m", every: 15m, offset: 0m}

from(bucket: "homeassistant")
    |> range(start: -task.every)
    |> filter(fn: (r) => r["_field"] == "value")
    |> aggregateWindow(every: 15m, fn: mean, createEmpty: false)
    |> to(bucket: "homeassistant_15m", org: "privat")
```

```bash
option task = {name: "Downsample_60m", every: 1h, offset: 0m}

from(bucket: "homeassistant")
    |> range(start: -task.every)
    |> filter(fn: (r) => r["_field"] == "value")
    |> aggregateWindow(every: 1h, fn: mean, createEmpty: false)
    |> to(bucket: "homeassistant_60m", org: "privat")
```

## Support

Got questions?

You could [open an issue here][issue] GitHub.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[issue]: https://github.com/erik73/app-influxdb3/issues
[repository]: https://github.com/erik73/hassio-addons
