# @ts-check

class IdleG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/idle').IdleG['listKey'] ###
    @listKey = [
      'esc', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12'
      'Sc029', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'backspace'
      'tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'
      'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'enter'
      'shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm'
      'space'
      'left', 'right', 'up', 'down'
      'l-button', 'm-button', 'r-button', 'x-button-1', 'x-button-2'
    ]
    ###* @type import('./type/idle').IdleG['token'] ###
    @token = 'idle/pressing'

  ###* @type import('./type/idle').IdleG['clearTimer'] ###
  clearTimer: -> Timer.remove @token

  ###* @type import('./type/idle').IdleG['init'] ###
  init: ->
    for key in @listKey
      @registerEvent 'press', key

    @on 'press:start', @main
    @on 'press:end', @main

  ###* @type import('./type/idle').IdleG['main'] ###
  main: ->

    list = []

    for key, state of @isPressed
      if state then $.push list, key

    if $.length list
      unless Client.isActive then Client.emit 'activate'
      @clearTimer()
    else @setTimer()

  ###* @type import('./type/idle').IdleG['setTimer'] ###
  setTimer: ->

    time = $.toNumber Config.get 'idle/use-time'
    unless time then return

    Timer.add @token, time * 1e3, ->
      if Client.isSuspended then return
      if Scene.is 'unknown' then return
      Client.emit 'idle'

Idle = new IdleG()