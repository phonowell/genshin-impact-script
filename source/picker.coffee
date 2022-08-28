# function

class Picker

  isPicking: false
  tsPick: 0

  constructor: ->
    @init()
    @watch()

  # click(p: Point): void
  click: (p) ->
    p = Point.create p
    old = $.getPosition()
    $.move p
    $.click()
    Timer.add 50, -> $.move old

  # find(): void
  find: ->

    if @isPicking then return
    unless Scene.is 'normal', 'unknown' then return

    p = ColorManager.findAny 0x323232, [
      '57%', '30%'
      '59%', '70%'
    ]
    unless p then return
    [x, y] = p

    color = @findTitleColor y
    unless color then return

    if color == 0xFFFFFF
      p = ColorManager.findAny 0xFFFFFF, [
        ['61%', y]
        ['63%', y + 20]
      ]
      if p
        [x1, y1] = p

        # check shape
        if (ColorManager.get [x1, y1 + 1]) == 0xFFFFFF
          if (ColorManager.get [x1 + 1, y1]) == 0xFFFFFF
            return

    $.press 'f'

  # findTitleColor(y: number): string | false
  findTitleColor: (y) ->

    listColor = [0xFFFFFF, 0xCCCCCC, 0xACFF45, 0x4FF4FF, 0xF998FF]
    p = ColorManager.findAny listColor, [
      '63%', y
      '65%', y + 20
    ]

    if p then return p[2]
    else return 0

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
      @tsPick = $.now()

    Player.on 'pick:start', fn
    Player.on 'pick:end', fn

  # listen(): void
  listen: ->
    diff = $.now() - @tsPick
    unless diff > 350 then return
    unless @isPicking then return
    if @skip() then return
    unless Scene.is 'normal', 'unknown' then return
    $.press 'f'

  # next(): void
  next: ->

    if (Config.get 'better-pickup/use-quick-skip') and Scene.is 'event'
      @skip()
      return

    if (Config.get 'better-pickup/use-fast-pickup') and Scene.is 'normal', 'unknown'
      @find()
      return

  # skip(): boolean
  skip: ->

    unless Scene.is 'event' then return false

    Idle.setTimer() # avoid idle
    $.press 'space'

    listColor = [0x806200, 0xFFCC32, 0xFFFFFF]
    p = ColorManager.findAny listColor, [
      '65%', '40%'
      '70%', '80%'
    ]

    unless p then return true

    @click p
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