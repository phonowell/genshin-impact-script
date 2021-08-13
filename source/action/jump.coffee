timer.unhold = 0
ts.jump = 0

# binding

movement.on 'jump:start', ->
  $.press 'space:down'
  ts.jump = $.now()

movement.on 'jump:end', ->

  $.press 'space:up'

  now = $.now()
  diff = now - ts.jump
  ts.jump = now

  unless Config.data.betterJump and Scene.name == 'normal'
    return

  unless diff < 350 then return

  $.setTimeout ->
    movement.jump()
    ts.jump = $.now()
  , 350 - diff

movement.on 'unhold:start', ->
  $.press 'x'
  $.clearTimeout timer.unhold
  timer.unhold = $.setTimeout movement.jump, 200

movement.on 'unhold:end', -> $.clearTimeout timer.unhold