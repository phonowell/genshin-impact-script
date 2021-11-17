state.isFiredSwitch = false
state.isPressedSwitch = false

# function

onSwitchEnd = (onSwitch) ->

  if onSwitch == 'e~'
    Player.useE 'holding'
    return

  unless state.isPressedSwitch
    Player.useE()
    return

  $.press 'e:up'
  SkillTimer.record 'end'

# binding

Player.on 'switch:start', (key) ->
  $.press key
  unless Scene.name == 'normal' then return
  Party.switchTo key
  state.isFiredSwitch = false
  state.isPressedSwitch = false

Player.on 'switch:end', ->

  unless Scene.name == 'normal' then return

  if state.isFiredSwitch

    {name} = Party
    unless name then return

    {onSwitch} = Character.data[name]
    unless onSwitch then return
    
    onSwitchEnd onSwitch
    return
  state.isFiredSwitch = true

Party.on 'switch', ->

  unless Scene.name == 'normal' then return

  {name} = Party
  unless name then return

  {onSwitch} = Character.data[name]
  unless onSwitch then return

  if state.isFiredSwitch
    onSwitchEnd onSwitch
    return
  state.isFiredSwitch = true

  unless onSwitch == 'e' then return

  state.isPressedSwitch = true
  $.press 'e:down'
  SkillTimer.record 'start'