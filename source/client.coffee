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

    Timer.loop 100, @tick

    @on 'pause', =>
      `Menu, Tray, Icon, off.ico`
      @setPriority 'low'
      @suspend true

    @on 'resume', =>
      `Menu, Tray, Icon, on.ico`
      @setPriority 'normal'
      @suspend false
      Timer.add 1e3, @setSize

    `Menu, Tray, Icon, on.ico,, 1`
    @setPriority 'normal'

    @setSize()
    Timer.add 1e3, @report

    $.on 'alt + f4', =>
      Sound.beep 2
      @reset()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      Timer.add 1e3, @setSize

  # check(): boolean
  check: -> return WinActive "ahk_exe #{Config.data.process}"

  # point(input: Position): Position
  point: (input) -> return [
      @vw input[0]
      @vh input[1]
    ]

  # report(): void
  report: -> console.log [
    "client/is-fullscreen: #{@isFullScreen}"
    "client/position: #{@left}, #{@top}"
    "client/size: #{@width}, #{@height}"
  ]

  # reset(): void
  reset: ->
    @setPriority 'normal'
    Timer.reset()

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