ts.jump = 0

# binding

player
  .on 'jump:start', ->
    $.press 'space:down'
    ts.jump = $.now()

  .on 'jump:end', ->

    $.press 'space:up'
    diff = $.now() - ts.jump
    ts.jump = $.now()

    unless Config.data.betterJump and statusChecker.checkIsActive()
      return

    unless diff < 350
      return

    $.setTimeout ->
      player.jump()
      ts.jump = $.now()
    , 350 - diff

  .on 'unhold:start', ->

    $.press 'x'

    unless Config.data.betterJump and statusChecker.checkIsActive()
      return

    $.setTimeout player.jump, 50