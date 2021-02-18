jumpTwice = -> $.delay 200, ->
    unless player.isMoving
      return
    $.press 'space'

# binding

if Config.data.betterJump
  player.on 'jump-end', jumpTwice
  $.on 'x', ->
    $.press 'x'
    $.press 'space'