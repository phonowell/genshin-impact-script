# @ts-check
class TransparentG

  constructor: ->

    n = $.toNumber Config.get 'misc/use-transparency-when-idle'
    unless n then return

    Client.on 'idle', => @set 100 - n
    Client.on 'activate', => @set 100

  ###* @type import('./type/transparent').TransparentG['set'] ###
  set: (n) ->
    name = "ahk_exe #{Config.get 'basic/process'}"
    opacity = 255 * (n / 100)

    $.noop name, opacity
    Native 'WinSet, Transparent, % opacity, % name'
    return

# export
Transparent = new TransparentG()