# @ts-check

do ->

  # report(): void
  report = ->
    {isFullScreen, x, y, width, height} = Client
    $.forEach [
      "client/is-fullscreen: #{isFullScreen}"
      "client/position: #{x}, #{y}"
      "client/size: #{width}, #{height}"
    ], (msg) -> console.log msg

  # execute

  Client.window.focus()

  Timer.add 200, ->
    Client.emit 'enter'
    report()

  Timer.add 1e3, Upgrader.check

# auto scan
do ->

  unless Config.get 'skill-timer/enable' then return

  token = 'change.auto-scan'

  autoScan = ->
    unless Scene.is 'normal', 'not-busy', 'not-multi' then return
    Scene.off token
    Party.scan()

  addListener = ->
    Scene.off token
    Scene.on token, autoScan

  Scene.on 'change', ->
    unless Scene.is 'party' then return
    addListener()

  addListener()

# clear party
do ->

  Scene.on 'change', ->
    unless Party.size then return
    unless Scene.is 'multi' then return
    $.trigger 'alt + f12'

# pick color
do ->
  unless Config.get 'debug/enable' then return
  $.on 'alt + f9', ColorManager.pick