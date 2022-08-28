# function

class Recorder extends KeyBinding

  file: ''
  isActive: false
  list: []
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

    `FileCreateDir, replay`

    Client.on 'leave', @stop

    @on 'record:start', (key) => @record "#{key}:down"
    @on 'record:end', (key) => @record "#{key}:up"

    $.on 'ctrl + numpad-dot', =>
      unless @isActive then @start()
      else @stop()

  # log(message: string): void
  log: (message) -> Hud.render 0, message

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

  # reset(): void
  reset: ->
    @list = []
    @ts = $.now()

  # save(): void
  save: ->

    unless $.length @list then return

    result = ''
    for item, i in @list
      {delay, key, position} = item
      if i == 0 then delay = 1e3
      line = $.trim $.join [delay, key, position], ' '
      result = "#{result}#{line}\n"

    file = $.file 'replay/0.txt'
    file.save result

  # start(): void
  start: ->

    if Replayer.isActive
      $.beep 2
      return

    if @isActive then return

    for key in @listWatch
      @registerEvent 'record', key
      @registerEvent 'record', "alt + #{key}"

    @isActive = true
    @reset()

    $.beep()
    @log 'start recording'

  # stop(): void
  stop: ->

    unless @isActive then return

    for key in @listWatch
      @unregisterEvent 'record', key
      @unregisterEvent 'record', "alt + #{key}"

    @isActive = false
    @save()

    $.beep()
    @log 'end recording'

# export
Recorder = new Recorder()