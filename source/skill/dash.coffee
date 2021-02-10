# 0xFF7C00
# 0xFF8C81
state.isDashing = false
state.isSwimming = false
timer.dash = ''
ts.dash = 0

checkSwimming = ->

  start = [
    client.vw 80
    client.vh 90
  ]

  end = [
    client.width
    client.height
  ]

  point = $.findColor 0xFFE92C, start, end, 0.9
  return point[0] * point[1] > 0

dash = ->

  key = isMoving()
  unless key
    $.press 'w:down'
  else if key != 'w'
    $.press 'w:up'

  $.click 'right'

  clearTimeout timer.dash
  timer.dash = $.delay 1300, ->

    unless state.isDashing then return
    dash()

startDash = ->

  ts.dash = $.now() + 500

  unless config.data.betterRunning
    $.click 'right:down'
    return

  if state.isSwimming then return
  state.isSwimming = checkSwimming()

  if state.isSwimming
    $.click 'right:down'
    return

  if state.isDashing then return
  state.isDashing = true

  dash()

stopDash = ->

  ts.dash = $.now()

  unless config.data.betterRunning
    $.click 'right:up'
    return

  if state.isSwimming
    state.isDashing = false
    state.isSwimming = false
    $.click 'right:up'
    return

  unless state.isDashing then return
  state.isDashing = false

  key = isMoving()
  unless key
    $.press 'w:up'
  else if key != 'w'
    $.press 'w:up'