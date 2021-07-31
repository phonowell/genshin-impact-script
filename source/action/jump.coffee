ts.jump = 0

# binding

movement.on 'jump:start', ->
  $.press 'space:down'
  ts.jump = $.now()

movement.on 'jump:end', ->

  $.press 'space:up'
  diff = $.now() - ts.jump
  ts.jump = $.now()

  unless Config.data.betterJump and Scene.name == 'normal'
    return

  unless diff < 350 then return

  $.setTimeout ->
    movement.jump()
    ts.jump = $.now()
  , 350 - diff

player.on 'unhold:start', ->

  $.press 'x'

  unless Config.data.betterJump and Scene.name == 'normal'
    return

  $.setTimeout movement.jump, 50