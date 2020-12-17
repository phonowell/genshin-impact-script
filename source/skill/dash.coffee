state.isDashing = false
timer.dash = ''
ts.dash = 0

dash = ->

  key = isMoving()
  unless key
    $.press 'w:down'
  else if key != 'w'
    $.press 'w:up'

  $.click 'right'

startDash = ->

  unless config.data.improvedSprint
    $.click 'right:down'
    return

  if state.isDashing then return
  state.isDashing = true

  clearInterval timer.dash
  timer.dash = setInterval dash, 1300
  dash()

stopDash = ->

  ts.dash = $.now()

  unless config.data.improvedSprint
    $.click 'right:up'
    return

  unless state.isDashing then return
  state.isDashing = false

  clearInterval timer.dash

  key = isMoving()
  unless key
    $.press 'w:up'
  else if key != 'w'
    $.press 'w:up'