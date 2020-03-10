# Home Assistant Add-on: TellStick with Telldus Live

TellStick and TellStick Duo service with a possibility to export devices to Telldus Live

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

## About

This add-on is a modification of the official TellStick addon. The ability to have your devices and sensors published Telldus Live has been added.

See the official addon documentation for details on device setup. 

## Installation

Follow these steps to get the add-on installed on your system:
1. Add the repository https://github.com/erik73/hassio-addons. 
2. Find the "TellStick with Telldus Live" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

### Starting the add-on

After installation you are presented with a default and example configuration.
The difference from the official addon is the sensors part. Leave that for now.
Setup the devices according to the official instructions, and start the addon.

1. Adjust the add-on configuration to match your devices. See the official add-on
   configuration options for details.
2. Save the add-on configuration by clicking the "SAVE" button.
3. Start the add-on.

### Home Assistant integration

You will need to add internal communication details to the `configuration.yaml`
file to enable the integration with the add-on.

```yaml
# Example configuration.yaml entry
tellstick:
    host: 32b8266a-tellsticklive
    port: [50800, 50801]
```


## Configuration

When your devices work as expected you can start the configuration of the Telldus Live integration.
All devices configured and working will be visible in your Telldus Live account when you have completed all
configuration steps below.

The configuration of devices is well documented for the official addon. Use those instructions for your devices.
To find the ID:s to be used in the sensor configuration options, see the options listed below.

Example sensor configuration:

```yaml
enablelive: false
sensors:
  - id: 199
    name: Example sensor
    protocol: fineoffset
    model: temperature
  - id: 215
    name: Example sensor two
    protocol: fineoffset
    model: temperaturehumidity
```

Please note: After any changes have been made to the configuration,
you need to restart the add-on for the changes to take effect.

### Option: `sensors` (required)

Add one or more sensors entries to the add-on configuration for each
sensor you'd like to add to Telldus Live

#### Option: `sensors.id` (required)

This is the id of the sensor. To find out what id to use you have to use the service call hassio.addon_stdin with the following data:
`{"addon":"32b8266a_tellsticklive","input":{"function":"list-sensors"}}`
Look in the addon log, and you should be able to find the id, protocol and model for your sensors.

#### Option: `sensors.name` (required)

A name for your sensor, that will be displayed in Telldus Live.

#### Option: `sensors.protocol` (required)

This is the protocol the sensor uses. See above regarding service call to find this information.

#### Option: `sensors.model` (optional)

The model of the sensor. See above regarding the service call to find this information.

## Service calls

If you wish to teach a self-learning device in your TellStick configuration:

Go to Home Assistant service call in Developer tools and select:

- Service: `hassio.addon_stdin`
- Enter service Data:
  `{"addon":"32b8266a-tellsticklive","input":{"function":"learn","device":"1"}}`

Replace `1` with the corresponding ID of the device in your TellStick configuration.

You can also use this to list devices or sensors and read the output in the
add-on log: `{"addon":"32b8266a-tellsticklive","input":{"function":"list-sensors"}}`

### Supported service commands

- `"function":"list"`
  List currently configured devices with name and device id and all discovered sensors.
  
- `"function":"list-sensors"`
  
- `"function":"list-devices"`
  Alternative devices/sensors listing: Shows devices and/or sensors using key=value
  format (with tabs as separators, one device/sensor per line, no header lines.)

- `"function":"on","device":"x"`
  Turns on device. ’x’ could either be an integer of the device-id,
  or the name of the device.

- `"function":"off","device":"x"`
  Turns off device. ’x’ could either be an integer of the device-id,
  or the name of the device.

## How to enable the Telldus Live connection

Once you are happy with the devices and sensors configuration it is time to establish
the connection to Telldus Live, and generate an UUID that will be used to connect.

Set the config option:

```yaml
enablelive: true
```

Restart the addon and look in the addon log. 
You will get a URL to visit in your browser to establish the connection
between your Live account and this addon.
That URL take you to Telldus Live, and you will be asked to login or create an account 
if you don´t have one.

Also make sure you copy the string after uuid= in the URL, and create the following config entry:

```yaml
liveuuid: de1333b5-154c-5342-87dc-6b7e0b2096ab
```

The above is an example. Yours will look different.

Once all this is complete, you can restart the addon, and your devices and sensors will appear
in Telldus Live!
It can take a restart or two before the sensor names show correctly in Telldus Live.

Please note: Once enablelive: true is set, but you have not set the liveuuid, the addon
is in a configuration mode and will not accept service calls. Once the liveuuid: is set
the addon works as expected.

## Support

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[conf]: http://developer.telldus.com/wiki/TellStick_conf
[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[issue]: https://github.com/home-assistant/hassio-addons/issues
[protocol-list]: http://developer.telldus.com/wiki/TellStick_conf
[reddit]: https://reddit.com/r/homeassistant
[repository]: https://github.com/hassio-addons/repository
