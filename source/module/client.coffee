class ClientX extends EmitterShellX

  height: 0
  isFullScreen: false
  isSuspend: false
  width: 0

  constructor: ->
    super()
    @setSize()

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      $.setTimeout @setSize, 1e3

    @on 'enter', => $.setTimeout @setSize, 1e3

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

  checkActive: ->
    return WinActive "ahk_exe #{Config.data.process}"

  point: (input) ->

    # need to be fixed, type-checking
    $$.vt 'client.point', input, ['array', 'function']

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
    `WinGetPos, __x__, __y__, __width__, __height__, % name`

    @width = __width__
    unless @width
      @width = 0

    @height = __height__
    unless @height
      @height = 0

    unless @width + 100 < A_ScreenWidth
      @isFullScreen = true

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

ticker.on 'change', (tick) ->
  unless $.mod tick, 200
    client.check()