
### interface
event
half-menu
loading
menu
normal
special-menu
title
unknown
using-q
###

# function

class SceneX extends EmitterShellX

  isMulti: false
  name: 'unknown'
  tsUpdate: 0

  constructor: ->
    super()

    client.on 'tick', @update

    @on 'change', =>
      console.log "scene: #{@name}"
      if @name == 'normal'
        @isMulti = @checkPoint [16, 2], [20, 6], 0xA9E588
        if @isMulti then console.log 'scene: multi-player'

  check: ->

    if @checkPoint [94, 1], [99, 8], 0x3B4255 then return 'menu'
    if @checkPoint [1, 16], [4, 22], 0xFFFFFF then return 'normal'
    if @checkPoint [95, 2], [98, 7], 0xFFFFFF then return 'normal'
    if @checkPoint [1, 1], [5, 8], 0x3B4255 then return 'half-menu'

    if @checkPoint [49, 79], [51, 82], 0xFFC300 then return 'event'

    return 'unknown'

  checkPoint: (start, end, color) ->
    [x, y] = $.findColor color, (client.point start), client.point end
    return x * y > 0

  makeInterval: ->
    if @name != 'unknown' then return 2e3
    if Config.data.performance == 'high' then return 200
    if Config.data.performance == 'low' then return 1e3
    return 500

  update: ->

    now = $.now()
    unless now - @tsUpdate >= @makeInterval()
      return
    @tsUpdate = now

    name = @check()

    if Config.data.isDebug
      cost = $.now() - now
      if cost >= 20 then console.log "scene/cost: #{cost} ms"

    if name == @name then return

    @name = name
    @emit 'change', @name

# execute
Scene = new SceneX()