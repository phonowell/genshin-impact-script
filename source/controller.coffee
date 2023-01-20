# @ts-check

import '../../gis-static/lib/XInput.ahk'

class ControllerG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/controller').ControllerG['cache'] ###
    @cache = {
      n: {}
      s: {}
    }
    ###* @type import('./type/controller').ControllerG['isPressed'] ###
    @isPressed = {}
    ###* @type import('./type/controller').ControllerG['listLeftStick'] ###
    @listLeftStick = [
      ['left-stick-left', 'a', 'left']
      ['left-stick-right', 'd', 'right']
      ['left-stick-up', 'w', 'up']
      ['left-stick-down', 's', 'down']
    ]
    ###* @type import('./type/controller').ControllerG['listRightStick'] ###
    @listRightStick = [
      ['right-stick-left', 'left']
      ['right-stick-right', 'right']
      ['right-stick-up', 'up']
      ['right-stick-down', 'down']
    ]
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

    @on 'button-a:down', =>
      if Scene.is 'normal'
        @cache.s['button-a'] = 'normal'
        $.trigger 'f:down'
        return
      @cache.s['button-a'] = ''
      $.press 'l-button:down'
    @on 'button-a:up', =>
      if @cache.s['button-a'] == 'normal'
        @cache.s['button-a'] = ''
        $.trigger 'f:up'
        return
      @cache.s['button-a'] = ''
      $.press 'l-button:up'
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

    delay = 300
    name = 'party/current'
    token = 'controller/switch'

    @on 'button-up:up', =>

      unless Party.current then return
      unless Scene.is 'normal' then return

      unless @cache.n[name] then @cache.n[name] = Party.current

      @cache.n[name]--
      if @cache.n[name] < 1
        @cache.n[name] = Party.size

      Timer.add token, delay, =>
        $.trigger "#{@cache.n[name]}:down"
        Timer.add 100, => $.trigger "#{@cache.n[name]}:up"
        @cache.n[name] = 0

    @on 'button-down:up', =>

      unless Party.current then return
      unless Scene.is 'normal' then return

      unless @cache.n[name] then @cache.n[name] = Party.current

      @cache.n[name]++
      if @cache.n[name] > Party.size
        @cache.n[name] = 1

      Timer.add token, delay, =>
        $.trigger "#{@cache.n[name]}:down"
        Timer.add 100, => $.trigger "#{@cache.n[name]}:up"
        @cache.n[name] = 0

    @on 'button-left:up', ->
      $.trigger 'm:down'
      Timer.add 100, -> $.trigger 'm:up'

    @on 'button-right:up', Alice.next

  ###* @type import('./type/controller').ControllerG['registerLeftStick'] ###
  registerLeftStick: ->

    for group in @listLeftStick
      [button, key, key2] = group

      @on "#{button}:down", ->
        if Scene.is 'normal'
          $.press "#{key}:down"
          return
        Cursor.start key2, 20

      @on "#{button}:up", ->
        if Scene.is 'normal'
          $.press "#{key}:up"
          return
        Cursor.end key2, 20

    return

  ###* @type import('./type/controller').ControllerG['registerRightStick'] ###
  registerRightStick: ->

    for group in @listRightStick
      [button, key] = group

      @on "#{button}:down", ->
        if Scene.is 'normal'
          $.trigger "#{key}:down"
          return
        Cursor.start key, 10

      @on "#{button}:up", ->
        if Scene.is 'normal'
          $.trigger "#{key}:up"
          return
        Cursor.end key, 10

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

    console.log "#controller/button: #{wButtons}"

  ###* @type import('./type/controller').ControllerG['watch'] ###
  watch: -> Client.useActive =>
    [interval, token] = [50, 'controller/watch']
    Timer.loop token, interval, @update
    return -> Timer.remove token

Controller = new ControllerG()