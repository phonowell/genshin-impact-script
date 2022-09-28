# @ts-check

class IndicatorG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/indicator').IndicatorG['cacheCost'] ###
    @cacheCost = {} # Record<string, number[]>
    ###* @type import('./type/indicator').IndicatorG['cacheCount'] ###
    @cacheCount = {} # Record<string, number>
    ###* @type import('./type/indicator').IndicatorG['cacheTs'] ###
    @cacheTs = {} # Record<string, number>

    @watch()

  ###* @type import('./type/indicator').IndicatorG['clear'] ###
  clear: ->

    @emit 'update'

    for name, group of @cacheCost
      @cacheCost[name] = [@getCost name]

    @cacheCount = {}
    return

  ###* @type import('./type/indicator').IndicatorG['getCost'] ###
  getCost: (name) ->
    unless name then return 0

    group = @cacheCost[name]
    unless group then group = []

    len = $.length group
    unless len then return 0

    return $.Math.round ($.sum group) / len

  ###* @type import('./type/indicator').IndicatorG['getCount'] ###
  getCount: (name) ->
    unless name then return 0
    vn = @cacheCount[name]
    unless vn then vn = 0
    return vn

  ###* @type import('./type/indicator').IndicatorG['setCost'] ###
  setCost: (name, step) ->
    unless name then return

    now = $.now()
    if step == 'start'
      @cacheTs[name] = now
      return

    group = @cacheCost[name]
    unless group then group = []

    $.push group, now - @cacheTs[name]
    @cacheCost[name] = group
    return

  ###* @type import('./type/indicator').IndicatorG['setCount'] ###
  setCount: (name) ->
    unless name then return

    vn = @cacheCount[name]
    unless vn then vn = 0
    @cacheCount[name] = vn + 1
    return

  ###* @type import('./type/indicator').IndicatorG['watch'] ###
  watch: ->

    interval = 1e3
    token = 'indicator/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @clear

Indicator = new IndicatorG()