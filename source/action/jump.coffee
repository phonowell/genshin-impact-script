ts.jump = 0

# binding

player
  .on 'jump:start', ->

    player.jump()
    ts.jump = $.now()

    unless Config.data.betterJump and statusChecker.checkIsActive()
      return

    $.setTimeout ->
      player.jump()
      ts.jump = $.now()
    , 350

  .on 'unhold:start', ->

    $.press 'x'

    unless Config.data.betterJump and statusChecker.checkIsActive()
      return

    $.setTimeout player.jump, 50