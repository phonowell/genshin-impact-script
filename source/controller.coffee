# @ts-check

import '../../gis-static/lib/XInput.ahk'

class ControllerG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/controller').ControllerG['cache'] ###
    @cache = {}
    ###* @type import('./type/controller').ControllerG['isPressed'] ###
    @isPressed = {}
    ###* @type import('./type/controller').ControllerG['mapButton'] ###
    @mapButton = {
      a: 4096
      b: 8192
      x: 16384
      y: 32768
      start: 16
      back: 32
      lb: 256
      rb: 512
      up: 1
      down: 2
      left: 4
      right: 8
    }
    ###* @type import('./type/controller').ControllerG['thresholdStick'] ###
    @thresholdStick = 1e4
    ###* @type import('./type/controller').ControllerG['ts'] ###
    @ts = {}

  ###* @type import('./type/controller').ControllerG['aboutButton'] ###
  aboutButton: (value) ->

    for key, code of @mapButton
      if value == code and not @isPressed["button-#{key}"]
        @isPressed["button-#{key}"] = true
        @emit "button-#{key}:down"
      else if value != code and @isPressed["button-#{key}"]
        @isPressed["button-#{key}"] = false
        @emit "button-#{key}:up"

    return

  ###* @type import('./type/controller').ControllerG['aboutStickX'] ###
  aboutStickX: (stick, value) ->
    threshold = 15e3
    if value > threshold
      if @isPressed["#{stick}-stick-right"] then return
      @isPressed["#{stick}-stick-right"] = true
      @emit "#{stick}-stick-right:down"
    else if value < 0 - threshold
      if @isPressed["#{stick}-stick-left"] then return
      @isPressed["#{stick}-stick-left"] = true
      @emit "#{stick}-stick-left:down"
    else
      if @isPressed["#{stick}-stick-right"]
        @isPressed["#{stick}-stick-right"] = false
        @emit "#{stick}-stick-right:up"
      if @isPressed["#{stick}-stick-left"]
        @isPressed["#{stick}-stick-left"] = false
        @emit "#{stick}-stick-left:up"

  ###* @type import('./type/controller').ControllerG['aboutStickY'] ###
  aboutStickY: (stick, value) ->
    threshold = 15e3
    if value > threshold
      if @isPressed["#{stick}-stick-up"] then return
      @isPressed["#{stick}-stick-up"] = true
      @emit "#{stick}-stick-up:down"
    else if value < 0 - threshold
      if @isPressed["#{stick}-stick-down"] then return
      @isPressed["#{stick}-stick-down"] = true
      @emit "#{stick}-stick-down:down"
    else
      if @isPressed["#{stick}-stick-up"]
        @isPressed["#{stick}-stick-up"] = false
        @emit "#{stick}-stick-up:up"
      if @isPressed["#{stick}-stick-down"]
        @isPressed["#{stick}-stick-down"] = false
        @emit "#{stick}-stick-down:up"

  ###* @type import('./type/controller').ControllerG['aboutTrigger'] ###
  aboutTrigger: (trigger, value) ->
    threshold = 64
    if value > threshold
      if @isPressed["#{trigger}-trigger"] then return
      @isPressed["#{trigger}-trigger"] = true
      @emit "#{trigger}-trigger:down"
    else
      if @isPressed["#{trigger}-trigger"]
        @isPressed["#{trigger}-trigger"] = false
        @emit "#{trigger}-trigger:up"

  ###* @type import('./type/controller').ControllerG['init'] ###
  init: ->

    unless Config.get 'controller/enable' then return

    XInput_Init()
    @watch()

    @registerCross()
    @registerLeftStick()
    @registerRightStick()

    @on 'button-a:down', -> $.trigger 'f:down'
    @on 'button-a:up', -> $.trigger 'f:up'
    @on 'button-b:down', -> $.trigger 'r-button:down'
    @on 'button-b:up', -> $.trigger 'r-button:up'
    @on 'button-x:down', -> $.trigger 'l-button:down'
    @on 'button-x:up', -> $.trigger 'l-button:up'
    @on 'button-y:down', -> $.trigger 'space:down'
    @on 'button-y:up', -> $.trigger 'space:up'

    @on 'button-start:down', -> $.press 'esc:down'
    @on 'button-start:up', -> $.press 'esc:up'
    @on 'button-back:down', -> $.press 'tab:down'
    @on 'button-back:up', -> $.press 'tab:up'

    @on 'button-lb:down', -> $.press 't:down'
    @on 'button-lb:up', -> $.press 't:up'
    @on 'button-rb:down', -> $.trigger 'e:down'
    @on 'button-rb:up', -> $.trigger 'e:up'

    @on 'left-trigger:down', -> $.press 'r:down'
    @on 'left-trigger:up', -> $.press 'r:up'
    @on 'right-trigger:down', -> $.trigger 'q:down'
    @on 'right-trigger:up', -> $.trigger 'q:up'

  ###* @type import('./type/controller').ControllerG['registerCross'] ###
  registerCross: ->

    delay = 200
    token = 'controller/switch'

    @on 'button-up:down', =>
      @ts['button-up'] = $.now()
      unless Party.current then return
      if @cache['party/current'] < 1
        @cache['party/current'] = Party.current
      return

    @on 'button-up:up', =>
      unless Party.current then return
      @cache['party/current']--
      if @cache['party/current'] < 1
        @cache['party/current'] = Party.size

      Timer.add token, delay, =>
        $.trigger $.toString @cache['party/current']
        @cache['party/current'] = 0

    @on 'button-down:down', =>
      @ts['button-down'] = $.now()
      unless Party.current then return
      if @cache['party/current'] < 1
        @cache['party/current'] = Party.current
      return

    @on 'button-down:up', =>
      unless Party.current then return
      @cache['party/current']++
      if @cache['party/current'] > Party.size
        @cache['party/current'] = 1

      Timer.add token, delay, =>
        $.trigger $.toString @cache['party/current']
        @cache['party/current'] = 0

  ###* @type import('./type/controller').ControllerG['registerLeftStick'] ###
  registerLeftStick: ->

    list = [
      ['left-stick-left', 'a']
      ['left-stick-right', 'd']
      ['left-stick-up', 'w']
      ['left-stick-down', 's']
    ]

    for group in list
      [button, key] = group
      @on "#{button}:down", -> $.press "#{key}:down"
      @on "#{button}:up", -> $.press "#{key}:up"

    return

  ###* @type import('./type/controller').ControllerG['registerRightStick'] ###
  registerRightStick: ->

    list = [
      ['right-stick-left', 'left']
      ['right-stick-right', 'right']
      ['right-stick-up', 'up']
      ['right-stick-down', 'down']
    ]

    for group in list
      [button, key] = group
      @on "#{button}:down", -> $.trigger "#{key}:down"
      @on "#{button}:up", -> $.trigger "#{key}:up"

    return

  ###* @type import('./type/controller').ControllerG['update'] ###
  update: ->

    state = XInput_GetState 0
    unless state then return

    {
      wButtons
      bLeftTrigger
      bRightTrigger
      sThumbLX
      sThumbLY
      sThumbRX
      sThumbRY
    } = state

    @aboutStickX 'left', sThumbLX
    @aboutStickY 'left', sThumbLY

    @aboutStickX 'right', sThumbRX
    @aboutStickY 'right', sThumbRY

    @aboutButton wButtons

    @aboutTrigger 'left', bLeftTrigger
    @aboutTrigger 'right', bRightTrigger

    console.log "controller/button: #{wButtons}"

  ###* @type import('./type/controller').ControllerG['watch'] ###
  watch: ->

    interval = 50
    token = 'controller/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @update

Controller = new ControllerG()