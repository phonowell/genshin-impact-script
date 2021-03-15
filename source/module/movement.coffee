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

    $$.vt 'movement.check', key, 'string'
    $$.vt 'movement.check', action, 'string'

    if action == 'down' and @isPressed[key]
      return
    else if action == 'up' and !@isPressed[key]
      return

    count = @checkMove()

    if count and !@count
      player.emit 'move:start'
    else if !count and @count
      player.emit 'move:end'

    @count = count

  checkMove: ->

    count = 0

    for key in ['w', 'a', 's', 'd']

      if $.getState key

        count = count + 1

        if @isPressed[key]
          continue
        @isPressed[key] = true

        recorder.record "#{key}:down"
        $.press "#{key}:down"

      else

        unless @isPressed[key]
          continue
        @isPressed[key] = false

        recorder.record "#{key}:up"
        $.press "#{key}:up"

    return count

# execute
movement = new MovementX()