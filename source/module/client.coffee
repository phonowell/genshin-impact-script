class ClientX extends KeyBindingX

  height: 0
  isFullScreen: false
  isSuspend: false
  left: 0
  top: 0
  width: 0

  constructor: ->
    super()
    @setSize()

    ticker.on 'change', (tick) =>
      unless $.mod tick, 200
        @check()

    @on 'enter', => $.setTimeout @setSize, 1e3

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

  check: ->

    if !@isSuspend and !@checkActive()
      @setPriority 'low'
      @suspend true
      @emit 'leave'
      return

    if @isSuspend and @checkActive()
      @setPriority 'normal'
      @suspend false
      @emit 'enter'
      return

  checkActive: -> return WinActive "ahk_exe #{Config.data.process}"

  point: (input) ->

    $$.vt 'client.point', input, 'array'

    return [
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

    # console.log [
    #   "left: #{@left}"
    #   "top: #{@top}"
    #   "width: #{@width}"
    #   "height: #{@height}"
    #   "isFullScreen: #{@isFullScreen}"
    # ]

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

  setPriority: (level) ->
    $$.vt 'client.setPriority', level, 'string'
    `Process, Priority, % Config.data.process, % level`

  vh: (n) ->
    $$.vt 'client.vh', n, 'number'
    return $.round @height * n * 0.01

  vw: (n) ->
    $$.vt 'client.vw', n, 'number'
    return $.round @width * n * 0.01

# execute
client = new ClientX()