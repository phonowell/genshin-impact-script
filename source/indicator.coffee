# function

class Indicator extends EmitterShell

  cacheCost: {} # Record<string, number[]>
  cacheCount: {} # Record<string, number>
  cacheTs: {} # Record<string, number>

  constructor: ->
    super()
    @watch()

  # clear(): void
  clear: ->

    @emit 'update'

    for name, group of @cacheCost
      @cacheCost[name] = [@getCost name]

    @cacheCount = {}

  # getCost(name: string): number
  getCost: (name) ->
    unless name then return

    group = @cacheCost[name]
    unless group then group = []

    len = $.length group
    unless len then return 0

    return $.round ($.sum group) / len

  # getCount(name: string): number
  getCount: (name) ->
    unless name then return
    vn = @cacheCount[name]
    unless vn then vn = 0
    return vn

  # setCost(name: string, step = 'start'| 'end'): void
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

  # setCount(name: string): void
  setCount: (name) ->
    unless name then return

    vn = @cacheCount[name]
    unless vn then vn = 0
    @cacheCount[name] = vn + 1

  # watch(): void
  watch: ->

    interval = 1e3
    token = 'indicator/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @clear

# execute
Indicator = new Indicator()