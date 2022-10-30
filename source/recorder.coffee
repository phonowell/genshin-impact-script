# @ts-check

class RecorderG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/recorder').RecorderG['isActive'] ###
    @isActive = false
    ###* @type import('./type/recorder').RecorderG['list'] ###
    @list = []
    ###* @type import('./type/recorder').RecorderG['ts'] ###
    @ts = 0

  ###* @type import('./type/recorder').RecorderG['init'] ###
  init: ->
    Native 'FileCreateDir, replay'
    Client.on 'idle', @stop

    @on 'record:start', (key) => @record "#{key}:down"
    @on 'record:end', (key) => @record "#{key}:up"

    $.on 'ctrl + numpad-dot', =>
      unless @isActive then @start()
      else @stop()

  ###* @type import('./type/recorder').RecorderG['record'] ###
  record: (key) ->

    unless @isActive then return

    Hud.render 0, key

    now = $.now()
    delay = now - @ts
    @ts = now

    position = ''
    if $.includes key, 'l-button'
      [x, y] = $.getPosition()
      position = $.join [
        "#{$.Math.round x * 100 / Client.width}%"
        "#{$.Math.round y * 100 / Client.height}%"
      ], ','

    $.push @list, {delay, key, position}
    return

  ###* @type import('./type/recorder').RecorderG['reset'] ###
  reset: ->
    @list = []
    @ts = $.now()
    return

  ###* @type import('./type/recorder').RecorderG['save'] ###
  save: ->

    unless $.length @list then return

    result = ''
    for item, i in @list
      {delay, key, position} = item
      if i == 0 then delay = 1e3
      line = $.trim $.join [delay, key, position], ' '
      result = "#{result}#{line}\n"

    f = $.file 'replay/0.txt'
    f.write result

  ###* @type import('./type/recorder').RecorderG['start'] ###
  start: ->

    if Replayer.isActive
      Sound.beep 2
      return

    if @isActive then return
    @isActive = true

    for key in Idle.listKey
      @registerEvent 'record', key
      @registerEvent 'record', "alt + #{key}"
      @registerEvent 'record', "ctrl + #{key}"

    @reset()

    Sound.beep()
    Hud.render 0, 'start recording'

  ###* @type import('./type/recorder').RecorderG['stop'] ###
  stop: ->

    unless @isActive then return
    @isActive = false

    for key in Idle.listKey
      @unregisterEvent 'record', key
      @unregisterEvent 'record', "alt + #{key}"
      @unregisterEvent 'record', "ctrl + #{key}"

    @save()

    Sound.beep()
    Hud.render 0, 'end recording'

# export
Recorder = new RecorderG()