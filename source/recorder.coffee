### interface
type Item = [number, string, string]
###

# function

class Recorder extends KeyBinding

  current: 0
  file: {}
  isActive: false
  isPlaying: false
  list: []
  listTrigger: [
    'f11', 'f12'
    '1', '2', '3', '4', '5'
    'w'
    'a', 's', 'd', 'f'
    'l-button', 'm-button', 'r-button'
  ]
  listWatch: [
    'esc', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12'
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'backspace'
    'tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'enter'
    'shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm'
    'space'
    'l-button', 'm-button', 'r-button'
  ]
  ts: 0

  constructor: ->
    super()

    @file.default = $.file 'replay-0.txt'
    for key in [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @file[key] = $.file "replay-#{key}.txt"
      $.on "ctrl + numpad-#{key}", => @replay key

    Client.on 'leave', @stop

    @on 'record:start', (key) => @record "#{key}:down"
    @on 'record:end', (key) => @record "#{key}:up"

    $.on 'ctrl + numpad-0', @replay

    $.on 'ctrl + numpad-dot', =>
      unless @isActive then @start()
      else @stop()

  # fire(key: string): void
  fire: (key) ->

    if $.includes @listTrigger, $.replace(($.split key, ':')[0], 'alt + ', '')
      $.trigger key
      return

    $.press key

  # log(message: string): void
  log: (message) -> Hud.render 0, message

  # next(list: Item[], i: number): void
  next: (list, i) ->

    unless @isPlaying
      $.beep()
      @resetAllPressedKeys()
      @log 'cancel replaying'
      return

    if i >= $.length list
      $.beep 3
      @isPlaying = false
      @resetAllPressedKeys()
      @log 'end replaying'
      return

    [delay, key, position] = list[i]
    console.log "replay: #{delay} | #{key} | #{position}"
    Timer.add delay, =>
      if ($.includes key, 'l-button') and position
        $.move Point.new $.split position, ','
      @fire key
      @next list, i + 1

  # record(key: string): void
  record: (key) ->

    unless @isActive then return

    @log key

    now = $.now()
    delay = now - @ts
    @ts = now

    position = ''
    if $.includes key, 'l-button'
      [x, y] = $.getPosition()
      position = $.join [
        "#{$.round x * 100 / Client.width}%"
        "#{$.round y * 100 / Client.height}%"
      ], ','

    $.push @list, {delay, key, position}

  # replay(key = 'default'): void
  replay: (key = 'default') ->

    if @isActive
      $.beep()
      return

    if @isPlaying
      @isPlaying = false
      return

    content = @file[key].load()
    unless content then return

    list = []
    for item in $.split content, '\n'
      unless item then continue
      $.push list, $.split item, '|'

    $.beep 3
    @isPlaying = true
    @next list, 0
    @log 'start replaying'

  # save(): void
  save: ->

    unless $.length @list then return

    result = ''
    for item, i in @list
      {delay, key, position} = item
      if i == 0 then delay = 1e3
      line = $.trim ($.join [delay, key, position], '|'), '|'
      result = "#{result}#{line}\n"

    @file.default.save result

  # start(): void
  start: ->

    if @isActive then return

    if @isPlaying
      $.beep()
      return

    for key in @listWatch
      @registerEvent 'record', key
      @registerEvent 'record', "alt + #{key}"

    @isActive = true
    @list = []
    @ts = $.now()

    $.beep 2
    @log 'start recording'

  # stop(): void
  stop: ->

    unless @isActive then return

    for key in @listWatch
      @unregisterEvent 'record', key
      @unregisterEvent 'record', "alt + #{key}"

    @isActive = false
    @resetAllPressedKeys()
    @save()

    $.beep 2
    @log 'end recording'


# execute
Recorder = new Recorder()