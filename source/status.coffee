# @ts-check

# @ts-ignore
import __map_status__ from '../../genshin-avatar-color-picker/source/result/status.yaml'

class Status2G extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/status').Status2G['list'] ###
    @list = []
    ###* @type import('./type/status').Status2G['mapColor'] ###
    @mapColor = __map_status__

  ###* @type import('./type/status').Status2G['checkElement'] ###
  checkElement: (name) -> ColorManager.findAll [
    @mapColor[name][0][0]
    @mapColor[name][0][1]
  ], ['42%', '88%', '58%', '91%']

  ###* @type import('./type/status').Status2G['checkIsAiming'] ###
  checkIsAiming: ->
    unless (Character.get Party.name, 'weapon') == 'bow' then return false
    return (ColorManager.get ['50%', '50%']) == 0xFFFFFF

  ###* @type import('./type/status').Status2G['checkIsFree'] ###
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

  ###* @type import('./type/status').Status2G['has'] ###
  has: (name) -> $.includes @list, name

  ###* @type import('./type/status').Status2G['init'] ###
  init: ->

    @on 'change', =>
      unless $.length @list
        console.log '#status/list: -'
      else console.log '#status/list:', $.join @list, ', '

  ###* @type import('./type/status').Status2G['makeListName'] ###
  makeListName: -> []

  ###* @type import('./type/status').Status2G['update'] ###
  update: ->

    list = @makeListName()
    if Scene.is 'normal'

      # element
      if @checkElement 'cryo' then $.push list, 'cryo'
      if @checkElement 'hydro' then $.push list, 'hydro'

      if @checkIsFree()
        $.push list, 'free'
      else
        if @checkIsAiming() then $.push list, 'aiming'

    if $.eq list, @list then return
    @list = list
    @emit 'change'

# @ts-ignore
Status2 = new Status2G()