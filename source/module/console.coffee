class ConsoleX

  lifetime: 5e3
  list: []
  tsLast: 0

  # ---

  check: ->

    if client.isSuspend
      @hide()
      return

    @clean()
    @render()

  clean: ->

    tsNow = $.now()
    unless tsNow - @tsLast >= 1e3
      return
    @tsLast = tsNow

    listResult = []

    for item in @list
      [ts] = item
      if tsNow - ts >= @lifetime
        continue
      listResult.Push item

    @list = listResult

  hide: -> `ToolTip, , 0, 0, 2`

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

    `ToolTip, % text, 0, 0, 2`