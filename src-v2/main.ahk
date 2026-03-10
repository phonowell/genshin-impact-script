#Requires AutoHotkey v2.0
#SingleInstance Force

#Include vendor\Gdip_All.ahk
#Include bootstrap\app.ahk
#Include bootstrap\wiring.ahk
#Include runtime\logger.ahk
#Include runtime\events.ahk
#Include runtime\timer.ahk
#Include runtime\config.ahk
#Include runtime\hud.ahk
#Include runtime\hotkeys.ahk
#Include runtime\services.ahk
#Include platform\graphics\capture_service.ahk
#Include platform\graphics\color_service.ahk
#Include platform\windows\window_service.ahk
#Include platform\windows\input_service.ahk
#Include platform\windows\tray_service.ahk
#Include domain\scene\scene_detector.ahk
#Include domain\state\state_rules.ahk
#Include domain\state\state_detector.ahk
#Include features\movement\auto_forward.ahk
#Include features\movement\camera_control.ahk
#Include features\window\window_position.ahk

rootDir := RegExReplace(A_ScriptDir, "[\\/]+src-v2$")
app := BuildApp(rootDir)
OnExit(ObjBindMethod(app, "HandleExit"))
app.Start()
