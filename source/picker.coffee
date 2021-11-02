### interface
type Color = number
type Position = [number, number]
###

# function

class PickerX

  isAuto: false
  isFound: false
  isPicking: false
  tsDetect: 0

  # ---

  constructor: ->

    Client.on 'tick', @next
    Client.on 'tick', @pick
    $.on 'alt + f', @toggle

    Player.on 'pick:start', =>
      $.press 'f'
      unless Config.data.fastPickup then return
      @isPicking = true

    Player.on 'pick:end', => @isPicking = false

  # detect(): void
  detect: ->

    if @isPicking then return
    unless Scene.name == 'normal' then return

    interval = 200
    if @isFound then interval = 50

    now = $.now()
    unless now - @tsDetect >= interval then return
    @tsDetect = now

    # [x, y] = @find ['59%', '30%'], ['61%', '70%'], 0xECE5D8
    # unless x * y > 0
    #   @isFound = false
    #   return

    [x, y] = @find ['57%', '30%'], ['59%', '70%'], 0x323232
    unless x * y > 0
      @isFound = false
      return

    [x, y] = @find ['61%', y], ['63%', y + 1], 0xFFFFFF
    if x * y > 0
      color = $.getColor [x + 1, y]
      if color == 0xFFFFFF
        @isFound = false
        return

    @isFound = true
    $.press 'f'
    # $.click 'wheel-down'

  # find(start: Position, end: Position, color: Color): Position
  find: (start, end, color = 0xFFFFFF) ->
    [x, y] = $.findColor color, (Point.new start), Point.new end
    return [x, y]

  # pick(): void
  pick: ->
    unless @isPicking then return
    if @skip() then return
    unless Scene.name == 'normal' then return
    $.press 'f'
    # $.click 'wheel-down'

  # next(): void
  next: ->

    unless @isAuto then return

    if Config.data.quickEvent and Scene.name == 'event'
      @skip()
      return

    if Config.data.fastPickup and Scene.name == 'normal'
      @detect()
      return

  # skip(): boolean
  skip: ->

    unless Scene.name == 'event' then return false

    $.press 'space'

    p = ''
    for color in [0x806200, 0xFFCC32, 0xFFFFFF]
      [x, y] = @find ['65%', '40%'], ['70%', '80%'], color
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

    if @isAuto
      msg = 'enter auto-pickup mode'
      if Config.data.region == 'cn' then msg = '开启自动拾取'
      Hud.render 5, msg
    else
      msg = 'leave auto-pickup mode'
      if Config.data.region == 'cn' then msg = '关闭自动拾取'
      Hud.render 5, msg

# execute
Picker = new PickerX()