# @ts-check

aboutCaps = ->
  Client.on 'activate', -> Native 'SetCapsLockState, Off'
  $.on 'CapsLock', -> $.beep()

aboutClient = ->
  report = ->
    {isFullScreen, x, y, width, height} = Client
    $.forEach [
      "#client/is-fullscreen: #{isFullScreen}"
      "#client/position: #{x}, #{y}"
      "#client/size: #{width}, #{height}"
    ], (msg) -> console.log msg

  Client.window.focus()

  Timer.add 200, ->
    Client.emit 'enter'
    report()

  Timer.add 1e3, Upgrader.check

aboutDebug = ->
  unless Config.get 'debug/enable' then return
  $.on 'alt + f9', ColorManager.pick

aboutSkillTimer = ->

  unless Config.get 'skill-timer/enable' then return

  # auto scan

  token = 'change.auto-scan'

  autoScan = ->
    unless Scene.is 'normal', 'not-busy', 'not-multi', 'not-using-q' then return
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

  Scene.on 'change', ->
    unless Party.size then return
    unless Scene.is 'multi' then return
    $.trigger 'alt + f12'

boot = (callback) ->

  list = [
    Dictionary
    Config

    Client
    console
    Idle
    Indicator

    Character
    Gdip
    Sound
    Transparent

    Scene
    Party
    Hud

    Camera
    Menu2
    Skill
    Movement
    Jumper

    Picker
    Tactic
    Fishing

    Recorder
    Replayer

    Alice
    Controller
  ]

  for m in list
    unless $.isFunction m.init
      $.setTimeout ->
        boot callback
      , 100
      return

  $.forEach list, (m) -> m.init()
  callback()
  return

# boot
boot ->
  aboutCaps()
  aboutClient()
  aboutSkillTimer()
  aboutDebug()
