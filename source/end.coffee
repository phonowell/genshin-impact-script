# @ts-check

$.setTimeout ->

  do -> # init
    Dictionary.init()
    Config.init()

    Client.init()
    console.init()
    Idle.init()
    Indicator.init()

    Character.init()
    Gdip.init()
    Sound.init()
    Transparent.init()

    Scene.init()
    Party.init()
    Hud.init()

    Camera.init()
    Menu2.init()
    Skill.init()
    Movement.init()
    Jumper.init()

    Picker.init()
    Tactic.init()
    Fishing.init()

    Recorder.init()
    Replayer.init()

    Controller.init()
    # Alice.init()

  do -> # client

    report = ->
      {isFullScreen, x, y, width, height} = Client
      $.forEach [
        "client/is-fullscreen: #{isFullScreen}"
        "client/position: #{x}, #{y}"
        "client/size: #{width}, #{height}"
      ], (msg) -> console.log msg

    Client.window.focus()

    Timer.add 200, ->
      Client.emit 'enter'
      report()

    Timer.add 1e3, Upgrader.check

  do -> # auto scan

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

  do -> # clear party

    unless Config.get 'skill-timer/enable' then return

    Scene.on 'change', ->
      unless Party.size then return
      unless Scene.is 'multi' then return
      $.trigger 'alt + f12'

  do -> # debug
    unless Config.get 'debug/enable' then return
    $.on 'alt + f9', ColorManager.pick

, 200