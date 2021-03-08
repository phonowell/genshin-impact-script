class RecorderX

  current: 0
  file: ''
  isActive: false
  list: []
  listIgnore: []
  ts: 0

  constructor: ->

    @file = $.file 'replay.txt'

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

    unless key
      @listIgnore = []
      return

    if $.includes @listIgnore, key
      return
    $.push @listIgnore, key

  next: (list) ->

    n = @current
    if n >= $.length list
      $$.log 'end playing'
      $.beep()
      return

    [delay, key] = list[n]
    $.delay delay, =>
      $.trigger key
      @current++
      @next list

  record: (key) ->

    unless @isActive
      return

    if $.includes @listIgnore, key
      return

    $$.log key

    now = $.now()
    delay = now - @ts
    @ts = now

    $.push @list, {delay, key}

  replay: ->

    list = []
    @current = 0

    for item in $.split @file.load(), '\n'

      unless item
        continue

      [delay, key] = $.split item, '|'
      $.push list, [delay, key]

    $.delay 500, =>
      $$.log 'start playing'
      $.beep()
      @next list

  save: ->

    unless $.length @list
      return

    result = ''
    for item in @list
      result = "#{result}#{item.delay}|#{item.key}\n"
    @file.save result

  start: ->

    if @isActive
      return

    @isActive = true
    @list = []
    @ts = $.now()

    $$.log 'start recording'
    $.beep()

  stop: ->

    unless @isActive
      return

    @isActive = false

    $$.log 'end recording'
    $.beep()

# execute
recorder = new RecorderX()