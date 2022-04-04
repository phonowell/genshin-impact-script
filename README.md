# GIS

Sweet! What a cute Genshin Impact script!

[中文](./doc/readme-cn.md)

## Introduction

A script that provides a little extra functionality for the Genshin Impact players. Really just a little bit dayo!

**!!NO CHEATS!!**

## Features

### Skill Timer

- Display the cooldown and effect duration of `E` skills

### Auto Pickup

- Hold down `F` key to pick up items quickly/skip dialogue
- Press `Alt + F` to enter/exit auto-pickup mode; this mode will automatically pick up items or skip conversations

### Auto Fight

- Configurable action when switching characters with `Number Keys`
- You can configure custom moves for each character independently, and long press `Left Click` to cycle through them automatically

### Auto Fish

- Press `F11` to enter/exit this mode

### Auto Forward

- Press `Alt + W` to enter/exit this mode

### Auto Glide

- Automatically turn on the glider when `Space` is pressed

### Other

- Make the game running as borderless; mute it when the game is inactive and set the process priority to the lowest

## Usage

**Note that you need to change the `Switch Walk/Run` function from `Left Ctrl` to `Right Ctrl` in the game**

Download the release and unzip it

Go to the unpacked folder and double-click `start.exe` in it (you will be prompted if you want to apply administrator privileges, select **Apply**)

### Skill Timer

Before using this function, you need to identify the characters by the following action: Press `F12` key with the right avatar visible

After changing the team lineup, the characters should be re-identified

Some characters are not supported at the moment

## Configuration

Refer to the [configuration](./data/config.ini) for details

When you finish editing, press `Ctrl + F5` and it will take effect immediately

### Characters

Add the chanacter name at the bottom of the file to enable character-specific configuration

For Example:

```ini
[klee]
on-long-press = a, a~

[zhongli]
on-switch = e~
```

#### on-long-press

Customized tactic module. For details, click [here](./doc/tactic.md)

#### on-switch

The type of appearance. Can be one of the following values:

- `e` Uses the corresponding `E` skill depending on the key duration
- `e~` Uses the long press version of `E` skill

### Characters Debut Audio

You can define the character's debut audio , To use this function, you need to reprogram the home directory to create the `audio` folder and define it in configuration.
For Example:

```ini

[ganyu]
on-long-press = a~, a
audio = ganyu.mp3
```

## Note

- All actions are bound to the default key; except `Switch Walk/Run`, which should be changed from `Left Ctrl` to `Right Ctrl`
- The game should run as `16:9` and not less than `1600x900` resolution; no filters can be used
- Since version `0.0.31`, `Celestia` and `World Tree` servers are no longer supported

## Qusetion & Answer

Click [here](./doc/qa.md)

## Disclaimers

You knew that
