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

    `Menu, Tray, Icon, on.ico,, 1`

    unless $.isExisted Config.data.process
      if Config.data.path then $.open Config.data.path

    $.wait Config.data.process, @init

  # getSize(): void
  getSize: ->

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
    else @isFullScreen = false

  # init(): void
  init: ->
    $.activate Config.data.process

    @watch()

    @on 'pause', =>
      `Menu, Tray, Icon, off.ico`
      @suspend true
      @setPriority 'low'

    @on 'resume', =>
      `Menu, Tray, Icon, on.ico`
      @suspend false
      @setPriority 'normal'
      @getSize()
      @setStyle()
      Timer.add 1e3, @getSize

    @setPriority 'normal'
    @getSize()
    @setStyle()

    $.on 'alt + f4', =>
      Sound.beep 2
      @reset()
      if Config.data.path
        name = "ahk_exe #{Config.data.process}"
        `WinClose, % name`
      Timer.add 1e3, $.exit

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      @getSize()
      @setStyle()
      Timer.add 1e3, @report

    Timer.add 1e3, =>
      @report()
      Upgrader.check()

  # report(): void
  report: -> console.log [
    "client/gdip: #{Config.data.gdip}"
    "client/is-fullscreen: #{@isFullScreen}"
    "client/position: #{@left}, #{@top}"
    "client/size: #{@width}, #{@height}"
  ]

  # reset(): void
  reset: ->
    @setPriority 'normal'
    Timer.reset()

  # setStyle(): void
  setStyle: ->
    $.setStyle Config.data.process, -0x00040000 # border
    $.setStyle Config.data.process, -0x00C00000 # caption
    if @isFullScreen then return
    width = ($.round @width / 80) * 80
    height = $.round width / 16 * 9
    left = (A_ScreenWidth - width) * 0.5
    top = (A_ScreenHeight - height) * 0.5
    name = "ahk_exe #{Config.data.process}"
    `WinMove, % name,, % left, % top, % width, % height`
    @getSize()

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

  # update(): void
  update: ->

    unless $.isActive Config.data.process
      unless @isSuspend then @emit 'pause'
      return

    if @isSuspend
      @emit 'resume'
      return

  # watch(): void
  watch: ->
    interval = 100
    Timer.loop interval, @update

# execute
Client = new ClientX()