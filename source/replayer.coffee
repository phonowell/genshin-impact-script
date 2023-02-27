# @ts-check

class ReplayerG

  constructor: ->

    ###* @type import('./type/replayer').ReplayerG['isActive'] ###
    @isActive = false
    ###* @type import('./type/replayer').ReplayerG['token'] ###
    @token = 'replayer/next'

  ###* @type import('./type/replayer').ReplayerG['asMark'] ###
  asMark: (list, callback) ->

    # @input a
    if list[0] == '@input'
      value = list[1]
      Native 'Send, % value'
      callback()
      return

    # @paste a
    if list[0] == '@paste'
      value = list[1]
      ClipBoard = value
      Timer.add 50, ->
        $.press 'ctrl + v'
        Timer.add 50, ->
          ClipBoard = ''
          $.noop ClipBoard
          callback()
      return

    # @run a
    if list[0] == '@run' or list[0] == '@play'
      value = list[1]
      @start value, callback
      return

    # @sleep 100
    if list[0] == '@sleep'
      n = $.toNumber list[1]
      Timer.add n, callback
      return

  ###* @type import('./type/replayer').ReplayerG['init'] ###
  init: -> Client.useActive =>

    for n in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      $.on "ctrl + numpad-#{n}", => @start $.toString n

    return =>

      for n in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        $.off "ctrl + numpad-#{n}"

      @stop()

  ###* @type import('./type/replayer').ReplayerG['next'] ###
  next: (list, i, callback = undefined) ->

    if i >= $.length list
      @stop()
      if callback then callback()
      return

    if $.startsWith list[i][0], '@'
      Timer.add @token, 50, =>
        @asMark list[i], =>
          @next list, i + 1, callback
      return

    [stringDelay, key, position] = list[i]
    delay = $.Math.max 1, $.toNumber stringDelay

    Timer.add @token, delay, =>
      if ($.includes key, 'l-button') and position
        $.move Point.create $.split position, ','
      $.trigger key
      @next list, i + 1, callback

  ###* @type import('./type/replayer').ReplayerG['start'] ###
  start: (key = '0', callback = undefined) ->

    @stop()

    if @isActive then return
    @isActive = true

    if Recorder.isActive
      Sound.beep 2
      return

    f = $.file "replay/#{key}.txt"
    content = f.read()
    unless content then return

    list = []
    for item in $.split content, '\n'

      item = $.trim item
      unless item then continue

      if $.startsWith item, '#' then continue

      item = $.replace item, '\s+', ' '
      $.push list, $.split item, ' '

    @next list, 0, callback
    Hud.render 0, Dictionary.get 'start_replaying'

  ###* @type import('./type/replayer').ReplayerG['stop'] ###
  stop: ->

    unless @isActive then return
    @isActive = false

    Timer.remove @token
    Hud.render 0, Dictionary.get 'end_replaying'

# @ts-ignore
Replayer = new ReplayerG()