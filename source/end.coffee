do ->

  # report(): void
  report = ->
    {isFullScreen, left, top, width, height} = Client
    console.log [
      "client/is-fullscreen: #{isFullScreen}"
      "client/position: #{left}, #{top}"
      "client/size: #{width}, #{height}"
    ]

  # execute

  Client.focus()

  Timer.add 200, ->
    Client.emit 'enter'
    report()

  Timer.add 1e3, Upgrader.check