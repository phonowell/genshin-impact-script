timer.pick = ''

pick = ->

  clearTimeout timer.pick
  timer.pick = $.delay 100, ->

    $.press 'f'
    $.click 'wheel-down'

    pick()

stopPick = -> clearTimeout timer.pick

# binding

if config.data.fastPickup
  player.on 'pick-start', pick
  player.on 'pick-end', stopPick