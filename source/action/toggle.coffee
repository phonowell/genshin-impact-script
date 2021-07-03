state.toggleDelay = 200

# function

startToggle = (key) ->

  $.press key

  unless checker.isActive
    return

  member.toggle key

  {name} = player
  unless name
    return

  {typeApr} = Character.data[name]
  unless typeApr
    return

  unless typeApr == 1
    return

  $.setTimeout ->
    $.press 'e:down'
    skillTimer.record 'start'
  , state.toggleDelay

stopToggle = ->

  unless checker.isActive
    return

  {name} = player
  unless name
    return

  {typeApr} = Character.data[name]
  unless typeApr
    return

  if typeApr == 2
    $.setTimeout ->
      player.useE 'holding'
    , state.toggleDelay
    return

  $.setTimeout ->
    $.press 'e:up'
    skillTimer.record 'end'
  , state.toggleDelay

# binding

player
  .on 'toggle:start', startToggle
  .on 'toggle:end', stopToggle
  .on 'toggle-q:end', player.toggleQ