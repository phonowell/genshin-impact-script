state.isSprinting = false
state.isSprintSwimming = false
timer.sprint = ''
ts.sprint = 0

# function

checkSwimming = ->

  if player.name == 'mona'
    return true

  start = client.point [90, 90]

  end = [
    client.width
    client.height
  ]

  point = $.findColor 0xFFE92C, start, end
  return point[0] * point[1] > 0

sprint = ->

  if checkSwimming()
    stopSprint()
    startSprint()
    return

  $.click 'right'

startSprint = ->

  if Config.data.quickDialog and menu.checkVisibility()
    $.press 'esc'
    return

  $.click 'right:down'

  unless Config.data.betterSprint
    return

  state.isSprinting = true

  unless player.isMoving
    player.startMove 'w'

  if checkSwimming()
    state.isSprintSwimming = true
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

  if state.isSprintSwimming
    $.click 'right:up'
    state.isSprintSwimming = false

  $.clearTimeout timer.sprint
  player.stopMove 'w'

swim = ->

  if checkSwimming()
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