class Console

  isChanged: false
  lifetime: 10e3
  listContent: []

  constructor: ->

    unless Config.data.isDebug then return

    Client.on 'leave', @hide
    @watch()

  # add(msg: string): void
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

  # hide(): void
  hide: -> `ToolTip,, 0, 0, 20`

  # log<T>(input: T): T
  log: (input) ->

    if ($.type input) == 'array'
      for msg in input
        @add msg
    else @add input

    @render()
    return input

  # render(): void
  render: ->
    list = $.map @listContent, (item) -> return item[1]
    text = $.join list, '\n'
    text = $.trim text, ' \n'
    left = 0 - Client.left
    top = Client.height * 0.5
    `ToolTip, % text, % left, % top, 20`

  # update(): void
  update: ->
    now = $.now()
    len = $.length @listContent
    @listContent = $.filter @listContent, (item) -> return item[0] >= now
    if len != $.length @listContent then @render()

  # watch
  watch: ->
    interval = 500
    Client.on 'leave', -> Timer.remove 'console/watch'
    Client.on 'enter', => Timer.loop 'console/watch', interval, @update
    Timer.loop 'console/watch', interval, @update

# execute
console = new Console()