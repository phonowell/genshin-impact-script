ts.jump = 0

# function

jumpTwice = -> $.setTimeout player.jump, 200

# binding

player
  .on 'jump:start', player.jump
  .on 'jump:end', ->
    ts.jump = $.now()
    if Config.data.betterJump
      jumpTwice()

  .on 'unhold:end', ->
    $.press 'x:down'
    $.setTimeout ->
      $.press 'x:up'

      if Config.data.betterJump
        $.setTimeout player.jump, 50

    , 100