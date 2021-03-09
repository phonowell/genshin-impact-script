state.toggleDelay = 200

# function

getToggleDelay = ->
  delay = 500 - ($.now() - ts.sprint)
  if delay < 200
    delay = 200
  return delay

startToggle = (key) ->

  member.toggle key

  unless Config.data.autoESkill
    return

  {name} = member
  unless name
    return

  state.toggleDelay = getToggleDelay()

  {typeApr} = Character.data[name]
  unless typeApr
    return

  unless typeApr == 1
    return

  $.setTimeout ->
    $.press 'e:down'
    skillTimer.record 'start'
  , state.toggleDelay

stopToggle = (key) ->

  unless Config.data.autoESkill
    return

  {name} = member
  unless name
    return

  {typeApr} = Character.data[name]
  unless typeApr
    return

  if typeApr == 2
    $.setTimeout player.useE, state.toggleDelay
    return

  if typeApr == 3
    $.setTimeout ->
      player.useE 'holding'
    , state.toggleDelay
    return

  if typeApr == 4
    $.setTimeout player.useQ, state.toggleDelay
    return

  $.setTimeout ->
    $.press 'e:up'
    skillTimer.record 'end'
  , state.toggleDelay

# binding

player
  .on 'toggle:start', startToggle
  .on 'toggle:end', stopToggle

for key in [1, 2, 3, 4]
  $.on "alt + #{key}", ->
    player.toggleQ key