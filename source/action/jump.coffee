ts.jump = 0

# function

jumpTwice = ->
  $.setTimeout ->
    unless player.isMoving
      return
    player.jump()
  , 200

# binding

player
  .on 'jump:start', player.jump
  .on 'jump:end', ->
    ts.jump = $.now()
    if Config.data.betterJump
      jumpTwice()

if Config.data.betterJump

  player
    .on 'unhold:end', ->
      $.setTimeout ->
        player.jump()
      , 50