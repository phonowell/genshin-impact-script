### interface
type Color = number
type Position = [number, number]
###

# function

class Picker

  isPicking: false

  constructor: ->

    $.on 'alt + f', @toggle

    Player.on 'pick:start', =>
      $.press 'f'
      @isPicking = true

    Player.on 'pick:end', => Timer.add 'picker/debounce', 100, => @isPicking = false

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

      # check shape
      if Point.isValid [x1, y1]
        color1 = ColorManager.get [x1 + 1, y1]
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
    fn = =>
      if Tactic.isActive then return
      if (Config.get 'better-pickup') and !@isPicking then @next()
      else @listen()
    Client.on 'idle', -> Timer.remove 'picker/watch'
    Client.on 'activate', -> Timer.loop 'picker/watch', interval, fn
    Timer.loop 'picker/watch', interval, fn

# execute
Picker = new Picker()