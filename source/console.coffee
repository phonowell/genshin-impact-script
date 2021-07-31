class ConsoleX

  intervalCheck: 2e3
  isChanged: false
  lifetime: 10e3
  listContent: []
  tsCheck: 0

  constructor: ->

    unless Config.data.isDebug then return

    client
      .on 'pause', @hide
      .on 'tick', @check

  check: ->

    now = $.now()
    unless now - @tsCheck >= @intervalCheck then return
    @tsCheck = now

    len = $.length @listContent
    @listContent = $.filter @listContent, (item) -> return item[0] >= now
    if len != $.length @listContent then @update()

  hide: -> `ToolTip, , 0, 0, 20`

  log: (input) ->

    tsOutdate = $.now() + @lifetime

    if ($.type input) == 'array'
      for msg in input
        $.push @listContent, [tsOutdate, msg]
    else $.push @listContent, [tsOutdate, input]

    @update()
    return input

  update: ->
    list = $.map @listContent, (item) -> return item[1]
    text = $.join list, '\n'
    text = $.trim text, ' \n'
    left = 0 - client.left
    top = client.height * 0.5
    `ToolTip, % text, % left, % top, 20`

# execute
console = new ConsoleX()