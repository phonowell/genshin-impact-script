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
  name: "ahk_exe #{Config.data.process}"
  top: 0
  width: 0

  # ---

  constructor: ->
    super()

    `Menu, Tray, Icon, on.ico,, 1`

    unless @isExist()
      if Config.data.path then $.open Config.data.path

    `WinWait, % this.name`
    `WinActivate, % this.name`

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

    Timer.add 1e3, @report

    $.on 'alt + f4', =>
      Sound.beep 2
      @reset()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      @getSize()
      @setStyle()
      Timer.add 1e3, @report

  # getSize(): void
  getSize: ->

    `WinGetPos, __left__, __top__, __width__, __height__, % this.name`

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

  # isActive(): boolean
  isActive: -> return WinActive "ahk_exe #{Config.data.process}"

  # isExist(): boolean
  isExist: -> return WinExist "ahk_exe #{Config.data.process}"

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

  # setStyle(): void
  setStyle: ->
    `WinSet, Style, -0x00040000, % this.name` # border
    `WinSet, Style, -0x00C00000, % this.name` # caption
    if @isFullScreen then return
    width = ($.round @width / 80) * 80
    height = $.round width / 16 * 9
    left = (A_ScreenWidth - width) * 0.5
    top = (A_ScreenHeight - height) * 0.5
    `WinMove, % this.name,, % left, % top, % width, % height`
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

    unless @isActive()
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