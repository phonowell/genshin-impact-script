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

  unless player.isMoving
    player.startMove 'w'

  unless checkSwimming()
    state.isSprintSwimming = true
    $.click 'right:up'

  $.clearTimeout timer.sprint
  timer.sprint = $.setTimeout ->
    if state.isSprintSwimming
      state.isSprintSwimming = false
      $.click 'right:down'
    sprint()
  , 1300

startSprint = ->

  unless Config.data.betterSprint
    return

  state.isSprinting = true

  sprint()

stopSprint = ->

  ts.sprint = $.now()

  unless Config.data.betterSprint
    return

  state.isSprinting = false
  state.isSprintSwimming = false

  $.clearTimeout timer.sprint
  player.stopMove 'w'

# binding

player
  .on 'sprint:start', startSprint
  .on 'sprint:end', stopSprint

if Config.data.betterSprint
  player.on 'move:end', ->
    unless state.isSprinting
      return
    if player.isMoving
      return
    player.startMove 'w'