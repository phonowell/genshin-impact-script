# GIS AHK v2 Architecture

## Goals

- Replace `coffee-ahk` and `shell-ahk` with direct `AutoHotkey v2` source.
- Keep the repo self-contained.
- Make platform code explicit and isolated.
- Make feature code depend on stable runtime services instead of global helpers.

## Layering

### Bootstrap

Purpose:

- Own startup order.
- Build the app context.
- Wire services and core hotkeys.

Files:

- `src-v2/main.ahk`
- `src-v2/bootstrap/app.ahk`
- `src-v2/bootstrap/wiring.ahk`

Rules:

- Bootstrap may reference runtime and platform layers.
- Bootstrap must not contain game feature logic.

### Runtime

Purpose:

- Provide reusable infrastructure with no Genshin-specific rules.

Core modules:

- `logger`
- `services`
- `events`
- `timer`
- `config`
- `hotkeys`

Rules:

- Runtime modules must not call scene detectors or feature modules.
- Runtime should be testable in isolation.

### Platform

Purpose:

- Wrap Windows and graphics APIs behind explicit classes.

Sub-layers:

- `platform/windows`
- `platform/graphics`
- `platform/storage`

Examples:

- window focus and bounds
- tray interactions
- screenshot capture
- color reads
- ini/json persistence
- controller input

Rules:

- Platform modules may depend on runtime.
- Platform modules must not depend on feature modules.
- Raw Win32 or legacy library calls stay here, not in domain or feature code.

### Domain

Purpose:

- Represent game-specific state and reasoning.

Examples:

- scene detection
- state detection
- party detection
- character metadata
- combat state

Rules:

- Domain may depend on runtime and platform.
- Domain should return state facts, not trigger hotkeys directly.

### Features

Purpose:

- Execute user-facing behavior using domain facts and platform services.

Examples:

- pickup
- fishing
- camera assist
- movement assist
- skill logic
- tactic runner
- recorder
- replayer

Rules:

- Features may depend on runtime, platform, and domain.
- Features must not bypass domain by hardcoding state checks with raw pixel calls.

## Dependency Direction

Allowed:

- bootstrap -> runtime
- bootstrap -> platform
- bootstrap -> domain
- bootstrap -> features
- platform -> runtime
- domain -> runtime
- domain -> platform
- features -> runtime
- features -> platform
- features -> domain

Forbidden:

- runtime -> platform
- runtime -> domain
- runtime -> features
- platform -> features
- domain -> features

## Service Boundaries

### App Context

The app context owns:

- root paths
- service container
- startup state
- shutdown state

It should expose only stable service lookups and lifecycle hooks.

### Logger

Responsibilities:

- debug/info/error logging
- optional file output
- consistent formatting

Non-goals:

- user HUD rendering

### Config Store

Responsibilities:

- read and write `data/config.ini`
- typed helpers for bool and string values
- defaults for known keys

Non-goals:

- scene or character data loading

### Event Bus

Responsibilities:

- cross-service notifications
- one-to-many state events

Non-goals:

- global callback soup

### Timer Registry

Responsibilities:

- own named timers
- prevent duplicate registration
- support one-shot and repeating timers

Non-goals:

- hidden background loops spread across feature code

### Hotkey Registry

Responsibilities:

- centralize hotkey registration
- enable and disable groups during app lifecycle

Non-goals:

- direct business logic inside hotkey handlers

### Window Service

Responsibilities:

- identify the game window
- query active state and bounds
- focus, close, minimize, and detect fullscreen

Non-goals:

- scene detection

## Initialization Flow

1. `main.ahk` computes the repo root and builds the app.
2. Wiring registers runtime and platform services.
3. App loads config and updates debug settings.
4. App initializes tray and core hotkeys.
5. App checks for the target game process.
6. Later phases attach domain services and feature services.

## Migration Principles

### Preserve behavior, not structure

The old Coffee files are reference material. They are not the target design.

### Replace giant globals with explicit services

The old `$` helper and singleton mesh are not carried forward.

### Keep raw native calls at the edges

Window, GDI, XInput, and tray specifics belong in platform adapters only.

### Prefer named state over implicit polling

Polling still exists where needed, but it should be visible and owned by a detector or feature service.

### Make the repo self-contained

No direct dependency on sibling repos for build or runtime data.

## Planned Runtime Layout

```text
src-v2/
  main.ahk
  bootstrap/
    app.ahk
    wiring.ahk
  runtime/
    config.ahk
    events.ahk
    hotkeys.ahk
    logger.ahk
    services.ahk
    timer.ahk
  platform/
    windows/
      tray_service.ahk
      window_service.ahk
```

This is the minimum stable base before graphics, scene detection, and gameplay features are ported.

## Current Implementation Status

Implemented in the new tree:

- bootstrap and service wiring
- logger, config, events, timers, hotkeys
- window, tray, input, cached capture, and color services
- scene detector
- state detector
- repo-owned state color rules via `data/state-colors.ini`
- first migrated features:
  - auto-forward
  - camera control
  - window positioning

Still missing for a usable replacement:

- screenshot/GDI performance and parity validation with the legacy implementation
- party and character recognition
- combat, pickup, fishing, recorder, replayer, camera, and HUD parity
- real-world validation under AutoHotkey v2 on Windows

## Testability

The new codebase is being structured so that:

- runtime services can be tested directly
- detectors can run against fake color and window services
- feature logic can be verified without a live game client where possible

See `docs/testing-ahkv2.md` and `tests/run_all.ahk`.
