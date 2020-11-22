state.isDashing = false
timer.dash = ''

dash = ->

  key = isMoving()
  unless key
    $.press 'w:down'
  else if key != 'w'
    $.press 'w:up'

  $.click 'right'

startDash = ->

  if state.isDashing then return
  state.isDashing = true

  clearInterval timer.dash
  timer.dash = setInterval dash, 1300
  dash()

stopDash = ->

  unless state.isDashing then return
  state.isDashing = false

  clearInterval timer.dash

  key = isMoving()
  unless key
    $.press 'w:up'
  else if key != 'w'
    $.press 'w:up'