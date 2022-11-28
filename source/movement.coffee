# @ts-check

class MovementG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/movement').MovementG['count'] ###
    @count =
      forward: 0
      move: 0
    ###* @type import('./type/movement').MovementG['isForwarding'] ###
    @isForwarding = false
    ###* @type import('./type/movement').MovementG['isMoving'] ###
    @isMoving = false
    ###* @type import('./type/movement').MovementG['ts'] ###
    @ts =
      forward: 0

  ###* @type import('./type/movement').MovementG['aboutAim'] ###
  aboutAim: -> Scene.useEffect =>

    checkIsReadyToAim = ->
      unless Character.is Party.name, 'bow' then return false
      return Scene.is 'not-busy'

    @registerEvent 'aim', 'r'

    @on 'aim:start', ->
      if checkIsReadyToAim() then return
      $.press 't:down'

    @on 'aim:end', ->
      if checkIsReadyToAim() then return
      $.press 't:up'

    return =>
      @unregisterEvent 'aim', 'r'
      @off 'aim:start'
      @off 'aim:end'

  , ['normal', 'not-domain']

  ###* @type import('./type/movement').MovementG['aboutMove'] ###
  aboutMove: -> Scene.useEffect =>

    @on 'move:start', => @isMoving = true
    @on 'move:end', => @isMoving = false

    return =>
      @off 'move:start'
      @off 'move:end'

  , ['normal']

  ###* @type import('./type/movement').MovementG['aboutSprint'] ###
  aboutSprint: -> Scene.useEffect =>

    getRaw = (key) -> $.trim $.replace ($.replace key, 'shift', ''), '+', ''

    for key in ['w', 'a', 's', 'd']
      @registerEvent 'sprint-walk', "shift + #{key}", true

    @on 'sprint-walk:start', (key) -> $.press "#{getRaw key}:down"
    @on 'sprint-walk:end', (key) -> $.press "#{getRaw key}:up"

    return =>
      for key in ['w', 'a', 's', 'd']
        @unregisterEvent 'sprint-walk', "shift + #{key}"
      @off 'sprint-walk:start'
      @off 'sprint-walk:end'

  , ['normal']

  ###* @type import('./type/movement').MovementG['aboutUnhold'] ###
  aboutUnhold: -> Scene.useEffect =>

    @registerEvent 'unhold', 'l-button'
    @on 'unhold:start', -> $.press 'x:down'
    @on 'unhold:end', -> $.press 'x:up'

    return =>
      @unregisterEvent 'unhold', 'l-button'
      @off 'unhold:start'
      @off 'unhold:end'

  , ['busy', 'not-aiming']

  ###* @type import('./type/movement').MovementG['aboutWalk'] ###
  aboutWalk: -> Scene.useEffect =>

    for key in ['w', 'a', 's', 'd']
      @registerEvent 'walk', key

    @on 'walk:start', =>
      unless @count.move then @emit 'move:start'
      if @count.move >= 4 then return
      @count.move++

    @on 'walk:start', @toggleForward

    @on 'walk:end', (key) =>

      if @isForwarding and key == 'w'
        $.press 'w:down'
        return

      if @count.move == 1 then @emit 'move:end'
      if @count.move <= 0 then return
      @count.move--

    return =>
      for key in ['w', 'a', 's', 'd']
        @unregisterEvent 'walk', key
      @off 'walk:start'
      @off 'walk:end'

  , ['normal']

  ###* @type import('./type/movement').MovementG['init'] ###
  init: ->

    @aboutAim()
    @aboutMove()
    @aboutSprint()
    @aboutUnhold()
    @aboutWalk()

    Scene.on 'change', =>
      if Scene.is 'normal' then return
      if Scene.is 'unknown' then return
      unless @isForwarding then return
      @stopForward()

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

  ###* @type import('./type/movement').MovementG['toggleForward'] ###
  toggleForward: (key) ->

    unless Scene.is 'normal', 'not-domain' then return

    if @isForwarding
      if key == 's' then @stopForward()
      return

    unless key == 'w'
      @count.forward = 0
      return

    now = $.now()
    diff = now - @ts.forward
    unless diff < 500
      @count.forward = 0
      @ts.forward = now
      return

    @count.forward++
    @ts.forward = now

    if @count.forward >= 2
      @count.forward = 0
      Timer.add 100, @startForward
      return

Movement = new MovementG()