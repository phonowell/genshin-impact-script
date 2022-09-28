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

    @init()

  ###* @type import('./type/movement').MovementG['init'] ###
  init: ->

    # shift
    @registerEvent 'shift', 'l-shift', true
    @on 'shift:start', -> $.click 'right:down'
    @on 'shift:end', -> $.click 'right:up'

    # walk
    for key in ['w', 'a', 's', 'd']
      @registerEvent 'walk', key

    @on 'walk:start', =>
      unless @count then @emit 'move:start'
      if @count.move >= 4 then return
      @count.move++

    @on 'walk:end', =>
      if @count.move == 1 then @emit 'move:end'
      if @count.move <= 0 then return
      @count.move--

    @on 'move:start', => @isMoving = true
    @on 'move:end', => @isMoving = false

    # forward
    @on 'walk:start', @toggleForward

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

    unless Scene.is 'normal' then return

    if @isForwarding
      if key == 'w' || key == 's'
        @stopForward()
        return
      return

    if key == 'w'

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
      return

Movement = new MovementG()