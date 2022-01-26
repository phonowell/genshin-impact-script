### interface
type Color = number
type Position = [number, number]
###

# function

class PickerX

  isAuto: false
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

    [x, y] = @findColor ['57%', '30%'], ['59%', '70%'], 0x323232
    unless x * y > 0 then return

    [x, y] = @findColor ['61%', y], ['63%', y + 1], 0xFFFFFF
    if x * y > 0
      color = $.getColor [x + 1, y]
      if color == 0xFFFFFF then return

    $.press 'f'

  # findColor(start: Position, end: Position, color: Color): Position
  findColor: (start, end, color = 0xFFFFFF) ->
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
      [x, y] = @findColor ['65%', '40%'], ['70%', '80%'], color
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

    if @isAuto then Hud.render 0, 'auto pickup ON'
    else Hud.render 0, 'auto pickup OFF'

  # watch(): void
  watch: ->
    interval = 200
    fn = =>
      if @isAuto then @next()
      else @listen()
    Client.on 'pause', -> Timer.remove 'picker/watch'
    Client.on 'resume', -> Timer.loop 'picker/watch', interval, fn
    Timer.loop 'picker/watch', interval, fn

# execute
Picker = new PickerX()