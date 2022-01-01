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

  isFrozen: false
  name: 'unknown'
  tsChange: 0

  # ---

  constructor: ->
    super()

    @on 'change', =>
      console.log "scene: #{@name}"
      @tsChange = $.now()

    @watch()

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
    [x, y] = ColorManager.find color, (Client.point start), Client.point end
    return x * y > 0

  # freeze(name: Name, time: number): void
  freeze: (name, time) ->

    if name != @name
      @name = name
      @emit 'change', @name

    @isFrozen = true
    Timer.add 'scene/unfreeze', time, => @isFrozen = false

  # makeInterval(): number
  makeInterval: ->
    if @name != 'unknown' then return 2e3
    return 1e3

  # update(): void
  update: ->

    if @isFrozen then return
    if @name == 'fishing' then return

    unless Timer.checkInterval 'scene/throttle', @makeInterval() then return

    name = @check()
    if name == @name then return
    @name = name
    @emit 'change', @name

  # watch(): void
  watch: ->
    interval = 500
    Client.on 'pause', -> Timer.remove 'scene/watch'
    Client.on 'resume', => Timer.loop 'scene/watch', interval, @update
    Timer.loop 'scene/watch', interval, @update

# execute
Scene = new SceneX()