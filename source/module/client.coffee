class ClientX

  height: 0
  state:
    isSuspend: false
  width: 0

  check: ->

    unless @width
      size = @getSize()
      @width = size[0]
      @height = size[1]

    if !@state.isSuspend and !@isActive()
      @setPriority 'low'
      @suspend true
      state.isAttacking = false
      return

    if @state.isSuspend and @isActive()
      @setPriority 'normal'
      @suspend false
      return

  getSize: ->
    name = "ahk_exe #{config.data.process}"
    `WinGetPos, __x__, __y__, __width__, __height__, % name`
    return [__width__, __height__]

  isActive: ->
    return WinActive "ahk_exe #{config.data.process}"

  reset: ->
    @setPriority 'normal'
    @resetTimer()
    @resetKey()

  resetKey: ->

    for key in ['middle', 'right']
      if $.getState key
        $.click "#{key}:up"

    for key in [
      'alt', 'ctrl'
      'e', 'esc', 'f', 'space', 'w', 'x'
    ]
      if $.getState key
        $.press "#{key}:up"

    paimon.resetKey()

  resetTimer: ->

    for _timer of timer
      clearTimeout _timer

  suspend: (isSuspend) ->

    if isSuspend
      if @state.isSuspend then return
      @state.isSuspend = true
      $.suspend true
      @resetTimer()
      @resetKey()
      return

    unless isSuspend
      unless @state.isSuspend then return
      @state.isSuspend = false
      $.suspend false
      return

  setPriority: (level) ->
    `Process, Priority, % config.data.process, % level`

  watch: -> setInterval @check, 200
