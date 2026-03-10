#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ..\src-v2\runtime\events.ahk
#Include ..\src-v2\runtime\config.ahk
#Include ..\src-v2\runtime\services.ahk
#Include ..\src-v2\domain\scene\scene_detector.ahk
#Include ..\src-v2\domain\state\state_rules.ahk
#Include ..\src-v2\domain\state\state_detector.ahk
#Include ..\src-v2\features\movement\auto_forward.ahk
#Include ..\src-v2\features\movement\camera_control.ahk
#Include ..\src-v2\features\window\window_position.ahk

#Include lib\assert.ahk
#Include lib\test_runner.ahk
#Include fakes\fake_hotkeys.ahk
#Include fakes\fake_input_service.ahk
#Include fakes\fake_hud.ahk
#Include fakes\fake_logger.ahk
#Include fakes\fake_timers.ahk
#Include fakes\fake_window_service.ahk
#Include fakes\fake_color_service.ahk
#Include fakes\fake_scene_service.ahk
#Include cases\runtime_tests.ahk
#Include cases\scene_tests.ahk
#Include cases\state_tests.ahk
#Include cases\feature_tests.ahk

runner := TestRunner()
RegisterRuntimeTests(runner)
RegisterSceneTests(runner)
RegisterStateTests(runner)
RegisterFeatureTests(runner)
ExitApp(runner.Run())
