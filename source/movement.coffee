class MovementX extends KeyBindingX

  count: 0
  isMoving: false

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

  check: (key, action) ->
    if action == 'down' then @checkDown key
    else @checkUp key

  checkDown: (key) ->

    if @isPressed[key] then return
    @isPressed[key] = true
    count = @count + 1

    if count and !@count then @emit 'move:start'
    @count = count

    $.press "#{key}:down"

  checkUp: (key) ->

    unless @isPressed[key] then return
    @isPressed[key] = false
    count = @count - 1

    if !count and @count then @emit 'move:end'
    @count = count

    $.press "#{key}:up"

  jump: ->
    $.press 'space'
    ts.jump = $.now()

  sprint: -> $.click 'right'

# execute
movement = new MovementX()