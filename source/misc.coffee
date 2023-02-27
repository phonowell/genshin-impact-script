# @ts-check

aboutCaps = -> Scene.useExact ['normal'], ->
  Native 'SetCapsLockState, Off'
  $.on 'CapsLock', -> Sound.beep()
  return -> $.off 'CapsLock'

aboutClient = ->
  report = ->
    {x, y, width, height} = Window2.bounds
    $.forEach [
      "#client/bounds: #{x}, #{y}, #{width}, #{height}"
      "#client/is-fullscreen: #{Window2.isFullScreen}"
    ], (msg) -> console.log msg

  Window2.focus()

  Timer.add 200, ->
    Client.emit 'enter'
    report()

aboutDebug = ->
  unless Config.get 'misc/use-debug-mode' then return
  $.on 'alt + f9', ColorManager.pick

boot = (callback) ->

  list = [
    # ---start---
    Client
    ColorManager
    Config
    console
    Dictionary
    Fishing
    Hud
    Indicator
    Jumper
    Menu2
    Picker
    Recorder
    Replayer
    Scene
    Skill
    Sound
    State
    Tactic
    Window2
    Buff
    Camera
    Character
    Gdip
    Movement
    Party
    Party2
    Alice
    Controller
    # ---end---
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
  aboutDebug()

# exit
OnExit ->
  Sound.unmute()
  Window2.window.setPriority 'normal'