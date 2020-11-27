if (A_IsAdmin != true) {
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
}
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

$.delay.Call(1000, Func("genshin_32"))
timer.countDown := ""
global countDown := Func("genshin_24")
global doAs := Func("genshin_23")
global isMoving := Func("genshin_20")
global state := {} ; variable
global timer := {}
global ts := {}
state.isSuspend := false
global resetAll := Func("genshin_19")
global watch := Func("genshin_17")
$.on.Call("alt + f4", Func("genshin_16")) ; binding
setInterval.Call(watch, 200) ; execute
state.isDashing := false
timer.dash := ""
global dash := Func("genshin_15")
global startDash := Func("genshin_14")
global stopDash := Func("genshin_13")
state.isJumping := false
timer.jump := ""
global jumpTwice := Func("genshin_12")
global startJumpBack := Func("genshin_10")
global stopJumpBack := Func("genshin_9")
state.isPicking := false
timer.pick := ""
global pick := Func("genshin_8")
global startPick := Func("genshin_7")
global stopPick := Func("genshin_6")
ts.toggle := 0
global toggle := Func("genshin_5")
state.isViewing := false
timer.view := ""
global toggleView := Func("genshin_3")
global view := Func("genshin_2")
genshin_1() {
  $.click.Call("middle:up")
}
genshin_2() {
  $.click.Call("middle:down")
  setTimeout.Call(Func("genshin_1"), 2500)
}
genshin_3() {
  clearInterval.Call(timer.view)
  state.isViewing := !state.isViewing
  $.click.Call("middle:up")
  if !(state.isViewing) {
    return
  }
  timer.view := setInterval.Call(view, 3000)
  view.Call()
}
genshin_4() {
  $.press.Call("e")
}
genshin_5(key) {
  if !($.now.Call() - ts.toggle > 1000) {
    $.beep.Call()
    return
  }
  ts.toggle := $.now.Call()
  $.press.Call(key)
  doAs.Call(Func("genshin_4"), 2, 100, 100)
  countDown.Call(5000)
}
genshin_6() {
  if !(state.isPicking) {
    return
  }
  state.isPicking := false
  clearInterval.Call(timer.pick)
}
genshin_7() {
  if (state.isPicking) {
    return
  }
  state.isPicking := true
  clearInterval.Call(timer.pick)
  timer.pick := setInterval.Call(pick, 100)
  pick.Call()
}
genshin_8() {
  $.press.Call("f")
  $.click.Call("wheel-down")
}
genshin_9() {
  if !(state.isJumping) {
    return
  }
  state.isJumping := false
  clearTimeout.Call(timer.jump)
}
genshin_10() {
  if (state.isJumping) {
    return
  }
  state.isJumping := true
  $.press.Call("x")
  timer.jump := $.delay.Call(100, jumpTwice)
}
genshin_11() {
  $.press.Call("space")
}
genshin_12() {
  $.press.Call("space")
  doAs.Call(Func("genshin_11"), 2, 100, 200)
}
genshin_13() {
  if !(state.isDashing) {
    return
  }
  state.isDashing := false
  clearInterval.Call(timer.dash)
  key := isMoving.Call()
  if !(key) {
    $.press.Call("w:up")
  } else if (key != "w") {
    $.press.Call("w:up")
  }
}
genshin_14() {
  if (state.isDashing) {
    return
  }
  state.isDashing := true
  clearInterval.Call(timer.dash)
  timer.dash := setInterval.Call(dash, 1300)
  dash.Call()
}
genshin_15() {
  key := isMoving.Call()
  if !(key) {
    $.press.Call("w:down")
  } else if (key != "w") {
    $.press.Call("w:up")
  }
  $.click.Call("right")
}
genshin_16() {
  resetAll.Call()
  $.beep.Call()
  $.exit.Call()
}
genshin_17() {
  if (!state.isSuspend && !WinActive("ahk_exe YuanShen.exe")) {
    state.isSuspend := true
    $.suspend.Call(true)
    resetAll.Call()
    Process, Priority, YuanShen.exe, Low
    return
  }
  if (state.isSuspend && WinActive("ahk_exe YuanShen.exe")) {
    state.isSuspend := false
    $.suspend.Call(false)
    Process, Priority, YuanShen.exe, Normal
    return
  }
}
genshin_18() {
  for __i__, key in ["middle", "right"] {
    if ($.getState.Call(key)) {
      $.click.Call("" . (key) . ":up")
    }
  }
  for __i__, key in ["e", "f", "s", "space", "w", "x"] {
    if ($.getState.Call(key)) {
      $.press.Call("" . (key) . ":up")
    }
  }
}
genshin_19() {
  Process, Priority, YuanShen.exe, Normal
  for __i__, _timer in timer {
    clearTimeout.Call(_timer)
  }
  $.delay.Call(200, Func("genshin_18"))
}
genshin_20() {
  for __i__, key in ["w", "a", "s", "d"] {
    if ($.getState.Call(key)) {
      return key
    }
  }
  return false
}
genshin_21(n, callback) {
  callback.Call(n)
}
genshin_22(callback, limit, interval) {
  doAs.Call(callback, limit, interval, 0)
}
genshin_23(callback, limit := 1, interval := 100, delay := 0) {
  if (delay) {
    $.delay.Call(delay, Func("genshin_22").Bind(callback, limit, interval))
    return
  }
  n := 1
  while (n <= limit) {
    $.delay.Call((n - 1) * interval, Func("genshin_21").Bind(n, callback))
    n++
  }
}
genshin_24(time) {
  clearTimeout.Call(timer.countDown)
  timer.countDown := $.delay.Call(time, $.beep)
}
genshin_25() {
  if (state.isDashing) {
    return
  }
  $.press.Call("w:up")
}
genshin_26() {
  $.press.Call("w:down")
}
genshin_27() {
  $.press.Call("s:up")
  stopJumpBack.Call()
}
genshin_28() {
  $.press.Call("s:down")
  startJumpBack.Call()
}
genshin_29() {
  $.press.Call("e:up")
  countDown.Call(5000)
}
genshin_30() {
  $.press.Call("e:down")
}
genshin_31(key) {
  toggle.Call(key)
}
genshin_32() {
  for __i__, key in ["1", "2", "3", "4", "5"] {
    $.on.Call(key, Func("genshin_31").Bind(key))
  }
  $.on.Call("e", Func("genshin_30"))
  $.on.Call("e:up", Func("genshin_29"))
  $.on.Call("f", startPick)
  $.on.Call("f:up", stopPick)
  $.on.Call("mbutton", toggleView)
  $.on.Call("rbutton", startDash)
  $.on.Call("rbutton:up", stopDash)
  $.on.Call("s", Func("genshin_28"))
  $.on.Call("s:up", Func("genshin_27"))
  $.on.Call("space", jumpTwice)
  $.on.Call("w", Func("genshin_26"))
  $.on.Call("w:up", Func("genshin_25"))
}
