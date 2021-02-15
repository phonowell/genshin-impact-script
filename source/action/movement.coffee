class MovementX extends EmitterX

  count: 0
  isPressed: {}

  # ---

  constructor: ->
    super()
    @preventDefault()

  check: ->

    if client.isSuspend
      return

    # move

    count = @checkMove()

    if count and !@count
      player.emit 'move-start'
    else if !count and @count
      player.emit 'move-end'

    @count = count

  checkMove: ->

    count = 0

    for key in ['w', 'a', 's', 'd']

      if $.getState key

        count = count + 1

        if @isPressed[key]
          continue
        @isPressed[key] = true

        $.press "#{key}:down"

      else

        unless @isPressed[key]
          continue
        @isPressed[key] = false

        $.press "#{key}:up"

    return count

  preventDefault: ->
    for key in ['w', 'a', 's', 'd']
      $.on key, -> return
      $.on "#{key}:up", -> return

  resetKey: ->
    for key in ['w', 'a', 's', 'd']
      if @isPressed[key]
        $.press "#{key}:up"

  startMove: (key) ->
    if $.getState key
      return
    if @isPressed[key]
      return
    $.press "#{key}:down"
    player.emit 'move-start'

  stopMove: (key) ->
    if $.getState key
      return
    $.press "#{key}:up"
    unless @count
      player.emit 'move-end'

# execute

movement = new MovementX()

ticker.on 'change', movement.check

player
  .on 'move-start', ->
    if player.isMoving
      return
    player.isMoving = true
  .on 'move-end', ->
    unless player.isMoving
      return
    player.isMoving = false