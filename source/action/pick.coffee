timer.pick = ''

# function

pick = ->

  clearTimeout timer.pick
  timer.pick = $.delay 100, ->

    $.press 'f'
    $.click 'wheel-down'

    pick()

stopPick = -> clearTimeout timer.pick

# binding

if Config.data.fastPickup
  player
    .on 'pick:start', pick
    .on 'pick:end', stopPick