### interface
type Color = number
type Name = 'event'
  | 'fishing'
  | 'half-menu'
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

    if @checkIsMenu() then return 'menu'
    if @checkIsHalfMenu() then return 'half-menu'
    if @checkIsNormal() then return 'normal'
    if @checkIsEvent() then return 'event'

    return 'unknown'

  # checkIsEvent(): boolean
  checkIsEvent: ->
    unless @checkPoint ['45%', '79%'], ['55%', '82%'], 0xFFC300 then return false
    return true

  # checkIsHalfMenu(): boolean
  checkIsHalfMenu: ->
    start = ['1%', '3%']
    end = ['3%', '6%']
    unless @checkPoint start, end, 0x3B4255 then return false
    unless @checkPoint start, end, 0xECE5D8 then return false
    return true

  # checkIsMenu(): boolean
  checkIsMenu: ->
    start = ['95%', '3%']
    end = ['97%', '5%']
    unless @checkPoint start, end, 0x3B4255 then return false
    unless @checkPoint start, end, 0xECE5D8 then return false
    return true

  # checkIsNormal(): boolean
  checkIsNormal: ->
    if @checkPoint ['2%', '17%'], ['4%', '21%'], 0xFFFFFF then return true
    if @checkPoint ['95%', '2%'], ['97%', '6%'], 0xFFFFFF then return true
    return false

  # checkPoint(start: number, end: number, color: Color): boolean
  checkPoint: (start, end, color) ->
    p = ColorManager.find color, (Point.new start), Point.new end
    return Point.isValid p

  # freeze(name: Name, time: number): void
  freeze: (name, time) ->

    if name != @name
      @name = name
      @emit 'change', @name

    @isFrozen = true
    Timer.add 'scene/unfreeze', time, => @isFrozen = false

  # isMenu(): boolean
  isMenu: -> return $.includes @name, 'menu'

  # update(): void
  update: ->

    if @isFrozen then return
    if @name == 'fishing' then return

    name = @check()
    if name == @name then return
    @name = name
    @emit 'change', @name

  # watch(): void
  watch: ->
    interval = 200
    Client.on 'pause', -> Timer.remove 'scene/watch'
    Client.on 'resume', => Timer.loop 'scene/watch', interval, @update
    Timer.loop 'scene/watch', interval, @update

# execute
Scene = new SceneX()