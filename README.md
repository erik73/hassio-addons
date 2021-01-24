# EDGE - Home Assistant Community Add-ons

![Project Stage][project-stage-shield]
![Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE.md)

[![Discord][discord-shield]][discord]
[![Community Forum][forum-shield]][forum]

## WARNING! THIS IS AN EDGE REPOSITORY

This Home Assistant Add-ons repository contains edge builds of add-ons. Edge
builds add-ons are based upon the latest development version.

- They may not work at all.
- They might stop working at any time.
- They could have a negative impact on your system.

This repository was created for:

- Anybody willing to test.
- Anybody interested in trying out upcoming add-ons or add-on features.
- Developers.

If you are more interested in stable releases of our add-ons:

<https://github.com/hassio-addons/repository>

## Installation

Adding this add-ons repository to your Home Assistant instance is
pretty straightforward. In the Home Assistant add-on store,
a possibility to add a repository is provided.

Use the following URL to add this repository:

```txt
https://github.com/erik73/hassio-addons
```

## Add-ons provided by this repository

### &#10003; [Mailserver][addon-mailserver]

![Latest Version][mailserver-version-shield]
![Supports armhf Architecture][mailserver-armhf-shield]
![Supports armv7 Architecture][mailserver-armv7-shield]
![Supports aarch64 Architecture][mailserver-aarch64-shield]
![Supports amd64 Architecture][mailserver-amd64-shield]
![Supports i386 Architecture][mailserver-i386-shield]

Complete mail server solution for Home Assistant

[:books: Mailserver add-on documentation][addon-doc-mailserver]

### &#10003; [TellStick with Telldus Live][addon-tellsticklive]

![Latest Version][tellsticklive-version-shield]
![Supports armhf Architecture][tellsticklive-armhf-shield]
![Supports armv7 Architecture][tellsticklive-armv7-shield]
![Supports aarch64 Architecture][tellsticklive-aarch64-shield]
![Supports amd64 Architecture][tellsticklive-amd64-shield]
![Supports i386 Architecture][tellsticklive-i386-shield]

TellStick and TellStick Duo service with Telldus Live

[:books: TellStick with Telldus Live add-on documentation][addon-doc-tellsticklive]

### &#10003; [steve][addon-steve]

![Latest Version][steve-version-shield]
![Supports armhf Architecture][steve-armhf-shield]
![Supports armv7 Architecture][steve-armv7-shield]
![Supports aarch64 Architecture][steve-aarch64-shield]
![Supports amd64 Architecture][steve-amd64-shield]
![Supports i386 Architecture][steve-i386-shield]

OCPP server for EV charging stations

[:books: steve add-on documentation][addon-doc-steve]

## Releases

Add-on releases are **NOT** based on [Semantic Versioning][semver], unlike
all our other repositories. The latest build commit SHA hash of each
add-on, represents the version number.

## Support

Got questions?

You have several options to get them answered:

- The Home Assistant Community Add-ons [Discord Chat Server][discord]
- The Home Assistant [Community Forum][forum].
- The Home Assistant [Discord Chat Server][discord-ha].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also open an issue here on GitHub. Note, we use a separate
GitHub repository for each add-on. Please ensure you are creating the issue
on the correct GitHub repository matching the add-on.

- [Open an issue for the add-on: Mailserver][mailserver-issue]
- [Open an issue for the add-on: TellStick with Telldus Live][tellsticklive-issue]
- [Open an issue for the add-on: steve][steve-issue]

For a general repository issue or add-on ideas [open an issue here][issue]

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Adding a new add-on

We are currently not accepting third party add-ons to this repository.

For questions, please contact [Franck Nijhof][frenck]:

- Drop him an email: frenck@addons.community
- Chat with him on [Discord Chat][discord]
- Message him via the forums: [frenck][forum-frenck]

## License

MIT License

Copyright (c) 2018-2021 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[addon-mailserver]: https://github.com/erik73/addon-mail/tree/v0.5.7
[addon-doc-mailserver]: https://github.com/erik73/addon-mail/blob/v0.5.7/README.md
[mailserver-issue]: https://github.com/erik73/addon-mail/issues
[mailserver-version-shield]: https://img.shields.io/badge/version-v0.5.7-blue.svg
[mailserver-aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[mailserver-amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[mailserver-armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[mailserver-armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[mailserver-i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[addon-tellsticklive]: https://github.com/erik73/addon-tellsticklive/tree/v0.9.5
[addon-doc-tellsticklive]: https://github.com/erik73/addon-tellsticklive/blob/v0.9.5/README.md
[tellsticklive-issue]: https://github.com/erik73/addon-tellsticklive/issues
[tellsticklive-version-shield]: https://img.shields.io/badge/version-v0.9.5-blue.svg
[tellsticklive-aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[tellsticklive-amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[tellsticklive-armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[tellsticklive-armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[tellsticklive-i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[addon-steve]: https://github.com/erik73/addon-steve/tree/v0.3.7
[addon-doc-steve]: https://github.com/erik73/addon-steve/blob/v0.3.7/README.md
[steve-issue]: https://github.com/erik73/addon-steve/issues
[steve-version-shield]: https://img.shields.io/badge/version-v0.3.7-blue.svg
[steve-aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[steve-amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[steve-armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[steve-armv7-shield]: https://img.shields.io/badge/armv7-no-red.svg
[steve-i386-shield]: https://img.shields.io/badge/i386-no-red.svg
[discord-ha]: https://discord.gg/c5DvZ4e
[discord-shield]: https://img.shields.io/discord/478094546522079232.svg
[discord]: https://discord.me/hassioaddons
[forum-frenck]: https://community.home-assistant.io/u/frenck/?u=frenck
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io?u=frenck
[frenck]: https://github.com/frenck
[issue]: https://github.com/erik73/hassio-addons/issues
[license-shield]: https://img.shields.io/github/license/erik73/hassio-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2021.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
[reddit]: https://reddit.com/r/homeassistant
[semver]: http://semver.org/spec/v2.0.0.html
[third-party-addons]: https://home-assistant.io/hassio/installing_third_party_addons/