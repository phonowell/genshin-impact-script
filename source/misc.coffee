# @ts-check

aboutCaps = -> Scene.useExact 'normal', ->
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

  Window2.window.focus()

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
    Dictionary
    Fishing
    Hud
    Indicator
    Jumper
    Picker
    Recorder
    Replayer
    Scene
    State
    Tactic
    Camera
    Character
    Config
    console
    Gdip
    Menu2
    Movement
    Party
    Party2
    Skill
    Sound
    Window2
    Alice
    Buff
    # ---end---
  ]

  for m in list

    unless $.isString m.namespace
      $.alert 'misc/boot: invalid namespace'
      return

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