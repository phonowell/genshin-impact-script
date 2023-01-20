# @ts-check

import __map_status__ from '../../genshin-avatar-color-picker/source/result/status.yaml'

class Status2G extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/status').Status2G['list'] ###
    @list = []
    ###* @type import('./type/status').Status2G['mapColor'] ###
    @mapColor = __map_status__
    ###* @type import('./type/status').Status2G['mapTs'] ###
    @mapTs = {
      cryo: 0
      hydro: 0
    }

  ###* @type import('./type/status').Status2G['add'] ###
  add: (name) ->
    unless name then return
    if @has name then return
    $.push @list, name
    @mapTs[name] = $.now()
    @emit 'change'
    return

  ###* @type import('./type/status').Status2G['check'] ###
  check: (name) -> ColorManager.findAll [
    @mapColor[name][0][0]
    @mapColor[name][0][1]
  ], ['42%', '88%', '58%', '91%']

  ###* @type import('./type/status').Status2G['has'] ###
  has: (name) -> $.includes @list, name

  ###* @type import('./type/status').Status2G['init'] ###
  init: ->

    Scene.useExact ['single'], =>
      @on 'change', =>
        unless $.length @list
          console.log '#status/list: -'
          return
        console.log '#status/list:', $.join @list, ', '
      return => @off 'change'

    Scene.useExact ['single'], =>
      [interval, token] = [500, 'status/update']
      Timer.loop token, interval, @update
      return -> Timer.remove token

  ###* @type import('./type/status').Status2G['remove'] ###
  remove: (name) ->
    unless name then return
    unless @has name then return
    @list = $.filter @list, (it) -> it != name
    @emit 'change'
    return

  ###* @type import('./type/status').Status2G['update'] ###
  update: ->

    interval = 2e3
    now = $.now()

    # hydro
    if now - @mapTs.hydro > interval
      if @check 'hydro'
        @add 'hydro'
      else @remove 'hydro'

    # cryo
    if now - @mapTs.cryo > interval
      if @check 'cryo'
        @add 'cryo'
      else @remove 'cryo'

Status2 = new Status2G()