jumpTwice = -> $.delay 200, ->
  unless player.isMoving
    return
  player.jump()

# binding

player.on 'jump:start', player.jump

if Config.data.betterJump

  player
    .on 'jump:end', jumpTwice
    .on 'unhold:end', -> $.delay 50, ->
      player.jump()