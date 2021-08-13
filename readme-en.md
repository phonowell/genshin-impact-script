# genshin-impact-script

Sweet! What a cute Genshin Impact script!

## Introduction

A script based on `AHK` that provides a few small features for Genshin Impact players.

**Does not contain any cheats.**

## Features

### Fast pickup/skip dialogue

Quickly pick up items/skip conversations when `F` key is pressed.

### Skill timer

Display the cooldown time and effect duration of `E` skills.

### Debut action

Configurable action when switching characters with `Number Keys`.

### Custom Tactic Module

You can configure custom battle moves for each character independently, and long press `Left Click` to cycle through them automatically.

### Process priority adjustment

Set the process priority to the lowest when the game window is inactive.

## Usage

**Note that you need to change the `Switch Walk/Run` function from `Left Ctrl` to `Right Ctrl` in the game.**

Download the [zip file](https://github.com/phonowell/genshin-impact-script/releases/download/0.0.19/Genshin_Impact_Script_EN_0.0.19.zip) and unzip it.

Go to the unpacked folder and double-click `start.exe` in it (you will be prompted if you want to apply administrator privileges, select Apply).

### Skill Timer

Before using this function, you need to identify the characters by the following action: Press `F12` key with the right avatar visible.

After changing the team lineup, you need to re-identify them.

The following characters are not supported right now:

- Aether
- Lumine

## Configuration

Refer to the [configuration](./data/config-en.ini) for details.

When finished editing, press `Ctrl + F5` to take effect instantly.

### Characters

Add the chanacter name at the bottom of the file to enable character-specific configuration.

For Example:

```ini
[klee]
on-long-press = a, a~

[zhongli]
on-switch = e~
```

#### on-long-press

Customized tactic module. For details, click [here](./doc/tactic-en.md).

#### on-switch

The type of appearance. Can be one of the following values:

- `e` Uses the corresponding `E` skill depending on the length of time the number key is pressed
- `e~` Uses `E` skill (hold)

## Note

- All actions are bound to the default key; except `Switch Walk/Run`, which should be changed from `Left Ctrl` to `Right Ctrl`
- Use `Right Click` for sprinting, not `Left Shift`
- The game should run in `16:9` resolution
- Avoid discussing the script in public

## FAQ

Click [here](./doc/faq-en.md).

## Disclaimers

You knew that.