timer.pick = ''

# function

pick = ->

  if skip()
    return

  $.press 'f'
  $.click 'wheel-down'

skip = ->

  unless menu.isVisible
    return false

  start = client.point [65, 48]
  end = client.point [70, 78]

  [x, y] = $.findColor 0xFFFFFF, start, end
  unless x * y > 0
    return false

  $.move [x, y]
  $.click()
  return true

startPick = ->

  $.press 'f'

  unless Config.data.fastPickup
    return

  $.clearInterval timer.pick
  timer.pick = $.setInterval pick, 150

stopPick = ->

  unless Config.data.fastPickup
    return

  $.clearInterval timer.pick

# binding

player
  .on 'pick:start', startPick
  .on 'pick:end', stopPick