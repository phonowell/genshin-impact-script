jumpTwice = ->
  $.setTimeout ->
    unless player.isMoving
      return
    player.jump()
  , 200

# binding

player.on 'jump:start', player.jump

if Config.data.betterJump

  player
    .on 'jump:end', jumpTwice
    .on 'unhold:end', ->
      $.setTimeout ->
        player.jump()
      , 50