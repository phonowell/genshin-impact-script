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

  $.delay state.toggleDelay, ->
    $.press 'e:down'
    skillTimer.record 'start'

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
    $.delay state.toggleDelay, player.useE
    return

  if typeApr == 3
    $.delay state.toggleDelay, ->
      player.useE 'holding'
    return

  if typeApr == 4
    $.delay state.toggleDelay, player.useQ
    return

  $.delay state.toggleDelay, ->
    $.press 'e:up'
    skillTimer.record 'end'

# binding

player
  .on 'toggle:start', startToggle
  .on 'toggle:end', stopToggle

for key in [1, 2, 3, 4]
  $.on "alt + #{key}", ->
    player.toggleQ key