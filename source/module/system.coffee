# variable

isSuspend = false
timer = {}

resetAll = ->

  `Process, Priority, YuanShen.exe, Normal`

  for _timer of timer
    clearTimeout _timer

  $.delay 200, ->

    for key in ['middle', 'right']
      if ($.getState key) == 'D'
        $.click "#{key}:up"

    for key in ['e', 'f', 's', 'space']
      if ($.getState key) == 'D'
        $.press "#{key}:up"

watch = ->

  if !isSuspend and !WinActive 'ahk_exe YuanShen.exe'
    isSuspend = true
    $.suspend true
    resetAll()
    `Process, Priority, YuanShen.exe, Low`
    return

  if isSuspend and WinActive 'ahk_exe YuanShen.exe'
    isSuspend = false
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