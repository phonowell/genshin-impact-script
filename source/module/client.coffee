state.isSuspend = false

class ClientX

  name: 'YuanShen.exe'

  check: ->

    if !state.isSuspend and !@isActive()
      state.isSuspend = true
      $.suspend true
      resetAll()
      @setPriority 'low'
      return

    if state.isSuspend and @isActive()
      state.isSuspend = false
      $.suspend false
      @setPriority 'normal'
      return

  close: ->
    `Process, Close, % this.name`

  isActive: ->
    return WinActive "ahk_exe #{@name}"

  setPriority: (level) ->
    `Process, Priority, % this.name, % level`

  watch: -> setInterval @check, 200
