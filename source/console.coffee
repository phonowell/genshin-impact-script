class ConsoleX

  lifetime: 5e3
  list: []
  tsClean: 0

  constructor: ->

    unless Config.data.isDebug then return

    client
      .on 'pause', @hide
      .on 'tick', @update

    $.on 'alt + f9', =>
      $.beep()
      @pickColor()

  clean: ->

    now = $.now()
    unless now - @tsClean >= 1e3
      return
    @tsClean = now

    listResult = []

    for item in @list
      if now >= item[0]
        continue
      $.push listResult, item

    @list = listResult

  hide: -> `ToolTip, , 0, 0, 20`

  log: (input) ->

    tsOutdate = $.now() + @lifetime

    if ($.type input) == 'array'
      for msg in input
        $.push @list, [tsOutdate, msg]
    else $.push @list, [tsOutdate, input]

    return input

  pickColor: ->

    color = $.getColor()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / client.width
    y1 = $.round (y * 100) / client.height

    @log "#{x1}, #{y1} / #{color}"
    ClipBoard = color

  render: ->

    text = ''
    for item in @list
      text = "#{text}\n#{item[1]}"
    text = $.trim text, ' \n'

    `ToolTip, % text, 0, 0, 20`

  update: ->

    if client.isSuspend
      return

    @clean()
    @render()

# execute
console = new ConsoleX()