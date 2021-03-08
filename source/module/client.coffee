class ClientX extends EmitterShellX

  height: 0
  isSuspend: false
  width: 0

  constructor: ->
    super()
    @setSize()

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
    `WinGetPos, __x__, __y__, __width__, __height__, % name`

    @width = __width__
    @height = __height__

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
    `Process, Priority, % Config.data.process, % level`

  vh: (n) -> return $.round @height * n * 0.01

  vw: (n) -> return $.round @width * n * 0.01

# execute

client = new ClientX()

ticker.on 'change', (tick) ->
  unless Mod tick, 200
    client.check()