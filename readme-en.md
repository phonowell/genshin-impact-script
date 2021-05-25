# genshin-impact-script

Sweet! What a cute Genshin Impact script!

## Introduction

A script based on `AHK` that provides a few small features for Genshin Impact players.

**Does not contain any cheats.**

## Features

### Fast pickup/skip dialogue

Quickly pick up items/skip conversations when `f` key is pressed.

### Better running/jumping

Use better running when long pressing `right click`. Automatically open wind glider when jumping.

### Skill timer

Display the cooldown time and effect duration of `E` skills.

### Logon action

Configurable action when switching characters with `number keys`.

### Custom Tactic Module

You can configure custom battle moves for each character independently, and long press `right click` to cycle through them automatically.

### Process priority adjustment

Set the process priority to the lowest when the game window is inactive.

### Record/replay action

Press `F10` to record your action; press `F11` to replay.

## Usage

**Note that since `0.0.14`, you need to change the `Switch Walk/Run` function from `Left Ctrl` to `Right Ctrl` in the game.**

### Via `.exe`

Go to the unpacked folder and double-click `index.exe` in it (you will be prompted if you want to apply administrator privileges, select Apply).

### Via `.ahk`

First, go to [ahk official website](https://www.autohotkey.com/) and install `AHK` (1.33+, do not use v2 version).

Then, download the [zip file](https://github.com/phonowell/genshin-impact-script/releases/download/0.0.14/Genshin_Impact_Script_EN_0.0.14.zip) and unzip it.

Finally, go to the unzipped folder and double-click `index.ahk` in it (you will be prompted whether to apply administrator privileges, select Apply).

### Skill Timer

Before using this function, you need to identify the characters by the following action: Press `f12` key with the right avatar visible.

After changing the team lineup, you need to re-identify them.

The following characters are not supported right now:

- Aether
- Diluc
- Lumine
- Rosaria
- Yanfei

## Configuration

Refer to the [configuration](./data/config-en.ini) for details.

When finished editing, press `ctrl + f5` to take effect instantly.

### Characters

Add the chanacter name at the bottom of the file to enable character-specific configuration.

For Example:

```ini
[klee]
tactic = a, A

[zhongli]
type-apr = 2
```

#### tactic

Customized tactic module. For details, click [here](./doc/tactic-en.md).

#### type-apr

The type of appearance. Can be one of the following values:

- `0` Off
- `1` Uses the corresponding `E` skill depending on the length of time the number key is pressed
- `2` Uses `E` skill (hold)

## Note

- All actions are bound to the default key; except `Switch Walk/Run`, which should be changed from `left ctrl` to `right ctrl`
- Use `right click` for sprinting, not `left shift`
- The game should run in `16:9` resolution
- Avoid discussing the script in public

## Disclaimers

You knew that.