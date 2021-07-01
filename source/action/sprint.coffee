state.isSprinting = false
state.isSwimming = false
timer.sprint = ''
ts.sprint = 0

# function

sprint = ->

  if statusChecker.checkIsSwimming()
    stopSprint()
    startSprint()
    return

  $.click 'right'

startSprint = ->

  $.click 'right:down'

  unless Config.data.betterSprint
    return

  state.isSprinting = true

  unless player.isMoving
    player.startMove 'w'

  if statusChecker.checkIsSwimming()
    state.isSwimming = true
    $.clearInterval timer.sprint
    timer.sprint = $.setInterval swim, 1e3
    return

  $.click 'right:up'

  $.clearInterval timer.sprint
  timer.sprint = $.setInterval sprint, 1300

stopSprint = ->

  ts.sprint = $.now()

  unless Config.data.betterSprint
    $.click 'right:up'
    return

  state.isSprinting = false

  if state.isSwimming
    $.click 'right:up'
    state.isSwimming = false

  $.clearTimeout timer.sprint
  player.stopMove 'w'

swim = ->

  if statusChecker.checkIsSwimming()
    return

  stopSprint()
  startSprint()

# binding

player
  .on 'sprint:start', startSprint
  .on 'sprint:end', stopSprint

  .on 'move:start', ->
    unless Config.data.betterSprint
      return
    unless state.isSprinting
      return
    player.stopMove 'w'

  .on 'move:end', ->
    unless Config.data.betterSprint
      return
    unless state.isSprinting
      return
    if player.isMoving
      return
    player.startMove 'w'