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

    # binding

    @on 'move:start', =>
      if @isMoving then return
      @isMoving = true
    @on 'move:end', =>
      unless @isMoving then return
      @isMoving = false

  check: (key, action) ->
    if action == 'down' then @checkDown key
    else if action == 'up' then @checkUp key

  checkDown: (key) ->

    if @isPressed[key]
      return
    @isPressed[key] = true
    count = @count + 1

    if count and !@count
      @emit 'move:start'
    @count = count

    $.press "#{key}:down"

  checkUp: (key) ->

    unless @isPressed[key]
      return
    @isPressed[key] = false
    count = @count - 1

    if !count and @count
      @emit 'move:end'
    @count = count

    $.press "#{key}:up"

  jump: ->
    $.press 'space'
    ts.jump = $now()

  sprint: -> $.click 'right'

# execute
movement = new MovementX()