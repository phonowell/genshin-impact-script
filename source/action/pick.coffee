timer.pick = ''

# function

pick = ->

  if Config.data.quickDialog and skip()
    return

  $.press 'f'
  $.click 'wheel-down'

skip = ->

  if checker.isActive
    return false

  start = client.point [65, 40]
  end = client.point [70, 80]

  point = ''
  for color in [0x806200, 0xFFFFFF]
    [x, y] = $.findColor color, start, end
    if x * y > 0
      point = [x, y]
      break

  unless point then return false

  $.move point
  $.click()
  return true

startPick = ->

  $.press 'f'

  unless Config.data.fastPickup
    return

  $.clearInterval timer.pick
  timer.pick = $.setInterval pick, 100

stopPick = ->
  unless Config.data.fastPickup then return
  $.clearInterval timer.pick

# binding

player
  .on 'pick:start', startPick
  .on 'pick:end', stopPick