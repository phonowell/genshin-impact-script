class ClientX

  name: 'YuanShen.exe'
  state:
    isSuspend: false

  check: ->

    if !@state.isSuspend and !@isActive()
      @setPriority 'low'
      @suspend true
      return

    if @state.isSuspend and @isActive()
      @setPriority 'normal'
      @suspend false
      return

  close: ->
    `Process, Close, % this.name`

  isActive: ->
    return WinActive "ahk_exe #{@name}"

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
      'f4', 'f5'
      'e', 'f', 's', 'space', 'w', 'x'
    ]
      if $.getState key
        $.press "#{key}:up"

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
    `Process, Priority, % this.name, % level`

  watch: -> setInterval @check, 200
