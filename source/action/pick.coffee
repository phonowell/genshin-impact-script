timer.pick = ''

# function

pick = ->

  if Config.data.quickDialog and skip()
    return

  $.press 'f'
  $.click 'wheel-down'

skip = ->

  unless menu.checkVisibility()
    return false

  start = client.point [65, 48]
  end = client.point [70, 78]

  point = ''
  for color in [0x806200, 0xFFFFFF]
    [x, y] = $.findColor color, start, end
    if x * y > 0
      point = [x, y]
      break

  unless point
    return false

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

  unless Config.data.fastPickup
    return

  $.clearInterval timer.pick

# binding

player
  .on 'pick:start', startPick
  .on 'pick:end', stopPick