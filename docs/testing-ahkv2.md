# AHK v2 Testing

## Purpose

This test setup covers the parts of the new AHK v2 implementation that do not need the game client to be running.

## Scope

Current tests cover:

- runtime primitives
  - event bus
  - service container
  - config store
- domain logic
  - scene detector
  - state rules
  - state detector
- feature logic
  - auto-forward
  - camera control
  - window positioning

The tests use fake services instead of a real game window.

## Layout

```text
tests/
  run_all.ahk
  lib/
    assert.ahk
    test_runner.ahk
  fakes/
    fake_color_service.ahk
    fake_hotkeys.ahk
    fake_hud.ahk
    fake_input_service.ahk
    fake_logger.ahk
    fake_scene_service.ahk
    fake_timers.ahk
    fake_window_service.ahk
  cases/
    feature_tests.ahk
    runtime_tests.ahk
    scene_tests.ahk
    state_tests.ahk
```

## How To Run

On a Windows machine with AutoHotkey v2 installed:

```powershell
AutoHotkey.exe .\tests\run_all.ahk
```

The script exits with:

- `0` when all tests pass
- non-zero when one or more tests fail

## Testing Strategy

### Unit-like tests

Use direct constructor calls for classes with no platform dependency.

### Fake service tests

For detectors and features, replace platform services with fakes that return controlled values.

### Smoke tests

Use separate manual scripts for:

- window lookup
- capture startup
- pixel reads
- input simulation

### Fixture-driven tests

As more detectors are migrated, add image fixtures and run the detector logic against those fixtures instead of a live window.

## Current Limits

- These tests do not validate real GDI capture on Windows.
- These tests do not validate game-specific timing or input feel.
- End-to-end gameplay behavior still requires manual regression.
