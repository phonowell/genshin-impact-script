# AHK v2 Manual Smoke Checklist

## Preconditions

- Windows machine
- AutoHotkey v2 installed
- Genshin Impact installed
- `data/config.ini` points to the correct process or executable path

## Boot

1. Run `src-v2/main.ahk`
2. Confirm no immediate crash
3. Confirm tray menu appears
4. Confirm a log file is created in `logs/`

## Core Hotkeys

1. Press `Ctrl+Alt+F12`
2. Confirm smoke logs are written
3. Press `Ctrl+F5`
4. Confirm the script reloads

## Window

1. Launch the game
2. Confirm the script detects the target process
3. Press `Win+Arrow`
4. Confirm the window moves when not fullscreen

## Capture And Detection

1. Bring the game window to the foreground
2. Confirm capture starts without crash
3. Watch logs for scene changes
4. Open menu and map
5. Confirm scene logs change as expected

## Features

### Auto Forward

1. Enter normal gameplay
2. Press `Alt+W`
3. Confirm the script holds `W`
4. Press `W` or `S`
5. Confirm auto-forward stops

### Camera Control

1. Enter normal gameplay
2. Hold arrow keys
3. Confirm camera movement is generated

## Exit

1. Press `Alt+F4`
2. Confirm the script exits cleanly
3. Confirm HUD tips disappear
