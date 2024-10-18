# QuaziiUI Addon

QuaziiUI Addon Importer is a World of Warcraft addon that allows community members to easily import profiles and WeakAuras from Quazii, a popular [Twitch](https://twitch.tv/imquazii) and [YouTube](https://www.youtube.com/@quaziiwow) content creator. The addon supports imports for a range of popular WoW addons such as:

- ElvUI
- OmniCD
- Plater
- Details
- MythicDungeonTools (MDT)
- Cell
- BigWigs
- WeakAuras

## Features

- One-click import for Quazii's addon profiles and WeakAuras.
- Seamless integration with the supported addons.
- Regular updates to keep profiles and WeakAuras in sync with Quazii's latest recommendations.

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/QuaziiUI/installer/releases/latest).
2. Extract the contents to your `Interface/AddOns/` directory in your WoW installation.
3. Restart WoW or reload your UI (`/reload`).

## Usage

Once installed, use the `/qui` command to open the interface for importing profiles and WeakAuras. From there, select the addon you want to configure and follow the instructions to import Quazii's profiles.

## Building

To update import strings for profiles and WeakAuras, you need to run a Python script located in the `./tools` directory.

### How to Run `build.py`

The Python file `./tools/build.py` is responsible for copying updated strings from text files located in the `./tools/imports/*` folder and updating the `./QuaziiUI/imports.lua` file.

To run the script:
1. Ensure you have Python 3 installed.
3. Run the following command:

```
python build.py
```

This will copy updated strings and update `./QuaziiUI/imports.lua`.

## Contributing

We welcome contributions to help improve localization and functionality! 

### Localization

We use WoW’s [AceLocale-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0) library for localization. If you want to contribute to localization efforts, follow these steps:

1. Clone the repository and navigate to `./QuaziiUI/Locales`.
2. Edit the relevant `.lua` files to add or update localization strings.
4. Submit a Pull Request (PR) with your changes.

### Pull Requests

All contributions should be submitted through pull requests. When contributing:
- Fork this repository.
- Make your changes in a new branch.
- Submit your changes through a pull request with a clear description of what you’ve done.

We appreciate all contributions! Thank you for helping us improve QuaziiUI Addon Importer.

## License

This project is licensed under the GPLv3 License - see the [LICENSE](LICENSE) file for details.
