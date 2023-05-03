
XInput_Init(dll="xinput1_3")
{
  global
  if _XInput_hm
    return

  XINPUT_DEVTYPE_GAMEPAD := 0x01
  XINPUT_DEVSUBTYPE_GAMEPAD := 0x01
  XINPUT_CAPS_VOICE_SUPPORTED := 0x0004
  XINPUT_GAMEPAD_DPAD_UP := 0x0001
  XINPUT_GAMEPAD_DPAD_DOWN := 0x0002
  XINPUT_GAMEPAD_DPAD_LEFT := 0x0004
  XINPUT_GAMEPAD_DPAD_RIGHT := 0x0008
  XINPUT_GAMEPAD_START := 0x0010
  XINPUT_GAMEPAD_BACK := 0x0020
  XINPUT_GAMEPAD_LEFT_THUMB := 0x0040
  XINPUT_GAMEPAD_RIGHT_THUMB := 0x0080
  XINPUT_GAMEPAD_LEFT_SHOULDER := 0x0100
  XINPUT_GAMEPAD_RIGHT_SHOULDER := 0x0200
  XINPUT_GAMEPAD_A := 0x1000
  XINPUT_GAMEPAD_B := 0x2000
  XINPUT_GAMEPAD_X := 0x4000
  XINPUT_GAMEPAD_Y := 0x8000
  XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE := 7849
  XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE := 8689
  XINPUT_GAMEPAD_TRIGGER_THRESHOLD := 30
  XINPUT_FLAG_GAMEPAD := 0x00000001
  _XInput_hm := DllCall("LoadLibrary" ,"str",dll)
  if !_XInput_hm
  {
    MsgBox, Failed to initialize XInput: %dll%.dll not found.
    return
  }
  _XInput_GetState := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"astr","XInputGetState")
  _XInput_SetState := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"astr","XInputSetState")
  _XInput_GetCapabilities := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"astr","XInputGetCapabilities")
  if !(_XInput_GetState && _XInput_SetState && _XInput_GetCapabilities)
  {
    XInput_Term()
    MsgBox, Failed to initialize XInput: function not found.
    return
  }
}
XInput_GetState(UserIndex)
{
  global _XInput_GetState
  VarSetCapacity(xiState,16)
  if ErrorLevel := DllCall(_XInput_GetState ,"uint",UserIndex ,"uint",&xiState)
    return 0
  return {
    (Join,
    dwPacketNumber: NumGet(xiState, 0, "UInt")
    wButtons: NumGet(xiState, 4, "UShort")
    bLeftTrigger: NumGet(xiState, 6, "UChar")
    bRightTrigger: NumGet(xiState, 7, "UChar")
    sThumbLX: NumGet(xiState, 8, "Short")
    sThumbLY: NumGet(xiState, 10, "Short")
    sThumbRX: NumGet(xiState, 12, "Short")
    sThumbRY: NumGet(xiState, 14, "Short")
  )}
}
XInput_SetState(UserIndex, LeftMotorSpeed, RightMotorSpeed)
{
  global _XInput_SetState
  return DllCall(_XInput_SetState ,"uint",UserIndex ,"uint*",LeftMotorSpeed|RightMotorSpeed<<16)
}
XInput_GetCapabilities(UserIndex, Flags)
{
  global _XInput_GetCapabilities
  VarSetCapacity(xiCaps,20)
  if ErrorLevel := DllCall(_XInput_GetCapabilities ,"uint",UserIndex ,"uint",Flags ,"ptr",&xiCaps)
    return 0
  return,
  (Join
  {
    Type: NumGet(xiCaps, 0, "UChar"),
    SubType: NumGet(xiCaps, 1, "UChar"),
    Flags: NumGet(xiCaps, 2, "UShort"),
    Gamepad:
      {
        wButtons: NumGet(xiCaps, 4, "UShort"),
        bLeftTrigger: NumGet(xiCaps, 6, "UChar"),
        bRightTrigger: NumGet(xiCaps, 7, "UChar"),
        sThumbLX: NumGet(xiCaps, 8, "Short"),
        sThumbLY: NumGet(xiCaps, 10, "Short"),
        sThumbRX: NumGet(xiCaps, 12, "Short"),
        sThumbRY: NumGet(xiCaps, 14, "Short")
      },
    Vibration:
      {
        wLeftMotorSpeed: NumGet(xiCaps, 16, "UShort"),
        wRightMotorSpeed: NumGet(xiCaps, 18, "UShort")
      }
    }
    )
  }
  XInput_Term() {
    global
    if _XInput_hm
      DllCall("FreeLibrary","uint",_XInput_hm), _XInput_hm :=_XInput_GetState :=_XInput_SetState :=_XInput_GetCapabilities :=0
  }