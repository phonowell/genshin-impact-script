class RecorderX

  current: 0
  file: {}
  isActive: false
  list: []
  listHotkey: ['h', 'i', 'n', 't', 'u']
  listIgnore: []
  ts: 0

  constructor: ->

    @file.replay = $.file 'replay.txt'
    for key in @listHotkey
      @file[key] = $.file "replay-#{key}.txt"

    client.on 'leave', @stop

    $.on 'f11', @replay

    $.on 'f10', =>
      unless @isActive
        @ignore 'f10'
        @start()
      else
        @stop()
        @save()

  ignore: (key) ->

    $$.vt 'record.ignore', key, 'string'

    unless key
      @listIgnore = []
      return

    if $.includes @listIgnore, key
      return
    $.push @listIgnore, key

  log: (message) ->

    $$.vt 'record.log', message, 'string'

    hud.render 5, message

  next: (list) ->

    $$.vt 'record.next', list, 'array'

    n = @current
    if n >= $.length list
      @log 'end playing'
      $.beep()
      return

    [delay, key, position] = list[n]
    $.setTimeout =>
      if ($.includes key, 'l-button') && position
        point = client.point $.split position, ','
        $.move point
      $.trigger key
      @current++
      @next list
    , delay

  record: (key) ->

    $$.vt 'record.record', key, 'string'

    unless @isActive
      return

    if $.includes @listIgnore, key
      return

    @log key

    now = $.now()
    delay = now - @ts
    @ts = now

    position = ''
    if $.includes key, 'l-button'
      [x, y] = $.getPosition()
      x = $.round x * 100 / client.width
      y = $.round y * 100 / client.height
      position = $.join [x, y], ','

    $.push @list, {delay, key, position}

  replay: (key = 'replay') ->

    list = []
    @current = 0

    content = @file[key].load()
    unless content
      return

    for item in $.split content, '\n'

      unless item
        continue

      [delay, key, position] = $.split item, '|'
      $.push list, [delay, key, position]

    @log 'start playing'
    $.beep()
    @next list

  save: ->

    unless $.length @list
      return

    result = ''
    for item in @list
      line = $.join [
        item.delay
        item.key
        item.position
      ], '|'
      line = $.trim line, '|'
      result = "#{result}#{line}\n"
    @file.replay.save result

  start: ->

    if @isActive
      return

    @isActive = true
    @list = []
    @ts = $.now()

    @log 'start recording'
    $.beep()

  stop: ->

    unless @isActive
      return

    @isActive = false

    @log 'end recording'
    $.beep()

# execute
recorder = new RecorderX()