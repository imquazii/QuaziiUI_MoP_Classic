# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2024.19.19-2](https://github.com/QuaziiUI/Installer/compare/20241019-2...20241019-3)
### Changed:
- Fixed Localization Files causing failure to load

## [2024.19.19-2](https://github.com/QuaziiUI/Installer/compare/20241019-1...20241019-2)
### Changed
- Updated OmniCD Profile (Placement Changes)
- Update Plater Profile (Added Interrupt Indicator to Plater  Castbar if int becomes avail mid cast)

## [2024.10.19-1](https://github.com/QuaziiUI/Installer/compare/20241018-1...20241019-1)
### Added
- Standard GitHub Boilerplates
- Version Support for All Remaining Class WAs
- 3rd Row Support for all classes
- Warrior Class WA Buff Tracking Optimizations

### Changed
- deDE Translation change on MDT Route Import text.


## [2024.10.18-1](https://github.com/QuaziiUI/Installer/compare/20241017-2...20241018-1)
### Added:
- German Translation courtesy of @Knuffelpanda 
- null checking to WA Import Scripts

### Changed:
- Moved Repo to QuaziiUI Org
- Release assets to use QuaziiUI.zip instead of QuaziiUI_DATE.zip for easier latest release linking


## [2024.10.17-2](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241017-1...20241017-2)
## Added
- Version support for DH, DK, Druid, Evoker
- Support for 3rd rown on DH, DK, Evoker

## Changed
- Misc updates and fixes for Warrior and Druid


## [2024.10.17-1](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241016-2...20241017-1)
### Added
- Confirmation Frame for Cell Import
- Quazii's Edit for Reloe's M+ Timer

## [2024.10.16-1](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241015-1...20241016-1)
### Changed:
- Removed unneeded raw print, that was causing chat spam

### Added: 
- Initial implementation of debug mode

## [2024.10.15-1](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241014-1...20241015-1)
### Changed:
- Fixed error in Plater import function by removing redefined self.

## [2024.10.14-1](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241013-2...20241014-1)
### Changed:
- Corrected Locales to not all be set to default
### Added 
- Custom MDT Import

## [2024.10.13-2](https://github.com/chatterchats/QuaziiUIInstaller/compare/20241013...20241013-2)
### Added
- Logic for closing with the X close button to not reopen on reload
- Template files for all supported languages
### Fixed: 
- ElvUI Logic for accessing import strings

## [2024.10.13-1](https://github.com/chatterchats/QuaziiUIInstaller/compare/2024.10.12-beta...20241013)
## Changed
- Fixed auto release pipeline

## [2024.10.12-beta](https://github.com/chatterchats/QuaziiUIInstaller/compare/2024.10.11-alpha3...2024.10.12-beta)
## Added
- MDT Advanced Routes

## Changed
- Build process to accommodate advanced routes
- Refactor build process slightly to make it more resilient against errors

## Fixed
- File names not being updated properly due to git case-insensitivit

## [2024.10.11-alpha3](https://github.com/chatterchats/QuaziiUIInstaller/compare/2024.10.11-alpha2...2024.10.11-alpha3)
## Changed
- Updated Plater Import

## [2024.10.11-alpha2](https://github.com/chatterchats/QuaziiUIInstaller/compare/2024.10.11-alpha...2024.10.11-alpha2)
### Added
- Variable Typing
### Changed
- Renamed Addon from Quazii UI Installer to Quazii UI [BREAKING]
- Converted quaziiLogo from png to tga for wow compatibility
  - Adjusted texture paths
  - Added IconTexture to toc to logo appears in Addon List.
### Fixed
-  Removed whitespace from .gitattributes
### Removed
- .pkgmeta

## [2024.10.11-alpha](https://github.com/chatterchats/quaziiUIInstaller/compare/2024.10.11-alpha...2024.10.11-alpha)
Initial Public Alpha Release to Patreon and YT Members!
### Changed
- Properly implement [ace3](https://www.wowace.com/projects/ace3) by @chatterchats in [#2](https://github.com/chatterchats/QuaziiUIInstaller/pull/2)

## [2024.10.10-alpha](https://github.com/chatterchats/quaziiUIInstaller/compare/v2024.10.09-alpha...2024.10.10-alpha) - 2024-10-10
### Added
- WeakAuras Version Checking

### Updated
- Warrior Class Weakaura with Version string for Version Checking testing.

### New Contributors
- @imquazii made their first contribution in [7b6c8e7](https://github.com/chatterchats/QuaziiUIInstaller/commit/7b6c8e7691dbd438468952e8623e525c4e151727)

## [v2024.10.09-alpha](https://github.com/chatterchats/QuaziiUIInstaller/releases/tag/2024.10.09-alpha) - 2024-10-09
- Initial Release by @chatterchats
- Support for 
  - ElvUI
    - Both Tank/DPS and Healer Profiles!
  - Cell
  - Plater
  - Details
  - BigWigs
  - WeakAuras
  - Mythic Dungeon Tools
### New Contributors
- @Knuffelpanda made their first contributions and PR at [#1](https://github.com/chatterchats/QuaziiUIInstaller/pull/1)
