### interface
type Color = number
type Group = [string] | [Name, string]
type Name = 'event'
  | 'fishing'
  | 'half-menu'
  | 'menu'
  | 'normal'
  | 'unknown'
using-q
###

# function
class Scene extends EmitterShellX

  isFrozen: false
  name: 'unknown'
  subname: 'unknown'
  tsChange: 0

  constructor: ->
    super()

    @on 'change', =>
      console.log "scene: #{@name}/#{@subname}"
      @tsChange = $.now()

  # check(): [Name, string]
  check: ->

    if @checkIsMenu() then return ['menu', 'unknown']
    if @checkIsHalfMenu() then return ['half-menu', 'unknown']
    if @checkIsNormal() then return ['normal', 'unknown']
    if @checkIsEvent() then return ['event', 'unknown']

    return ['unknown', 'unknown']

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

  # freeze(name: Name, subname: string, time: number): void
  freeze: (name, subname, time) ->

    unless @is name, subname
      @name = name
      @subname = subname
      @emit 'change'

    @isFrozen = true
    Timer.add 'scene/unfreeze', time, => @isFrozen = false

  # is(name: Name, subname?: string): boolean
  is: (name, subname = '') ->
    @update()
    unless subname then return name == @name
    return name == @name and subname == @subname

  # update(): void
  update: ->

    if @isFrozen then return
    if @name == 'fishing' then return

    [name, subname] = @check()
    if name == @name and subname == @subname then return
    @name = name
    @subname = subname
    @emit 'change'

# execute
Scene = new Scene()