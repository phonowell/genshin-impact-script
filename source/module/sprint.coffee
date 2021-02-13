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
    $.click 'right:up'

  clearTimeout timer.sprint
  timer.sprint = $.delay 1300, ->

    unless player.isSprinting
      return

    $.click 'right:down'

    sprint()

startSprint = ->

  if player.isSprinting
    return
  player.emit 'sprint-start'

  $.click 'right:down'
  ts.sprint = $.now()

  unless config.data.betterSprint
    return

  sprint()

stopSprint = ->

  unless player.isSprinting
    return
  player.emit 'sprint-end'

  $.click 'right:up'
  ts.sprint = $.now()
  
  unless config.data.betterSprint
    return

  clearTimeout timer.sprint
  movement.stopMove 'w'

# binding

$.on 'r-button', startSprint
$.on 'r-button:up', stopSprint

if config.data.betterSprint
  $.on 'w:up', -> $.delay 50, ->
    unless player.isSprinting
      return
    if player.isMoving
      return
    movement.startMove 'w'