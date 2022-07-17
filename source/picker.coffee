### interface
type Color = number
type Position = [number, number]
###

# function

class Picker

  isPicking: false

  constructor: ->
    @init()
    @watch()

  # find(): void
  find: ->

    if @isPicking then return
    unless Scene.is 'normal' then return

    [x, y] = @findColor 0x323232, ['57%', '30%'], ['59%', '70%']
    unless Point.isValid [x, y] then return

    color = @findTitleColor y
    unless color then return

    if color == 0xFFFFFF
      [x1, y1] = @findColor 0xFFFFFF, ['61%', y], ['63%', y + 20]
      if Point.isValid [x1, y1]

        # check shape
        color1 = ColorManager.get [x1 + 2, y1]
        unless color1 then return
        if color1 == 0xFFFFFF then return

    $.press 'f'

  # findTitleColor(y: number): string | false
  findTitleColor: (y) ->

    isFound = false

    for color in [0xFFFFFF, 0xCCCCCC, 0xACFF45, 0x4FF4FF, 0xF998FF]
      [x1, y1] = @findColor color, ['63%', y], ['65%', y + 20]
      unless Point.isValid [x1, y1] then continue
      isFound = true
      break

    if isFound then return color
    else return 0

  # findColor(color: Color, start: Position, end: Position): Position
  findColor: (color, start, end) ->
    [x, y] = ColorManager.find color, (Point.new start), Point.new end
    return [x, y]

  # init(): void
  init: ->

    $.on 'alt + f', @toggle

    # why?
    # sometimes pick:end event fired before pick:start event
    # very strange
    fn = =>
      unless @isPicking
        @isPicking = true
        console.log 'picker/is-picking: true'
        $.press 'f'
      else
        @isPicking = false
        console.log 'picker/is-picking: false'

    Player.on 'pick:start', fn
    Player.on 'pick:end', fn

  # listen(): void
  listen: ->
    unless @isPicking then return
    if @skip() then return
    unless Scene.is 'normal' then return
    $.press 'f'

  # next(): void
  next: ->

    if (Config.get 'better-pickup/use-quick-skip') and Scene.is 'event'
      @skip()
      return

    if (Config.get 'better-pickup/use-fast-pickup') and Scene.is 'normal'
      @find()
      return

  # skip(): boolean
  skip: ->

    unless Scene.is 'event' then return false

    Idle.setTimer() # avoid idle
    $.press 'space'

    p = ''
    for color in [0x806200, 0xFFCC32, 0xFFFFFF]
      p1 = @findColor color, ['65%', '40%'], ['70%', '80%']
      if Point.isValid p1
        p = p1
        break
    unless p then return true

    $.move p
    $.click()
    return true

  # watch(): void
  watch: ->

    interval = 100
    token = 'picker/watch'

    fn = =>
      if (Config.get 'better-pickup') and !@isPicking then @next()
      else @listen()

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', -> Timer.loop token, interval, fn

# execute
Picker = new Picker()