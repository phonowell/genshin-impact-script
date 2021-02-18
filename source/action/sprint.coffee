state.isSprinting = false
state.isSprintSwimming = false
timer.sprint = ''
ts.sprint = 0

# function

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

sprint = ->

  unless player.isMoving
    movement.startMove 'w'

  unless checkSwimming()
    state.isSprintSwimming = true
    $.click 'right:up'

  clearTimeout timer.sprint
  timer.sprint = $.delay 1300, ->
    if state.isSprintSwimming
      state.isSprintSwimming = false
      $.click 'right:down'
    sprint()

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

  clearTimeout timer.sprint
  movement.stopMove 'w'

# binding

player
  .on 'sprint-start', startSprint
  .on 'sprint-end', stopSprint

if Config.data.betterSprint
  $.on 'w:up', -> $.delay 50, ->
    unless state.isSprinting
      return
    if player.isMoving
      return
    movement.startMove 'w'