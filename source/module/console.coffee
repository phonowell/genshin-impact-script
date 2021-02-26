class ConsoleX

  lifetime: 5e3
  list: []
  tsClean: 0

  # ---

  constructor: -> client.on 'leave', @hide

  check: ->

    if client.isSuspend
      return

    @clean()
    @render()

  clean: ->

    now = $.now()
    unless now - @tsClean >= 1e3
      return
    @tsClean = now

    listResult = []

    for item in @list
      [ts] = item
      if now - ts >= @lifetime
        continue
      listResult.Push item

    @list = listResult

  hide: -> `ToolTip, , 0, 0, 20`

  log: (input) ->

    switch $.type input
      when 'array'
        for msg in input
          @list.Push [$.now(), msg]
      else @list.Push [$.now(), input]

    return input

  render: ->

    text = ''
    for item in @list
      text = "#{text}\n#{item[1]}"
    text = $.trim text, ' \n'

    `ToolTip, % text, 0, 0, 20`

# execute

console = new ConsoleX()

ticker.on 'change', (tick) ->
  if Mod tick, 500
    return
  console.check()