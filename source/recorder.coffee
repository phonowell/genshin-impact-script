### interface
type Fn = () => unknown
type Item = [number, string, string]
###

# function

class Recorder extends KeyBinding

  current: 0
  file: {}
  isPlaying: false
  isRecording: false
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

    `FileCreateDir, replay`

    @file.default = $.file 'replay/0.txt'
    $.on 'ctrl + numpad-0', =>
      if @isPlaying then @stopReplaying
      @replay()

    for key in [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @file[key] = $.file "replay/#{key}.txt"
      $.on "ctrl + numpad-#{key}", =>
        if @isPlaying then @stopReplaying()
        @replay key

    Client.on 'leave', @stop

    @on 'record:start', (key) => @record "#{key}:down"
    @on 'record:end', (key) => @record "#{key}:up"


    $.on 'ctrl + numpad-dot', =>
      unless @isRecording then @startRecording()
      else @stopRecording()



  # execute(list: string[], callback: Fn): void
  execute: (list, callback) ->

    if list[0] == '@input'
      value = list[1]
      `Send, % value`
      callback()
      return

    if list[0] == '@run' or list[0] == '@play'
      value = list[1]
      @file.temp = $.file "replay/#{value}.txt"
      @replay 'temp', callback
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
      $.beep 3
      @isPlaying = false
      if callback then callback()
      @log 'end replaying'
      return

    [delay, key, position] = list[i]
    console.log "replay: #{delay} #{key} #{position}"

    if $.startsWith delay, '@'
      Timer.add 'replay/next', 50, => @execute list[i], => @next list, i + 1, callback
      return

    Timer.add 'replay/next', delay, =>
      if ($.includes key, 'l-button') and position
        $.move Point.new $.split position, ','
      @fire key
      @next list, i + 1, callback

  # record(key: string): void
  record: (key) ->

    unless @isRecording then return

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

  # replay(key = 'default', callback?: Fn): void
  replay: (key = 'default', callback = '') ->

    if @isRecording
      $.beep()
      return

    content = @file[key].load()
    unless content then return

    list = []
    for item in $.split content, '\n'
      item = $.trim item
      unless item then continue
      if $.startsWith item, '#' then continue
      item = RegExReplace item, '\s+', ' '
      $.push list, $.split item, ' '

    $.beep 3
    @isPlaying = true
    @next list, 0, callback
    @log 'start replaying'

  # save(): void
  save: ->

    unless $.length @list then return

    result = ''
    for item, i in @list
      {delay, key, position} = item
      if i == 0 then delay = 1e3
      line = $.trim $.join [delay, key, position], ' '
      result = "#{result}#{line}\n"

    @file.default.save result

  # startRecording(): void
  startRecording: ->

    if @isPlaying
      $.beep()
      return

    if @isRecording then return

    for key in @listWatch
      @registerEvent 'record', key
      @registerEvent 'record', "alt + #{key}"

    @isRecording = true
    @list = []
    @ts = $.now()

    $.beep 2
    @log 'start recording'

  # stopRecording(): void
  stopRecording: ->

    unless @isRecording then return

    for key in @listWatch
      @unregisterEvent 'record', key
      @unregisterEvent 'record', "alt + #{key}"

    @isRecording = false
    @save()

    $.beep 2
    @log 'end recording'

  # stopReplaying(): void
  stopReplaying: ->

    unless @isPlaying then return
    @isPlaying = false

    Timer.remove 'replay/next'

    $.beep()
    @log 'stop replaying'


# execute
Recorder = new Recorder()