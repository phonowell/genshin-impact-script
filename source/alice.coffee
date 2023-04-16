# @ts-check

class AliceG

  constructor: ->

    ###* @type import('./type/alice').AliceG['mapOnSwitch'] ###
    @mapOnSwitch = {}

    ###* @type import('./type/alice').AliceG['namespace'] ###
    @namespace = 'alice'

  ###* @type import('./type/alice').AliceG['init'] ###
  init: ->
    Party.on 'change', @prepare

  ###* @type import('./type/alice').AliceG['next'] ###
  next: ->

    unless $.length @mapOnSwitch then return
    unless Scene.is 'normal' then return

    list = $.map ($.keys @mapOnSwitch), (it) -> $.toNumber $.subString it, 1 # p1 -> 1
    list = $.filter list, (n) -> n != Party.current
    $.unshift list, Party.current

    for n in list

      cd = Skill.listCountDown[n]
      if cd then continue

      $.trigger "#{n}:down"
      Timer.add 100, -> $.trigger "#{n}:up"
      break
    return

  ###* @type import('./type/alice').AliceG['prepare'] ###
  prepare: ->

    @mapOnLongPress = {}
    @mapOnSwitch = {}

    for n in [1, 2, 3, 4, 5]
      if n > Party.size then break

      name = Party.list[n]
      unless name then continue

      {onLongPress, onSwitch} = Character.get name
      if onLongPress then @mapOnLongPress["p#{n}"] = onLongPress
      if onSwitch then @mapOnSwitch["p#{n}"] = onSwitch
    return

# @ts-ignore
Alice = new AliceG()