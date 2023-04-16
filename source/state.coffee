# @ts-check

# @ts-ignore
import __map_state__ from '../../genshin-avatar-color-picker/source/result/state.yaml'

class StateG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/state').StateG['list'] ###
    @list = []

    ###* @type import('./type/state').StateG['mapColor'] ###
    @mapColor = __map_state__

    ###* @type import('./type/state').StateG['namespace'] ###
    @namespace = 'state'

  ###* @type import('./type/state').StateG['checkElement'] ###
  checkElement: (name) -> ColorManager.findAll [
    @mapColor[name][0][0]
    @mapColor[name][0][1]
  ], ['42%', '88%', '58%', '91%']

  ###* @type import('./type/state').StateG['checkIsAiming'] ###
  checkIsAiming: ->
    unless (Character.get Party.name, 'weapon') == 'bow' then return false
    return (ColorManager.get ['50%', '50%']) == 0xFFFFFF

  ###* @type import('./type/state').StateG['checkIsFree'] ###
  checkIsFree: ->

    unless ColorManager.findAll [0xFFFFFF, 0x323232], [
      '94%', '80%'
      '95%', '82%'
    ] then return false

    return true

  ###* @type import('./type/state').StateG['checkIsFrozen'] ###
  checkIsFrozen: (list) ->

    isCryo = $.includes list, 'cryo'
    isHydro = $.includes list, 'hydro'

    unless (isCryo or isHydro) then return false
    # it is less precise
    # do not use this judgment
    # if isCryo and isHydro then return true

    unless ColorManager.findAll 0xF05C4A, [
      '73%', '48%'
      '75%', '52%'
    ] then return false

    unless ColorManager.findAll [0xFFFFFF, 0x323232], [
      '72%', '53%'
      '75%', '56%'
    ] then return false

    return true

  ###* @type import('./type/state').StateG['checkIsReady'] ###
  checkIsReady: ->

    unless Party.size > 1 then return true

    unless ColorManager.findAny [0x96D722, 0xFF6666], [
      '88%', '25%'
      '89%', '53%'
    ] then return false

    return true

  ###* @type import('./type/state').StateG['init'] ###
  init: ->

    @on 'change', =>
      unless $.length @list
        console.log '#state: -'
      else console.log '#state:', $.join @list, ', '

  ###* @type import('./type/state').StateG['is'] ###
  is: (name) -> $.includes @list, name

  ###* @type import('./type/state').StateG['makeListName'] ###
  makeListName: -> []

  ###* @type import('./type/state').StateG['update'] ###
  update: ->

    list = do =>

      l = @makeListName()
      unless Scene.is 'normal' then return l

      # element
      if @checkElement 'cryo' then $.push l, 'cryo'
      if @checkElement 'hydro' then $.push l, 'hydro'
      if @checkIsFrozen l then $.push l, 'frozen'
      if $.includes l, 'frozen' then return l

      # free
      if @checkIsFree()
        $.push l, 'free'
        if @checkIsReady() then $.push l, 'ready'
        return l

      # not free
      if @checkIsAiming() then $.push l, 'aiming'
      return l

    if $.eq list, @list then return
    @list = list
    @emit 'change'

# @ts-ignore
State = new StateG()