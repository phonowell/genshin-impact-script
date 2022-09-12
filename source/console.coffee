class Console

  isChanged: false
  lifetime: 10e3
  listContent: []

  constructor: ->
    @watch()

  # add(msg: string): void
  add: (msg) ->

    id = ''
    if $.includes msg, ':'
      [id, string] = $.split msg, ':'
      if ($.length msg) > 40
        msg = "#{id}:\n  #{$.trim string}"

    tsOutdate = $.now() + @lifetime

    unless id
      $.push @listContent, [tsOutdate, msg, id]
      return

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

  # log<T>(ipt: T): T
  log: (ipt) ->

    unless Config.get 'debug' then return ipt

    if ($.type ipt) == 'array'
      for msg in ipt
        @add msg
    else @add ipt

    @render()
    return ipt

  # render(): void
  render: $.throttle 500, =>
    unless Client.isActive then return
    list = $.map @listContent, (item) -> return item[1]
    text = $.trim ($.join list, '\n'), ' \n'
    [left, top] = [0 - Client.left, Client.height * 0.5]
    `ToolTip, % text, % left, % top, 20`

  # update(): void
  update: ->
    unless Client.isActive then return
    now = $.now()
    len = $.length @listContent
    @listContent = $.filter @listContent, (item) -> return item[0] >= now
    if len != $.length @listContent then @render()

  # watch
  watch: ->

    unless Config.get 'debug' then return

    interval = 500
    token = 'console/watch'

    Client.on 'idle', =>
      Timer.remove token
      @hide()

    Client.on 'activate', =>
      Timer.loop token, interval, @update
      @update()

# execute
console = new Console()