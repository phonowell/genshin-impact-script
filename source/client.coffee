### interface
type Fn = () => unknown
type Level = 'high' | 'low' | 'normal'
type Position = [number, number]
###

# function

class ClientX extends EmitterShellX

  height: 0
  isFullScreen: false
  isSuspend: false
  left: 0
  top: 0
  width: 0

  # ---

  constructor: ->
    super()

    interval = 200
    if Config.data.performance == 'low' then interval = 500
    else if Config.data.performance == 'high' then interval = 100
    $.setInterval @tick, interval

    @on 'pause', =>
      `Menu, Tray, Icon, off.ico`
      @setPriority 'low'
      @suspend true

    @on 'resume', =>
      `Menu, Tray, Icon, on.ico`
      @setPriority 'normal'
      @suspend false
      @delay 1e3, @setSize

    `Menu, Tray, Icon, on.ico,, 1`
    @setPriority 'normal'

    @setSize()
    @delay 1e3, @report

    $.on 'alt + f4', =>
      $.beep()
      @reset()
      $.exit()

    $.on 'ctrl + f5', =>
      $.beep()
      @reset()
      $.reload()

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      @delay 1e3, @setSize

  # check(): boolean
  check: -> return WinActive "ahk_exe #{Config.data.process}"

  # delay(id?: string, time?: number, callback?: Fn): void
  delay: (args...) -> # id, time, callback

    len = $.length args
    if len == 1 then [id, time, callback] = [args[0], 0, 0]
    else if len == 2 then [id, time, callback] = ['', args[0], args[1]]
    else [id, time, callback] = args

    hasId = id and id != '~'

    if hasId and timer[id] then $.clearTimeout timer[id]
    unless time then return

    delay = time
    if id[0] == '~' then delay = delay * (1 + $.random() * 0.2) # 100% ~ 120%

    result = $.setTimeout callback, delay
    if hasId then timer[id] = result

  # point(input: Position): Position
  point: (input) -> return [
      @vw input[0]
      @vh input[1]
    ]

  # report(): void
  report: -> console.log [
    "client/is-fullscreen: #{@isFullScreen}"
    "client/performance: #{Config.data.performance}"
    "client/position: #{@left}, #{@top}"
    "client/size: #{@width}, #{@height}"
  ]

  # reset(): void
  reset: ->
    @setPriority 'normal'
    @resetTimer()

  # resetTimer(): void
  resetTimer: -> for _timer of timer
    $.clearTimeout _timer

  # setSize(): void
  setSize: ->

    name = "ahk_exe #{Config.data.process}"
    `WinGetPos, __left__, __top__, __width__, __height__, % name`

    @left = __left__
    @top = __top__
    @width = __width__
    @height = __height__

    for key in ['left', 'top', 'width', 'height']
      unless @[key]
        @[key] = 0

    if @left == 0 and @top == 0 and @width == A_ScreenWidth and @height == A_ScreenHeight
      @isFullScreen = true

    unless @isFullScreen
      @width = @width - 6
      @height = @height - 29

  # suspend: (isSuspend: boolean): void
  suspend: (isSuspend) ->

    if isSuspend
      if @isSuspend then return
      @isSuspend = true
      $.suspend true
      @resetTimer()
      return

    unless isSuspend
      unless @isSuspend then return
      @isSuspend = false
      $.suspend false
      return

  # setPriority(level: Level): void
  setPriority: (level) -> `Process, Priority, % Config.data.process, % level`

  # tick(): void
  tick: ->

    unless @check()
      unless @isSuspend then @emit 'pause'
      return

    if @isSuspend
      @emit 'resume'
      return

    @emit 'tick'

  vh: (n) -> return $.round @height * n * 0.01
  vw: (n) -> return $.round @width * n * 0.01

# execute
Client = new ClientX()