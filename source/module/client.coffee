class ClientX extends EmitterShellX

  height: 0
  isFullScreen: false
  isSuspend: false
  left: 0
  top: 0
  width: 0

  constructor: ->
    super()

    $.setInterval @tick, 200

    @on 'resume', => $.setTimeout @setSize, 1e3
    @setSize()

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
      $.setTimeout @setSize, 1e3

  check: -> return WinActive "ahk_exe #{Config.data.process}"

  point: (input) -> return [
      @vw input[0]
      @vh input[1]
    ]

  reset: ->
    @setPriority 'normal'
    @resetTimer()

  resetTimer: -> for _timer of timer
    $.clearTimeout _timer

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

  setPriority: (level) -> `Process, Priority, % Config.data.process, % level`

  tick: ->
    unless @check()
      unless @isSuspend
        @setPriority 'low'
        @suspend true
        @emit 'pause'
        return
    else
      if @isSuspend
        @setPriority 'normal'
        @suspend false
        @emit 'resume'
        return
      @emit 'tick'

  vh: (n) -> return $.round @height * n * 0.01
  vw: (n) -> return $.round @width * n * 0.01

# execute
client = new ClientX()