# 0xFF7C00
# 0xFF8C81
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

  clearTimeout timer.dash
  timer.dash = $.delay 1300, ->

    unless state.isDashing then return
    dash()

startDash = ->

  ts.dash = $.now() + 500

  unless config.data.betterRunning
    $.click 'right:down'
    return

  if config.data.easySkillTimer and skillTimer.isMona()
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

  if config.data.easySkillTimer and skillTimer.isMona()
    $.click 'right:up'
    return

  unless state.isDashing then return
  state.isDashing = false

  key = isMoving()
  unless key
    $.press 'w:up'
  else if key != 'w'
    $.press 'w:up'