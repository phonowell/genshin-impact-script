# @ts-check
class TransparentG

  ###* @type import('./type/transparent').TransparentG['init'] ###
  init: ->
    n = $.toNumber Config.get 'misc/use-transparency-when-idle'
    unless n then return

    Client.useActive =>
      @set 100
      return => @set 100 - n

  ###* @type import('./type/transparent').TransparentG['set'] ###
  set: (n) ->
    name = "ahk_exe #{Config.get 'basic/process'}"
    opacity = 255 * (n / 100)

    $.noop name, opacity
    Native 'WinSet, Transparent, % opacity, % name'
    return

# export
Transparent = new TransparentG()