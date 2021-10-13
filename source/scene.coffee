### interface
type Color = number
type Name = 'event'
  | 'half-menu'
  | 'fishing'
  | 'menu'
  | 'normal'
  | 'unknown'
using-q
###

# function

class SceneX extends EmitterShellX

  isMulti: false
  name: 'unknown'
  tsUpdate: 0

  # ---

  constructor: ->
    super()

    Client.on 'tick', @update

    @on 'change', =>
      console.log "scene: #{@name}"
      if @name == 'normal'
        @isMulti = @checkPoint [16, 2], [20, 6], 0xA9E588
        if @isMulti then console.log 'scene: multi-player'

  # check(): void
  check: ->

    if @checkPoint [94, 1], [99, 8], 0x3B4255 then return 'menu'
    if @checkPoint [1, 16], [4, 22], 0xFFFFFF then return 'normal'
    if @checkPoint [95, 2], [98, 7], 0xFFFFFF then return 'normal'
    if @checkPoint [1, 1], [5, 8], 0x3B4255 then return 'half-menu'

    if @checkPoint [49, 79], [51, 82], 0xFFC300 then return 'event'

    return 'unknown'

  # checkPoint(start: number, end: number, color: Color): boolean
  checkPoint: (start, end, color) ->
    [x, y] = $.findColor color, (Client.point start), Client.point end
    return x * y > 0

  # makeInterval(): number
  makeInterval: ->
    if @name != 'unknown' then return 2e3
    return 500

  # update(): void
  update: ->

    if @name == 'fishing' then return

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