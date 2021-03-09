timer.pick = ''

# function

pick = ->
  $.clearTimeout timer.pick
  timer.pick = $.setTimeout ->
    player.pick()
    pick()
  , 100

stopPick = -> $.clearTimeout timer.pick

# binding

if Config.data.fastPickup
  player
    .on 'pick:start', pick
    .on 'pick:end', stopPick