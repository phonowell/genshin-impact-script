### interface
type Fn = () => unknown
type Level = 'high' | 'low' | 'normal'
type Position = [number, number]
###

# function
class Client extends KeyBinding

  height: 0
  isActive: false
  isFullScreen: false
  isSuspend: false
  left: 0
  top: 0
  width: 0

  constructor: ->
    super()

    `Menu, Tray, Icon, on.ico,, 1`

    unless $.isExisted Config.get 'basic/process'
      if Config.get 'basic/path' then $.open Config.get 'basic/path'

    $.wait (Config.get 'basic/process'), @init

  # getSize(): void
  getSize: ->

    name = "ahk_exe #{Config.get 'basic/process'}"
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

    @watch()
    @watchIdle()

    @on 'leave', =>
      console.log 'client: leave'
      `Menu, Tray, Icon, off.ico`
      @suspend true
      @setPriority 'low'
      @emit 'idle'

    @on 'enter', =>
      console.log 'client: enter'
      `Menu, Tray, Icon, on.ico`
      @suspend false
      @setPriority 'normal'
      @getSize()
      @setStyle()
      Timer.add 1e3, @getSize
      @emit 'activate'

    @on 'activate', =>
      @isActive = true
      console.log 'client: activate'

      Timer.add 'client/watch-idle', 60e3, =>
        if @isSuspend then return
        @emit 'idle'

    @on 'idle', =>
      @isActive = false
      console.log 'client: idle'

    $.on 'alt + f4', => Sound.beep 2, =>
      @reset()
      if Config.get 'basic/path'
        $.minimize Config.get 'basic/process'
        $.close Config.get 'basic/process'
        Sound.unmute()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, =>
      @reset()
      $.reload()

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      @getSize()
      @setStyle()
      Timer.add 1e3, @report

    Timer.add 1e3, =>
      @report()
      Upgrader.check()

    $.activate Config.get 'basic/process'
    Timer.add 200, => @emit 'enter'

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
    $.setStyle (Config.get 'basic/process'), -0x00040000 # border
    $.setStyle (Config. get 'basic/process'), -0x00C00000 # caption
    if @isFullScreen then return
    width = ($.round @width / 80) * 80
    height = $.round width / 16 * 9
    left = (A_ScreenWidth - width) * 0.5
    top = (A_ScreenHeight - height) * 0.5
    name = "ahk_exe #{Config.get 'basic/process'}"
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
  setPriority: (level) ->
    p = Config.get 'basic/process'
    `Process, Priority, % p, % level`

  # update(): void
  update: ->

    unless $.isActive Config.get 'basic/process'
      unless @isSuspend then @emit 'leave'
      return

    if @isSuspend
      @emit 'enter'
      return

  # watch(): void
  watch: ->
    interval = 100
    Timer.loop interval, @update

  # watchIdle(): void
  watchIdle: ->

    listWatch = [
      'esc', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12'
      '1', '2', '3', '4', '5', '6', '7', '8', '9', 'backspace'
      'tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'
      'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'enter'
      'shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm'
      'space'
      'l-button', 'm-button', 'r-button'
    ]

    fn = =>
      unless @isActive then @emit 'activate'
      Timer.add 'client/watch-idle', 60e3, =>
        if @isSuspend then return
        @emit 'idle'

    for key in listWatch
      @registerEvent 'press', key

    @on 'press:start', fn
    @on 'press:end', fn

# execute
Client = new Client()