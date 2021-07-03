ts.jump = 0

# binding

movement
  .on 'jump:start', ->
    $.press 'space:down'
    ts.jump = $.now()

  .on 'jump:end', ->

    $.press 'space:up'
    diff = $.now() - ts.jump
    ts.jump = $.now()

    unless Config.data.betterJump and checker.isActive
      return

    unless diff < 350
      return

    $.setTimeout ->
      movement.jump()
      ts.jump = $.now()
    , 350 - diff

  .on 'unhold:start', ->

    $.press 'x'

    unless Config.data.betterJump and checker.isActive
      return

    $.setTimeout movement.jump, 50