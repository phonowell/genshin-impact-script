# variable

id = ''
isSuspend = false
timer = ''

# function

init = ->
  id = WinExist 'A'
  $.off 'f1', init
  bind()
  setInterval watch, 200
  $.beep()

watch = ->

  if !isSuspend and !WinActive "ahk_id #{id}"
    $.suspend true
    isSuspend = true
    return

  if isSuspend and WinActive "ahk_id #{id}"
    $.suspend false
    isSuspend = false
    return

# binding

$.on 'f1', init

$.on 'alt + f4', ->
  $.beep()
  $.exit()