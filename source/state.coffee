# @ts-check

# @ts-ignore
import __map_state__ from '../../genshin-avatar-color-picker/source/result/state.yaml'

class StateG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/state').StateG['cacheElement'] ###
    @cacheElement = {
      cryo: false
      hydro: false
    }
    ###* @type import('./type/state').StateG['list'] ###
    @list = []
    ###* @type import('./type/state').StateG['mapColor'] ###
    @mapColor = __map_state__

  ###* @type import('./type/state').StateG['checkElement'] ###
  checkElement: (name) ->

    unless Timer.hasElapsed "state/#{name}", 500
      Indicator.setCount 'gdip/prevent'
      return @cacheElement[name]

    return @cacheElement[name] = ColorManager.findAll [
      @mapColor[name][0][0]
      @mapColor[name][0][1]
    ], ['42%', '88%', '58%', '91%']

  ###* @type import('./type/state').StateG['checkIsAiming'] ###
  checkIsAiming: ->
    unless (Character.get Party.name, 'weapon') == 'bow' then return false
    return (ColorManager.get ['50%', '50%']) == 0xFFFFFF

  ###* @type import('./type/state').StateG['checkIsFree'] ###
  checkIsFree: ->

    # unless ColorManager.findAny [0x96D722, 0xFF6666], [
    #   '88%', '25%'
    #   '89%', '53%'
    # ] then return false

    unless ColorManager.findAll [0xFFFFFF, 0x323232], [
      '94%', '80%'
      '95%', '82%'
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

    list = @makeListName()
    if Scene.is 'normal'

      if @checkIsFree()
        $.push list, 'free'
      else
        if @checkIsAiming() then $.push list, 'aiming'

      # element
      if @checkElement 'cryo' then $.push list, 'cryo'
      # if @checkElement 'hydro' then $.push list, 'hydro'

    if $.eq list, @list then return
    @list = list
    @emit 'change'

# @ts-ignore
State = new StateG()