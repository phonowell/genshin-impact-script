### interface
type Color = number
type Position = [number, number]
###

# function

class PickerX

  isAuto: false
  isFound: false
  isPicking: false

  # ---

  constructor: ->

    $.on 'alt + f', @toggle

    Player.on 'pick:start', =>
      $.press 'f'
      unless Config.data.fastPickup then return
      @isPicking = true

    Player.on 'pick:end', => @isPicking = false

    @watch()

  # find(): void
  find: ->

    if @isPicking then return
    unless Scene.name == 'normal' then return

    [x, y] = @findColor 0x323232, ['57%', '30%'], ['59%', '70%']
    unless x * y > 0 then return

    color = @findTitleColor y
    unless color then return

    if color == 0xFFFFFF
      [x1, y1] = @findColor 0xFFFFFF, ['61%', y], ['63%', y + 10]

      # check shape
      if x1 * y1 > 0
        color1 = $.getColor [x1 + 1, y1]
        if color1 == 0xFFFFFF then return

      # recheck
      unless ($.getColor [x, y]) == 0x323232 then return

    $.press 'f'

  # findTitleColor(y: number): string | false
  findTitleColor: (y) ->

    @isFound = false

    for color in [0xFFFFFF, 0xCCCCCC, 0xACFF45, 0x4FF4FF, 0xF998FF]
      [x1, y1] = @findColor color, ['63%', y], ['65%', y + 10]
      unless x1 * y1 > 0 then continue
      @isFound = true
      break

    if @isFound then return color
    else return 0

  # findColor(color: Color, start: Position, end: Position): Position
  findColor: (color, start, end) ->
    [x, y] = ColorManager.find color, (Point.new start), Point.new end
    return [x, y]

  # listen(): void
  listen: ->
    unless @isPicking then return
    if @skip() then return
    unless Scene.name == 'normal' then return
    $.press 'f'

  # next(): void
  next: ->

    interval = 200
    if @isFound
      @isFound = false
      interval = 100
    unless Timer.checkInterval 'picker/throttle', interval then return

    if Config.data.quickEvent and Scene.name == 'event'
      @skip()
      return

    if Config.data.fastPickup and Scene.name == 'normal'
      @find()
      return

  # skip(): boolean
  skip: ->

    unless Scene.name == 'event' then return false

    $.press 'space'

    p = ''
    for color in [0x806200, 0xFFCC32, 0xFFFFFF]
      [x, y] = @findColor color, ['65%', '40%'], ['70%', '80%']
      unless x * y > 0 then continue
      p = [x, y]
      break

    unless p then return false

    $.move p
    $.click()
    return true

  # toggle(): void
  toggle: ->

    @isAuto = !@isAuto

    if @isAuto then Hud.render 0, 'auto pickup [ON]'
    else Hud.render 0, 'auto pickup [OFF]'

  # watch(): void
  watch: ->
    interval = 100
    fn = =>
      if @isAuto and !@isPicking then @next()
      else @listen()
    Client.on 'pause', -> Timer.remove 'picker/watch'
    Client.on 'resume', -> Timer.loop 'picker/watch', interval, fn
    Timer.loop 'picker/watch', interval, fn

# execute
Picker = new PickerX()