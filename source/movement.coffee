# @ts-check

class MovementG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/movement').MovementG['direction'] ###
    @direction = []

    ###* @type import('./type/movement').MovementG['isForwarding'] ###
    @isForwarding = false

    ###* @type import('./type/movement').MovementG['isMoving'] ###
    @isMoving = false

  ###* @type import('./type/movement').MovementG['aboutAim'] ###
  aboutAim: ->

    checkIsReadyToAim = ->
      unless Party.size then return false
      unless Character.is Party.name, 'bow' then return false
      return State.is 'free'

    @on 'aim:start', ->
      if checkIsReadyToAim() then return
      $.press 't:down'

    @on 'aim:end', ->
      if checkIsReadyToAim() then return
      $.press 't:up'

    Scene.useExact ['normal', 'not-domain'], =>
      @registerEvent 'aim', 'r'
      return => @unregisterEvent 'aim', 'r'

  ###* @type import('./type/movement').MovementG['aboutForward'] ###
  aboutForward: ->

    [key, token] = ['alt + w', 'toggle']

    # on event 'toggle', start or stop auto-forward
    @on token, =>
      if @isForwarding then @stopForward() else @startForward()

    Scene.useExact ['normal', 'not-domain'], =>

      $.preventDefaultKey key, true
      @registerEvent token, key

      return =>

        $.preventDefaultKey key, false
        @unregisterEvent token, key

        # stop auto-forward if it is running
        if @isForwarding then @stopForward()

  ###* @type import('./type/movement').MovementG['aboutMove'] ###
  aboutMove: ->

    @on 'move', =>

      if @isMoving
        console.log "#movement/move: #{$.join @direction, ', '}"
      else console.log '#movement/move: -'

      if @isForwarding and (($.includes @direction, 'w') or ($.includes @direction, 's'))
        @stopForward()

    Scene.useExact ['normal'], =>

      [interval, token] = [100, 'movement/move']

      Timer.loop token, interval, =>

        cache = {
          direction: @direction
          isMoving: @isMoving
        }

        @direction = $.filter ['w', 'a', 's', 'd'], (key) ->
          # exclude `alt + w`
          if key == 'w' then return ($.isPressing 'w') and not $.isPressing 'alt'
          return $.isPressing key
        @isMoving = ($.length @direction) > 0

        if $.eq @direction, cache.direction then return
        @emit 'move'

        if @isMoving == cache.isMoving then return
        if @isMoving then @emit 'move:start' else @emit 'move:end'

      return =>
        Timer.remove token
        @direction = []
        @isMoving = false
        @emit 'move'
        @emit 'move:end'

  ###* @type import('./type/movement').MovementG['aboutUnhold'] ###
  aboutUnhold: ->

    @on 'unhold:start', ->
      if State.is 'aiming' then return
      if State.is 'free' then return
      $.press 'x:down'

    @on 'unhold:end', ->
      if State.is 'aiming' then return
      if State.is 'free' then return
      $.press 'x:up'

    Scene.useExact ['normal'], =>
      @registerEvent 'unhold', 'l-button'
      return => @unregisterEvent 'unhold', 'l-button'

  ###* @type import('./type/movement').MovementG['init'] ###
  init: ->
    @aboutAim()
    @aboutForward()
    @aboutMove()
    @aboutUnhold()

  ###* @type import('./type/movement').MovementG['sprint'] ###
  sprint: -> $.click 'right'

  ###* @type import('./type/movement').MovementG['startForward'] ###
  startForward: ->
    @isForwarding = true
    Hud.render 0, 'auto forward [ON]'
    $.press 'w:down'

  ###* @type import('./type/movement').MovementG['stopForward'] ###
  stopForward: ->
    @isForwarding = false
    Hud.render 0, 'auto forward [OFF]'
    $.press 'w:up'

# @ts-ignore
Movement = new MovementG()