class ConsoleX

  intervalCheck: 2e3
  isChanged: false
  lifetime: 10e3
  listContent: []
  tsCheck: 0

  constructor: ->

    unless Config.data.isDebug then return

    Client
      .on 'pause', @hide
      .on 'tick', @check

  add: (msg) ->

    id = ''
    if $.includes msg, ':'
      [id] = $.split msg, ':'

    tsOutdate = $.now() + @lifetime

    unless id then $.push @listContent, [tsOutdate, msg, id]

    hasId = false
    for item, i in @listContent
      unless id == item[2] then continue
      hasId = true
      @listContent[i] = [tsOutdate, msg, id]
      break

    if hasId then return
    $.push @listContent, [tsOutdate, msg, id]

  check: ->

    now = $.now()
    unless now - @tsCheck >= @intervalCheck then return
    @tsCheck = now

    len = $.length @listContent
    @listContent = $.filter @listContent, (item) -> return item[0] >= now
    if len != $.length @listContent then @update()

  hide: -> `ToolTip, , 0, 0, 20`

  log: (input) ->

    if ($.type input) == 'array'
      for msg in input
        @add msg
    else @add input

    @update()
    return input

  update: ->
    list = $.map @listContent, (item) -> return item[1]
    text = $.join list, '\n'
    text = $.trim text, ' \n'
    left = 0 - Client.left
    top = Client.height * 0.5
    `ToolTip, % text, % left, % top, 20`

# execute
console = new ConsoleX()