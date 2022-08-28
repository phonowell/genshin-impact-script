# function

class Movement extends KeyBinding

  isForwarding: false
  isMoving: false
  count: 0
  tsJump: 0

  constructor: ->
    super()
    @init()

  # init(): void
  init: ->

    # shift
    @registerEvent 'shift', 'l-shift', 'prevent'
    @on 'shift:start', -> $.click 'right:down'
    @on 'shift:end', -> $.click 'right:up'

    # walk
    for key in ['w', 'a', 's', 'd']
      @registerEvent 'walk', key

    @on 'walk:start', =>
      unless @count then @emit 'move:start'
      if @count >= 4 then return
      @count++

    @on 'walk:end', =>
      if @count == 1 then @emit 'move:end'
      if @count <= 0 then return
      @count--

    @on 'move:start', => @isMoving = true
    @on 'move:end', => @isMoving = false

    # forward
    $.on 'alt + w', => Timer.add 'forward', 100, @toggleForward
    @on 'walk:start', @stopForward

    # jump
    @registerEvent 'jump', 'space'
    @on 'jump:start', => @tsJump = $.now()
    @on 'jump:end', =>

      now = $.now()
      diff = now - @tsJump
      @tsJump = now

      unless (Config.get 'better-jump') and Scene.is 'normal' then return
      unless diff < 350 then return

      Timer.add 'jump', 350 - diff, Movement.jump

  # jump(): void
  jump: ->
    $.press 'space'
    @tsJump = $.now()

  # sprite(): void
  sprite: -> $.click 'right'

  # startForward(): void
  startForward: ->

    unless Scene.is 'normal' then return
    if @isForwarding then return

    @isForwarding = true
    Hud.render 0, 'auto forward [ON]'

    $.press 'w:down'

  # stopForward(): void
  stopForward: (key) ->

    unless @isForwarding then return
    if key == 'a' or key == 'd' then return

    @isForwarding = false
    Hud.render 0, 'auto forward [OFF]'

    $.press 'w:up'

  # toggleForward(): void
  toggleForward: ->
    if @isForwarding then @stopForward()
    else @startForward()

# execute
Movement = new Movement()