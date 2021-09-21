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

  Client.delay '~jump', 350 - diff, ->
    Movement.jump()
    ts.jump = $.now()

Movement.on 'unhold:start', ->
  $.press 'x'
  Client.delay '~jump', 200, Movement.jump

Movement.on 'unhold:end', -> Client.delay '~jump'