ts.jump = 0

# binding

player
  .on 'jump:start', ->

    player.jump()
    ts.jump = $.now()

    unless Config.data.betterJump and !menu.checkVisibility()
      return

    await $.sleep 350
    player.jump()
    ts.jump = $.now()

  .on 'unhold:start', ->

    $.press 'x'

    unless Config.data.betterJump and !menu.checkVisibility()
      return

    await $.sleep 200
    player.jump()