# variable

state = {}
timer = {}
ts = {}

state.isSuspend = false

resetAll = ->

  `Process, Priority, YuanShen.exe, Normal`

  for _timer of timer
    clearTimeout _timer

  $.delay 200, ->

    for key in ['middle', 'right']
      if $.getState key
        $.click "#{key}:up"

    for key in ['e', 'f', 's', 'space', 'w', 'x']
      if $.getState key
        $.press "#{key}:up"

watch = ->

  if !state.isSuspend and !WinActive 'ahk_exe YuanShen.exe'
    state.isSuspend = true
    $.suspend true
    resetAll()
    `Process, Priority, YuanShen.exe, Low`
    return

  if state.isSuspend and WinActive 'ahk_exe YuanShen.exe'
    state.isSuspend = false
    $.suspend false
    `Process, Priority, YuanShen.exe, Normal`
    return

# binding

$.on 'alt + f4', ->
  resetAll()
  $.beep()
  $.exit()

# execute

$.delay 1e3, ->

  bind()
  setInterval watch, 200