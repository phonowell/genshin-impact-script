# @ts-check

# @ts-ignore
import __map_state__ from '../../genshin-avatar-color-picker/source/result/state.yaml'

class StateG extends EmitterShell

  constructor: ->
    super()

    ### @type import('./type/state').StateG['cache'] ###
    @cache = {}

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

  ###* @type import('./type/state').StateG['checkIsDomain'] ###
  checkIsDomain: -> @throttle 'check-is-domain', 1e3, ->
    return ColorManager.findAll [0x38425C, 0xFFFFFF], [
      '1%', '9%'
      '3%', '13%'
    ]

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

  ###* @type import('./type/state').StateG['checkIsGadgetUsable'] ###
  checkIsGadgetUsable: ->

    p = ColorManager.findAny 0xFFFFFF, [
      '93%', '76%'
      '96%', '78%'
    ]
    unless p then return true

    if ColorManager.findAny 0xFFFFFF, [
      p[0] + 1, p[1]
      '96%', p[1] + 1
    ] then return false

    return true

  ###* @type import('./type/state').StateG['checkIsReady'] ###
  checkIsReady: ->

    unless @is 'not-domain' then return false
    unless Party.size > 1 then return true

    unless ColorManager.findAny [0x96D722, 0xFF6666], [
      '88%', '25%'
      '89%', '53%'
    ] then return false

    return true

  ###* @type import('./type/state').StateG['checkIsSingle'] ###
  checkIsSingle: -> @throttle 'check-is-single', 1e3, ->

    a = [
      '18%', '2%'
      '20%', '6%'
    ]

    unless ColorManager.findAny 0xFFFFFF, a then return false
    return not ColorManager.findAny [0x006699, 0x408000], a

  ###* @type import('./type/state').StateG['init'] ###
  init: ->

    @on 'change', =>
      unless $.length @list
        console.log '#state: -'
      else console.log '#state:', $.join @list, ', '

  ###* @type import('./type/state').StateG['is'] ###
  is: (names...) ->

    for name in names

      if $.startsWith name, 'not-'
        name2 = $.subString name, 4
        if $.includes @list, name2 then return false
        continue

      unless $.includes @list, name then return false
      continue

    return true

  ###* @type import('./type/state').StateG['makeListName'] ###
  makeListName: -> []

  ###* @type import('./type/state').StateG['throttle'] ###
  throttle: (id, interval, fn) ->

    unless Timer.hasElapsed "state/#{id}", interval
      Indicator.setCount 'gdip/prevent'
      return @cache[id]

    return @cache[id] = fn()

  ###* @type import('./type/state').StateG['update'] ###
  update: ->

    d = list: @makeListName()

    do => # single, domain

      unless Scene.is 'normal' then return

      if @checkIsSingle() then $.push d.list, 'single'
      if @checkIsDomain() then $.push d.list, 'domain'

      return

    do => # element

      unless Scene.is 'normal' then return

      if @checkElement 'cryo' then $.push d.list, 'cryo'
      if @checkElement 'hydro' then $.push d.list, 'hydro'
      if @checkIsFrozen d.list then $.push d.list, 'frozen'

      return

    do => # free, ready, aiming

      unless Scene.is 'normal' then return
      if $.includes d.list, 'frozen' then return

      # free
      if @checkIsFree()
        $.push d.list, 'free'
        if @checkIsReady() then $.push d.list, 'ready'
        return

      # not free
      if @checkIsAiming() then $.push d.list, 'aiming'
      return

    if $.eq d.list, @list then return
    @list = d.list
    @emit 'change'

# @ts-ignore
State = new StateG()