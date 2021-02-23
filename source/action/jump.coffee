# function

jumpTwice = -> $.delay 200, ->
    unless player.isMoving
      return
    $.press 'space'

# binding

if Config.data.betterJump
  player
    .on 'jump-end', jumpTwice
    .on 'unhold-end', -> $.delay 50, ->
      $.press 'space'