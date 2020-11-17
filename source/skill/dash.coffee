isDashing = false
timerDash = ''

dash = ->

  $.click 'right:down'
  $.click 'right:up'

  # view far
  $.click 'wheel-down:down'
  $.click 'wheel-down:up'

startDash = ->

  if isDashing then return
  isDashing = true

  clearInterval timerDash
  timerDash = setInterval dash, 1300
  dash()

stopDash = ->

  unless isDashing then return
  isDashing = false

  clearInterval timerDash