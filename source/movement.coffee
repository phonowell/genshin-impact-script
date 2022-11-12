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

  ###* @type import('./type/movement').MovementG['init'] ###
  init: ->

    # walk
    for key in ['w', 'a', 's', 'd']
      @registerEvent 'walk', key
      @registerEvent 'sprint-walk', "shift + #{key}", true

    @on 'walk:start', =>
      unless @count.move then @emit 'move:start'
      if @count.move >= 4 then return
      @count.move++

    @on 'walk:end', (key) =>

      if @isForwarding and key == 'w'
        $.press 'w:down'
        return

      if @count.move == 1 then @emit 'move:end'
      if @count.move <= 0 then return
      @count.move--

    # move
    @on 'move:start', => @isMoving = true
    @on 'move:end', => @isMoving = false

    # sprint
    @on 'sprint-walk:start', (key) ->
      unless Scene.is 'normal'
        $.press "#{key}:down"
        return
      key2 = $.trim $.replace ($.replace key, 'shift', ''), '+', ''
      $.press "#{key2}:down"
    @on 'sprint-walk:end', (key) ->
      unless Scene.is 'normal'
        $.press "#{key}:up"
        return
      key2 = $.trim $.replace ($.replace key, 'shift', ''), '+', ''
      $.press "#{key2}:up"

    # forward
    @on 'walk:start', @toggleForward

    # aim
    @registerEvent 'aim', 'r'
    @on 'aim:start', => @onAim 'start'
    @on 'aim:end', => @onAim 'end'

    # unhold
    @registerEvent 'unhold', 'l-button'
    @on 'unhold:start', => @onUnhold 'start'
    @on 'unhold:end', => @onUnhold 'end'

    Scene.on 'change', =>
      if Scene.is 'normal' then return
      if Scene.is 'unknown' then return
      unless @isForwarding then return
      @stopForward()

  ###* @type import('./type/movement').MovementG['onAim'] ###
  onAim: (step) ->

    unless Scene.is 'normal', 'not-domain' then return

    if (Character.get Party.name, 'weapon') == 'bow'
      unless Scene.is 'busy', 'not-aiming' then return

    if step == 'start' then $.press 't:down'
    else $.press 't:up'

  ###* @type import('./type/movement').MovementG['onUnhold'] ###
  onUnhold: (step) ->

    unless Scene.is 'normal', 'busy', 'not-aiming' then return

    if step == 'start' then $.press 'x:down'
    else $.press 'x:up'

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

    unless Scene.is 'normal', 'not-domain', 'not-using-q' then return

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