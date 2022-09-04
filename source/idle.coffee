# function

class Idle extends KeyBinding

  listKey: [
    'esc', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12'
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'backspace'
    'tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'enter'
    'shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm'
    'space'
    'l-button', 'm-button', 'r-button', 'x-button-1', 'x-button-2'
  ]
  token: 'idle/pressing'

  constructor: ->
    super()
    @init()

  # clearTimer
  clearTimer: -> Timer.remove @token

  # init(): void
  init: ->
    for key in @listKey
      @registerEvent 'press', key

    @on 'press:start', @main
    @on 'press:end', @main

  # main(): void
  main: ->

    list = []

    for key, state of @isPressed
      if state then $.push list, key

    if $.length list
      console.log "#{@token}: #{$.join list, ', '}"
      unless Client.isActive then Client.emit 'activate'
      @clearTimer()
    else
      console.log "#{@token}: -"
      @setTimer()

  # setTimer(): void
  setTimer: ->

    time = Config.get 'idle/use-time'
    unless time then return

    Timer.add @token, time * 1e3, ->
      if Client.isSuspend then return
      if Scene.is 'unknown' then return
      Client.emit 'idle'

# execute
Idle = new Idle()