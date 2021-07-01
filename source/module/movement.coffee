class MovementX extends KeyBindingX

  count: 0

  constructor: ->
    super()

    for key in ['w', 'a', 's', 'd']
      $.on key, => @check key, 'down'
      $.on "#{key}:up", => @check key, 'up'

    player
      .on 'move:start', ->
        if player.isMoving
          return
        player.isMoving = true
      .on 'move:end', ->
        unless player.isMoving
          return
        player.isMoving = false

  check: (key, action) ->
    if action == 'down' then @checkDown key
    else if action == 'up' then @checkUp key

  checkDown: (key) ->

    if @isPressed[key]
      return
    @isPressed[key] = true
    count = @count + 1

    if count and !@count
      player.emit 'move:start'
    @count = count

    $.press "#{key}:down"

  checkUp: (key) ->

    unless @isPressed[key]
      return
    @isPressed[key] = false
    count = @count - 1

    if !count and @count
      player.emit 'move:end'
    @count = count

    $.press "#{key}:up"

# execute
movement = new MovementX()