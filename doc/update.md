**Important: You need to reset your configuration file, a breaking change has been made in this version**

- Removed support for `Celestia` and `World Tree` servers; Removed support for Chinese

- Removed the following configuration item: `basic/region`

- Added the following configuration items: `basic/path`, `basic/process`; when the game launcher path is filled in `basic/path`, the script will start and exit the game at the same time when opening and closing

- The game will now start in borderless mode; when inactive, the game will automatically mute

- Rewritten the image recognition module so that it will now run more accurately and efficiently; it gains about a hundred times better performance in some specific cases compared to the previous version

- Refactored the character recognition module; now supports team sizes from 1 to 5 players; added a new hotkey `alt + f12` to clear the currently recognized character information; and added support for more characters and skins

- Refactored the scene recognition module

- Added support for more characters and skins

- Numerous other known issues fixed