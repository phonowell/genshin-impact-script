#KeyHistory, 0
#MaxThreads, 20
#NoEnv
#Persistent
#SingleInstance, Force
#UseHook, On

CoordMode, Mouse, Client
CoordMode, Pixel, Client
CoordMode, ToolTip, Client
SendMode, Event
SetBatchLines, 100ms
SetKeyDelay, 0, 50
SetMouseDelay, 0, 50
StringCaseSense, On
global $ := {}
$.beep := Func("jsShim_44")
$.click := Func("jsShim_43")
$.delay := Func("jsShim_42")
$.exit := Func("jsShim_41")
$.findColor := Func("jsShim_40")
$.findImage := Func("jsShim_39")
$.formatHotkey := Func("jsShim_38")
$.getColor := Func("jsShim_37")
$.getPosition := Func("jsShim_36")
$.getState := Func("jsShim_35")
$.i := Func("jsShim_34")
$.includes := Func("jsShim_33")
$.info := Func("jsShim_32")
$.length := Func("jsShim_31")
$.move := Func("jsShim_30")
$.now := Func("jsShim_29")
$.off := Func("jsShim_28")
$.on := Func("jsShim_27")
$.open := Func("jsShim_26")
$.press := Func("jsShim_25")
$.random := Func("jsShim_24")
$.reload := Func("jsShim_23")
$.replace := Func("jsShim_22")
$.reverse := Func("jsShim_21")
$.setFixed := Func("jsShim_20")
$.sleep := Func("jsShim_19")
$.split := Func("jsShim_18")
$.suspend := Func("jsShim_17")
$.toLowerCase := Func("jsShim_16")
$.toString := Func("jsShim_15")
$.toUpperCase := Func("jsShim_14")
$.trim := Func("jsShim_13")
$.trimEnd := Func("jsShim_12")
$.trimStart := Func("jsShim_11")
$.type := Func("jsShim_10")
global alert := Func("jsShim_9")
global clearInterval := Func("jsShim_8")
global clearTimeout := Func("jsShim_7")
global Math := {abs: Func("jsShim_6"), ceil: Func("jsShim_5"), floor: Func("jsShim_4"), round: Func("jsShim_3")}
global setInterval := Func("jsShim_2")
global setTimeout := Func("jsShim_1")
jsShim_1(callback, time) {
  if (($.type.Call(callback)) == "function") {
    callback := callback.Bind()
  }
  __type__ := $.type.Call(time)
  if !(__type__ == "number") {
    throw Exception("setTimeout: invalid time type '" . (__type__) . "'")
  }
  if (time == 0) {
    time++
  }
  if !(time > 0) {
    throw Exception("setTimeout: invalid time value '" . (time) . "'")
  }
  SetTimer, % callback, % 0 - time
  return callback
}
jsShim_2(callback, time) {
  if (($.type.Call(callback)) == "function") {
    callback := callback.Bind()
  }
  __type__ := $.type.Call(time)
  if !(__type__ == "number") {
    throw Exception("setTimeout: invalid time type '" . (__type__) . "'")
  }
  if !(time > 0) {
    throw Exception("setTimeout: invalid time value '" . (time) . "'")
  }
  SetTimer, % callback, % time
  return callback
}
jsShim_3(n) {
  return Round(n)
}
jsShim_4(n) {
  return Floor(n)
}
jsShim_5(n) {
  return Ceil(n)
}
jsShim_6(n) {
  return Abs(n)
}
jsShim_7(callback) {
  if !(callback) {
    return
  }
  SetTimer, % callback, Delete
}
jsShim_8(callback) {
  if !(callback) {
    return
  }
  SetTimer, % callback, Delete
}
jsShim_9(message := "") {
  __msg__ := $.toString.Call(message)
  MsgBox, % __msg__
}
jsShim_10(input) {
  if input is Number
    return "number"
  if (IsFunc(input)) {
    return "function"
  }
  if (IsObject(input)) {
    if (input.Count() == input.Length()) {
      return "array"
    }
    return "object"
  }
  return "string"
}
jsShim_11(input, omitting := " `t") {
  return LTrim(input, omitting)
}
jsShim_12(input, omitting := " `t") {
  return RTrim(input, omitting)
}
jsShim_13(input, omitting := " `t") {
  return Trim(input, omitting)
}
jsShim_14(input) {
  StringUpper, __Result__, input
  return __Result__
}
jsShim_15(input) {
  _type := $.type.Call(input)
  if (_type == "array") {
    _result := ""
    for __i__, key in input {
      _result := "" . (_result) . ", " . ($.toString.Call(key)) . ""
    }
    return "[" . ($.trim.Call(_result, " ,")) . "]"
  } else if (_type == "object") {
    _result := ""
    for key, value in input {
      _result := "" . (_result) . ", " . (key) . ": " . ($.toString.Call(value)) . ""
    }
    return "{" . ($.trim.Call(_result, " ,")) . "}"
  }
  return input
}
jsShim_16(input) {
  StringLower, __Result__, input
  return __Result__
}
jsShim_17(isSuspended := "Toggle") {
  if (isSuspended != "Toggle") {
    if (isSuspended) {
      isSuspended := "On"
    } else {
      isSuspended := "Off"
    }
  }
  Suspend, % isSuspended
}
jsShim_18(input, delimiter) {
  return StrSplit(input, delimiter)
}
jsShim_19(time) {
  Sleep, % time
}
jsShim_20(isFixed := "Toggle") {
  if (isFixed != "Toggle") {
    if (isFixed) {
      isFixed := "On"
    } else {
      isFixed := "Off"
    }
  }
  Winset AlwaysOnTop, % isFixed, A
}
jsShim_21(input) {
  _type := $.type.Call(input)
  if !(_type == "array") {
    throw Exception("$.reverse: invalid type '" . (_type) . "'")
  }
  _len := $.length.Call(input)
  _output := []
  for i, key in input {
    _output[_len - i + 1] := key
  }
  return _output
}
jsShim_22(input, searchment, replacement, limit := -1) {
  return StrReplace(input, searchment, replacement, limit)
}
jsShim_23() {
  Reload
}
jsShim_24(min := 0, max := 1) {
  Random, __Result__, min, max
  return __Result__
}
jsShim_25(listInput*) {
  if !($.length.Call(listInput)) {
    throw Exception("$.press: invalid key")
  }
  _listKey := []
  for __i__, input in listInput {
    _input := $.toLowerCase.Call(input)
    _input := $.replace.Call(_input, " ", "")
    _input := $.replace.Call(_input, "-", "")
    _list := $.split.Call(_input, "+")
    for __i__, it in _list {
      _listKey.Push(it)
    }
  }
  _listResult := []
  _len := $.length.Call(_listKey)
  for i, key in _listKey {
    if (i == _len) {
      _listResult[i] := $.split.Call(key, ":")
      continue
    }
    if ($.includes.Call(key, ":")) {
      _listResult[i] := $.split.Call(key, ":")
      _listResult[_len * 2 - i] := $.split.Call(key, ":")
    } else {
      _listResult[i] := [key, "down"]
      _listResult[_len * 2 - i] := [key, "up"]
    }
  }
  for i, it in _listResult {
    if (it[1] == "win") {
      it[1] := "lwin"
    }
    _listResult[i] := $.trim.Call("" . (it[1]) . " " . (it[2]) . "")
  }
  _output := ""
  for __i__, it in _listResult {
    _output := "" . (_output) . "{" . (it) . "}"
  }
  Send, % _output
}
jsShim_26(source) {
  Run, % source
}
jsShim_27(key, callback) {
  key := $.formatHotkey.Call(key)
  Hotkey, % key, % callback, On
}
jsShim_28(key, callback) {
  key := $.formatHotkey.Call(key)
  Hotkey, % key, % callback, Off
}
jsShim_29() {
  return A_TickCount
}
jsShim_30(point := "", speed := 0) {
  if !(point) {
    throw Exception("$.move: invalid point")
  }
  MouseMove, point[1], point[2], speed
}
jsShim_31(input) {
  _type := $.type.Call(input)
  switch _type {
    case "array": {
      return input.Length()
    }
    case "object": {
      return input.Count()
    }
    case "string": {
      return StrLen(input)
    }
    default: {
      throw Exception("$.length: invalid type '" . (_type) . "'")
    }
  }
}
jsShim_32(message, point := "") {
  if !(message) {
    return message
  }
  if !(point) {
    point := $.getPosition.Call()
  }
  _msg := $.toString.Call(message)
  ToolTip, % _msg, % point[1], % point[2]
  return message
}
jsShim_33(input, needle) {
  _type := $.type.Call(input)
  if (_type == "string" || _type == "number") {
    return (InStr(input, needle)) > 0
  }
  if (_type == "array") {
    for __i__, it in input {
      if (it == needle) {
        return true
      }
    }
    return false
  }
  throw Exception("$.includes: invalid type '" . (_type) . "'")
}
jsShim_34(message) {
  $.info.Call("" . ($.now.Call()) . " " . ($.toString.Call(message)) . "")
  return message
}
jsShim_35(key) {
  return GetKeyState(key, "P")
}
jsShim_36() {
  MouseGetPos, __x__, __y__
  return [__x__, __y__]
}
jsShim_37(point := "") {
  if !(point) {
    point := $.getPosition.Call()
  }
  PixelGetColor, __Result__, % point[1], % point[2], RGB
  return __Result__
}
jsShim_38(key) {
  _listKey := []
  _key := $.toLowerCase.Call(key)
  _key := $.replace.Call(_key, " ", "")
  _key := $.replace.Call(_key, "-", "")
  _list := $.split.Call(_key, "+")
  for __i__, it in _list {
    _listKey.Push(it)
  }
  _isAlt := false
  _isCtrl := false
  _isShift := false
  _isWin := false
  _listResult := []
  for __i__, key in _listKey {
    if (key == "alt") {
      _isAlt := true
      continue
    }
    if (key == "ctrl") {
      _isCtrl := true
      continue
    }
    if (key == "shift") {
      _isShift := true
      continue
    }
    if (key == "win") {
      _isWin := true
      continue
    }
    _listResult.Push(key)
  }
  _prefix := ""
  if (_isAlt) {
    _prefix := "" . (_prefix) . "!"
  }
  if (_isCtrl) {
    _prefix := "" . (_prefix) . "^"
  }
  if (_isShift) {
    _prefix := "" . (_prefix) . "+"
  }
  if (_isWin) {
    _prefix := "" . (_prefix) . "#"
  }
  _result := ""
  for __i__, it in _listResult {
    _result := "" . (_result) . " & " . (it) . ""
  }
  return $.replace.Call("" . (_prefix) . "" . ($.trim.Call(_result, " &")) . "", ":", " ")
}
jsShim_39(source, start := "", end := "") {
  if !(start) {
    start := [0, 0]
  }
  if !(end) {
    end := [A_ScreenWidth, A_ScreenHeight]
  }
  ImageSearch __x__, __y__, start[1], start[2], end[1], end[2], % A_ScriptDir . "\\\" . source
  return [__x__, __y__]
}
jsShim_40(color, start := "", end := "", variation := 0) {
  if !(start) {
    start := [0, 0]
  }
  if !(end) {
    end := [A_ScreenWidth, A_ScreenHeight]
  }
  PixelSearch __x__, __y__, start[1], start[2], end[1], end[2], color, variation, Fast RGB
  return [__x__, __y__]
}
jsShim_41() {
  ExitApp
}
jsShim_42(time, callback) {
  __timer__ := setTimeout.Call(callback, time)
  return __timer__
}
jsShim_43(key := "left") {
  key := $.replace.Call(key, "-", "")
  key := $.replace.Call(key, ":", " ")
  Click, % key
}
jsShim_44() {
  SoundBeep
}

class ProcessX {
  id := 0
  isExisting := false
  target := ""
  close := Func("z_4").Bind(this)
  exist := Func("z_3").Bind(this)
  setPriority := Func("z_2").Bind(this)
}
$.process := Func("z_1")
global notepad := $.process("notepad.exe")
alert.Call(notepad)
z_1(target) {
  __process := new ProcessX()
  __process.target := target
  return __process
}
z_2(this, level) {
  target := this.id || this.target
  Process, Priority, % target, % level
}
z_3(this) {
  target := this.id || this.target
  Process, Exist, % target
  return ErrorLevel
}
z_4(this) {
  target := this.id || this.target
  Process, Close, % target
}
