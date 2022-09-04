# function

class Picker extends KeyBinding

  tsPick: 0

  constructor: ->
    super()
    @init()
    @watch()

  # checkShape(p: Point): boolean
  checkShape: (p) ->
    if !p then return false

    [x, y] = p
    c1 = ColorManager.format ColorManager.get [x, y + 1]
    c2 = ColorManager.format ColorManager.get [x + 1, y]
    # console.log "test: #{c1} #{c2}"

    # 0xFFFFFF, 0xFFFFFF chat, cook, gear
    if c1 == 0xFFFFFF and c2 == 0xFFFFFF then return true

    # 0xFFFFFF, 0xFEFEFE magnifier
    if c1 == 0xFFFFFF and c2 == 0xFEFEFE then return true

    # 0xF8F9F9, 0xFDFDFE hook
    # 0xFBFBFB, 0xFFFFFF hook
    if c1 == 0xF8F9F9 and c2 == 0xFDFDFE then return true
    if c1 == 0xFBFBFB and c2 == 0xFFFFFF then return true

    return false

  # click(p: Point): void
  click: (p) ->
    p = Point.create p
    old = $.getPosition()
    $.move p
    $.click()
    Timer.add 50, -> $.move old

  # find(): void
  find: ->

    if @isPressed['f'] then return
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
        '61%', y - Point.h 1
        '63%', y
      ]
      if @checkShape p then return

    $.press 'f'

  # findTitleColor(y: number): string | false
  findTitleColor: (y) ->

    p = ColorManager.findAny [
      0xFFFFFF
      0xCCCCCC
      0xACFF45
      0x4FF4FF
      0xF998FF
    ], [
      '63%', y
      '65%', y + 20
    ]

    if p then return p[2]
    else return 0

  # init(): void
  init: ->

    @registerEvent 'pick', 'f'
    @on 'pick:start', =>
      @tsPick = $.now()
      console.log 'picker/is-picking: true'

    @on 'pick:end', =>
      @tsPick = $.now()
      console.log 'picker/is-picking: false'

  # listen(): void
  listen: ->
    diff = $.now() - @tsPick
    unless diff > 350 then return
    unless @isPressed['f'] then return
    if @skip() then return
    unless Scene.is 'normal', 'unknown' then return
    $.press 'f'

  # next(): void
  next: ->

    unless Config.get 'better-pickup'
      @listen()
      return

    if @isPressed['f']
      @listen()
      return

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
    if @isPressed['f'] then $.press 'f'
    else $.press 'space'

    p = ColorManager.findAny [
      0x806200
      0xFFCC32
      0xFFFFFF
    ], [
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

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @next

# execute
Picker = new Picker()