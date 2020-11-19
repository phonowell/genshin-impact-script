if (A_IsAdmin != true) {
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
}
#KeyHistory, 0
#MaxHotkeysPerInterval, 200
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
$.reverse := Func("jsShim_44") ; reverse(input: unknown[]): unknown[]
$.includes := Func("jsShim_43")
$.length := Func("jsShim_42") ; length(input: string | array | object): number
$.type := Func("jsShim_41") ; type(input: unknown): 'array' | 'function' | 'number' | 'object' | 'string'
$.findColor := Func("jsShim_40") ; findColor( color: number, start: Point = [0, 0], end: Point = [A_ScreenWidth, A_ScreenHeight], variation = 0 ): Point
$.findImage := Func("jsShim_39") ; findImage( source: string, start: Point = [0, 0], end: Point = [A_ScreenWidth, A_ScreenHeight], ): Point
$.getColor := Func("jsShim_38") ; getColor(point?: Point): number
$.getPosition := Func("jsShim_37") ; getPosition(): Point
$.getState := Func("jsShim_36") ; getState(key: string): string
$.formatHotkey := Func("jsShim_35") ; formatHotkey(key: string): string
$.now := Func("jsShim_34") ; now(): number
$.random := Func("jsShim_33") ; random(min: number = 0, max: number = 1): number
$.click := Func("jsShim_32") ; click(key?: string): void
$.move := Func("jsShim_31") ; move(point: Point, speed: number = 0): void
$.press := Func("jsShim_30") ; press(key...: string): void
$.setFixed := Func("jsShim_29") ; setFixed(fixed?: boolean): void
$.beep := Func("jsShim_28") ; beep(): void
$.i := Func("jsShim_27") ; i(message: string): string
$.info := Func("jsShim_26") ; info(message: string, point?: Point): string
$.replace := Func("jsShim_25") ; replace( input: string, searchment: string, replacement: string, limit: number = -1 )
$.split := Func("jsShim_24") ; split(input: string, delimiter: string): string
$.toLowerCase := Func("jsShim_23") ; toLowerCase(input: string): string
$.toString := Func("jsShim_22") ; toString(input: unknown): string
$.toUpperCase := Func("jsShim_21") ; toUpperCase(input: string): string
$.trim := Func("jsShim_20") ; trim(input: string, omitting: string): string
$.trimEnd := Func("jsShim_19") ; trimEnd(input: string, omitting: string): string
$.trimStart := Func("jsShim_18") ; trimStart(input: string, omitting: string): string
$.delay := Func("jsShim_17") ; delay(time: number, callback: Function): string
$.exit := Func("jsShim_16") ; exit(): void
$.off := Func("jsShim_15") ; off(key: string, callback: Function): void
$.on := Func("jsShim_14") ; on(key, string, callback: Function): void
$.open := Func("jsShim_13") ; open(source: string): void
$.reload := Func("jsShim_12") ; reload(): void
$.sleep := Func("jsShim_11") ; sleep(time: number): void
$.suspend := Func("jsShim_10") ; suspend(suspended?: boolean): void
global Math := {abs: Func("jsShim_9"), ceil: Func("jsShim_8"), floor: Func("jsShim_7"), round: Func("jsShim_6")} ; abs(n: number): number ceil(n: number): number floor(n: number): number round(n: number): number
global alert := Func("jsShim_5") ; alert(message: string): string
global clearInterval := Func("jsShim_4") ; clearInterval(callback: Function): void
global clearTimeout := Func("jsShim_3") ; clearTimeout(callback: Function): void
global setInterval := Func("jsShim_2") ; setInterval(callback: Function, time: number): string
global setTimeout := Func("jsShim_1") ; setTimeout(callback: Function, time: number): string
jsShim_1(callback, time) {
  if (($.type.Call(callback)) == "function") {
    callback := callback.Bind()
  }
  SetTimer, % callback, % 0 - time
  return callback
}
jsShim_2(callback, time) {
  if (($.type.Call(callback)) == "function") {
    callback := callback.Bind()
  }
  SetTimer, % callback, % time
  return callback
}
jsShim_3(callback) {
  SetTimer, % callback, Delete
}
jsShim_4(callback) {
  SetTimer, % callback, Delete
}
jsShim_5(message := "") {
  if !(message) {
    return
  }
  _msg := $.toString.Call(message)
  MsgBox, % _msg
  return message
}
jsShim_6(n) {
  return Round(n)
}
jsShim_7(n) {
  return Floor(n)
}
jsShim_8(n) {
  return Ceil(n)
}
jsShim_9(n) {
  return Abs(n)
}
jsShim_10(isSuspended := "Toggle") {
  if (isSuspended != "Toggle") {
    if (isSuspended) {
      isSuspended := "On"
    } else {
      isSuspended := "Off"
    }
  }
  Suspend, % isSuspended
}
jsShim_11(time) {
  Sleep, % time
}
jsShim_12() {
  Reload
}
jsShim_13(source) {
  Run, % source
}
jsShim_14(key, callback) {
  key := $.formatHotkey.Call(key)
  Hotkey, % key, % callback, On
}
jsShim_15(key, callback) {
  key := $.formatHotkey.Call(key)
  Hotkey, % key, % callback, Off
}
jsShim_16() {
  ExitApp
}
jsShim_17(time, callback) {
  __timer__ := setTimeout.Call(callback, time)
  return __timer__
}
jsShim_18(input, omitting := " `t") {
  return LTrim(input, omitting)
}
jsShim_19(input, omitting := " `t") {
  return RTrim(input, omitting)
}
jsShim_20(input, omitting := " `t") {
  return Trim(input, omitting)
}
jsShim_21(input) {
  StringUpper, __Result__, input
  return __Result__
}
jsShim_22(input) {
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
jsShim_23(input) {
  StringLower, __Result__, input
  return __Result__
}
jsShim_24(input, delimiter) {
  return StrSplit(input, delimiter)
}
jsShim_25(input, searchment, replacement, limit := -1) {
  return StrReplace(input, searchment, replacement, limit)
}
jsShim_26(message, point := "") {
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
jsShim_27(message) {
  $.info.Call("" . ($.now.Call()) . " " . ($.toString.Call(message)) . "")
  return message
}
jsShim_28() {
  SoundBeep
}
jsShim_29(isFixed := "Toggle") {
  if (isFixed != "Toggle") {
    if (isFixed) {
      isFixed := "On"
    } else {
      isFixed := "Off"
    }
  }
  Winset AlwaysOnTop, % isFixed, A
}
jsShim_30(listInput*) {
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
jsShim_31(point := "", speed := 0) {
  if !(point) {
    throw Exception("$.move: invalid point")
  }
  MouseMove, point[1], point[2], speed
}
jsShim_32(key := "left") {
  key := $.replace.Call(key, "-", "")
  key := $.replace.Call(key, ":", " ")
  Click, % key
}
jsShim_33(min := 0, max := 1) {
  Random, __Result__, min, max
  return __Result__
}
jsShim_34() {
  return A_TickCount
}
jsShim_35(key) {
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
jsShim_36(key) {
  return GetKeyState(key)
}
jsShim_37() {
  MouseGetPos, __X__, __Y__
  return [__X__, __Y__]
}
jsShim_38(point := "") {
  if !(point) {
    point := $.getPosition.Call()
  }
  PixelGetColor, __Result__, % point[1], % point[2], RGB
  return __Result__
}
jsShim_39(source, start := "", end := "") {
  if !(start) {
    start := [0, 0]
  }
  if !(end) {
    end := [A_ScreenWidth, A_ScreenHeight]
  }
  ImageSearch __x__, __Y__, start[1], start[2], end[1], end[2], % A_ScriptDir . "\\\" . source
  return [__X__, __Y__]
}
jsShim_40(color, start := "", end := "", variation := 0) {
  if !(start) {
    start := [0, 0]
  }
  if !(end) {
    end := [A_ScreenWidth, A_ScreenHeight]
  }
  PixelSearch __X__, __Y__, start[1], start[2], end[1], end[2], color, variation, Fast RGB
  return [__X__, __Y__]
}
jsShim_41(input) {
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
jsShim_42(input) {
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
jsShim_43(input, needle) {
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
jsShim_44(input) {
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
global bind := Func("genshin_24")
global $dataDoAs := {count: 0, fn: "", interval: 0, limit: 1}
global doAs := Func("genshin_17")
global id := "" ; variable
global isSuspend := false
global timer := ""
global init := Func("genshin_15") ; function
global watch := Func("genshin_14")
$.on.Call("f1", init) ; binding
$.on.Call("alt + f4", Func("genshin_13"))
global isDashing := false
global timerDash := ""
global dash := Func("genshin_12")
global startDash := Func("genshin_11")
global stopDash := Func("genshin_10")
global isJumping := false
global timerJump := ""
global jumpTwice := Func("genshin_9")
global startJumpBack := Func("genshin_7")
global stopJumpBack := Func("genshin_6")
global timerToggle := ""
global tsToggle := 0
global toggle := Func("genshin_5")
global isViewing := false
global timerView := ""
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
  clearInterval.Call(timerView)
  isViewing := !isViewing
  $.click.Call("middle:up")
  if !(isViewing) {
    return
  }
  timerView := setInterval.Call(view, 3000)
  view.Call()
}
genshin_4() {
  $.press.Call("e")
}
genshin_5(key) {
  if !($.now.Call() - tsToggle > 1000) {
    $.beep.Call()
    return
  }
  tsToggle := $.now.Call()
  $.press.Call(key)
  doAs.Call(Func("genshin_4"), 100, 2, 100)
  clearTimeout.Call(timerToggle)
  timerToggle := setTimeout.Call($.beep, 5000)
}
genshin_6() {
  if !(isJumping) {
    return
  }
  isJumping := false
  clearTimeout.Call(timerJump)
}
genshin_7() {
  if (isJumping) {
    return
  }
  isJumping := true
  timerJump := setTimeout.Call(jumpTwice, 100)
}
genshin_8() {
  $.press.Call("space")
}
genshin_9() {
  $.press.Call("space")
  doAs.Call(Func("genshin_8"), 100, 2, 200)
}
genshin_10() {
  if !(isDashing) {
    return
  }
  isDashing := false
  clearInterval.Call(timerDash)
}
genshin_11() {
  if (isDashing) {
    return
  }
  isDashing := true
  clearInterval.Call(timerDash)
  timerDash := setInterval.Call(dash, 1300)
  dash.Call()
}
genshin_12() {
  $.click.Call("right:down")
  $.click.Call("right:up")
  $.click.Call("wheel-down:down")
  $.click.Call("wheel-down:up")
}
genshin_13() {
  $.beep.Call()
  $.exit.Call()
}
genshin_14() {
  if (!isSuspend && !WinActive("ahk_id " . (id) . "")) {
    $.suspend.Call(true)
    isSuspend := true
    return
  }
  if (isSuspend && WinActive("ahk_id " . (id) . "")) {
    $.suspend.Call(false)
    isSuspend := false
    return
  }
}
genshin_15() {
  id := WinExist("A")
  $.off.Call("f1", init)
  bind.Call()
  setInterval.Call(watch, 200)
  $.beep.Call()
}
genshin_16() {
  doAs.Call()
}
genshin_17(fn := "", interval := 100, limit := 1, delay := 0) {
  if (fn) {
    $dataDoAs.count := 0
    $dataDoAs.fn := fn
    $dataDoAs.interval := interval
    $dataDoAs.limit := limit
  }
  if (delay) {
    setTimeout.Call(doAs, delay)
    return
  }
  if ($dataDoAs.count >= $dataDoAs.limit) {
    return
  }
  $dataDoAs.count++
  $dataDoAs.fn.Call($dataDoAs)
  setTimeout.Call(Func("genshin_16"), $dataDoAs.interval)
}
genshin_18() {
  $.press.Call("s:up")
  stopJumpBack.Call()
}
genshin_19() {
  $.press.Call("s:down")
  startJumpBack.Call()
}
genshin_20(e) {
  $.press.Call("f")
  if !(e.count >= 10) {
    $.click.Call("wheel-down:down")
  } else {
    $.click.Call("wheel-down:up")
  }
}
genshin_21() {
  doAs.Call(Func("genshin_20"), 100, 10)
}
genshin_22() {
  $.press.Call("e:up")
  clearTimeout.Call(timer)
  timer := setTimeout.Call($.beep, 5000)
}
genshin_23() {
  $.press.Call("e:down")
}
genshin_24() {
  for __i__, key in ["1", "2", "3", "4", "5"] {
    $.on.Call(key, toggle.Bind(key))
  }
  $.on.Call("e", Func("genshin_23"))
  $.on.Call("e:up", Func("genshin_22"))
  $.on.Call("f", Func("genshin_21"))
  $.on.Call("mbutton", toggleView)
  $.on.Call("rbutton", startDash)
  $.on.Call("rbutton:up", stopDash)
  $.on.Call("s", Func("genshin_19"))
  $.on.Call("s:up", Func("genshin_18"))
  $.on.Call("space", jumpTwice)
}
