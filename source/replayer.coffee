### interface
type Item = [number, string, string]
###

# function

class Replayer

  isActive: false
  listTrigger: [
    'f11', 'f12'
    '1', '2', '3', '4', '5'
    'w'
    'a', 's', 'd', 'f'
    'l-button', 'm-button', 'r-button'
  ]

  constructor: ->

    for key in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      $.on "ctrl + numpad-#{key}", =>
        if @isActive then @stop()
        @start key

  # execute(list: string[], callback: Fn): void
  execute: (list, callback) ->

    if list[0] == '@input'
      value = list[1]
      `Send, % value`
      callback()
      return

    if list[0] == '@run' or list[0] == '@play'
      value = list[1]
      @start value, callback
      return

    if list[0] == '@sleep'
      value = list[1]
      Timer.add value, callback
      return

  # fire(key: string): void
  fire: (key) ->

    if $.includes @listTrigger, $.replace(($.split key, ':')[0], 'alt + ', '')
      $.trigger key
      return

    $.press key

  # log(message: string): void
  log: (message) -> Hud.render 0, message

  # next(list: Item[], i: number, callback?: Fn): void
  next: (list, i, callback = '') ->

    if i >= $.length list
      @isActive = false
      if callback then callback()
      @log 'end replaying'
      return

    console.log "replay: #{$.join list[i], ' '}"
    token = 'replayer/next'

    if $.startsWith list[i][0], '@'
      Timer.add token, 50, => @execute list[i], => @next list, i + 1, callback
      return

    [delay, key, position] = list[i]
    if delay < 1 then delay = 1 # to make it works
    Timer.add token, delay, =>
      if ($.includes key, 'l-button') and position
        $.move Point.create $.split position, ','
      @fire key
      @next list, i + 1, callback

  # start(key = '0', callback?: Fn): void
  start: (key = '0', callback = '') ->

    @stop()

    if Recorder.isActive
      $.beep()
      return

    file = $.file "replay/#{key}.txt"
    content = file.load()
    unless content then return

    list = []
    for item in $.split content, '\n'
      item = $.trim item
      unless item then continue
      if $.startsWith item, '#' then continue
      item = RegExReplace item, '\s+', ' '
      $.push list, $.split item, ' '

    @isActive = true
    @next list, 0, callback
    @log 'start replaying'

  # stop(): void
  stop: ->

    unless @isActive then return
    @isActive = false

    Timer.remove 'replayer/next'
    @log 'stop replaying'

# export
Replayer = new Replayer()