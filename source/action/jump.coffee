timer.unhold = 0
ts.jump = 0

# binding

Movement.on 'jump:start', ->
  $.press 'space:down'
  ts.jump = $.now()

Movement.on 'jump:end', ->

  $.press 'space:up'

  now = $.now()
  diff = now - ts.jump
  ts.jump = now

  unless Config.data.betterJump and Scene.name == 'normal'
    return

  unless diff < 350 then return

  $.setTimeout ->
    Movement.jump()
    ts.jump = $.now()
  , 350 - diff

Movement.on 'unhold:start', ->
  $.press 'x'
  $.clearTimeout timer.unhold
  timer.unhold = $.setTimeout Movement.jump, 200

Movement.on 'unhold:end', -> $.clearTimeout timer.unhold