### interface
type Action = 'down' | 'up'
type Key = string
###

# function

class MovementX extends KeyBindingX

  count: 0
  isMoving: false

  # ---

  constructor: ->
    super()

    # move
    for key in ['w', 'a', 's', 'd']
      $.on key, => @check key, 'down'
      $.on "#{key}:up", => @check key, 'up'

    # run & jump
    @bindEvent 'jump', 'space', 'prevent'
    @bindEvent 'sprint', 'r-button'
    @bindEvent 'unhold', 'x', 'prevent'

    # binding

    @on 'move:start', =>
      if @isMoving then return
      @isMoving = true
      console.log 'movement: start moving'
    @on 'move:end', =>
      unless @isMoving then return
      @isMoving = false
      console.log 'movement: end moving'

  # check(key: Key, action: Action): void
  check: (key, action) ->
    if action == 'down' then @checkDown key
    else @checkUp key

  # checkDown(key: Key): void
  checkDown: (key) ->

    $.press "#{key}:down"

    if @isPressed[key] then return
    @isPressed[key] = true
    count = @count + 1

    if count and !@count then @emit 'move:start'
    @count = count

  # checkUp(key: Key): void
  checkUp: (key) ->

    $.press "#{key}:up"

    unless @isPressed[key] then return
    @isPressed[key] = false
    count = @count - 1

    if !count and @count then @emit 'move:end'
    @count = count

  # jump(): void
  jump: ->
    $.press 'space'
    ts.jump = $.now()

  # sprint(): void
  sprint: -> $.click 'right'

# execute
Movement = new MovementX()