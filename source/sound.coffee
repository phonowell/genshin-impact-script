# @ts-check

import '../../gis-static/lib/ShiftAppVolume.ahk'

class SoundG

  constructor: ->

    ###* @type import('./type/sound').SoundG['index'] ###
    @index = 0

    ###* @type import('./type/sound').SoundG['namespace'] ###
    @namespace = 'sound'

  ###* @type import('./type/sound').SoundG['beep'] ###
  beep: (n = 1, callback = undefined) ->

    unless Config.get 'misc/use-beep'
      if $.isFunction callback then callback()
      return

    $.beep()

    if n == 1
      if $.isFunction callback then callback()
      return
    @index = 1

    Timer.loop 'sound/beep', 200, =>
      $.beep()
      @index++
      if @index >= n
        Timer.remove 'sound/beep'
        if $.isFunction callback then callback()

  ###* @type import('./type/sound').SoundG['init'] ###
  init: ->

    unless Config.get 'misc/use-mute'
      @unmute()
      return

    Client.useActive =>
      @unmute()
      return @mute

  ###* @type import('./type/sound').SoundG['mute'] ###
  mute: -> ShiftAppVolumeTopped ($.toString Config.get 'basic/process'), 0

  ###* @type import('./type/sound').SoundG['unmute'] ###
  unmute: -> ShiftAppVolumeTopped ($.toString Config.get 'basic/process'), 1

# @ts-ignore
Sound = new SoundG()