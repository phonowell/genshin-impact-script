# include include/head.ahk
# include include/js-shim.ahk

class ProcessX

  id: 0
  isExisting: false
  target: ''

  close: ->
    target = @id or @target
    `Process, Close, % target`

  exist: ->
    target = @id or @target
    `Process, Exist, % target`
    return ErrorLevel

  setPriority: (level) ->
    target = @id or @target
    `Process, Priority, % target, % level`

$.process = (target) ->
  __process = new ProcessX()
  __process.target = target
  return __process

notepad = $.process 'notepad.exe'
alert notepad
# unless notepad.exist()
#   $.open 'notepad.exe'
#   $.delay 1e3, -> alert notepad.exist()