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

    # sprint
    @checkSprint()

    # jump
    @checkJump()

    # pick
    @checkPick()

  checkJump: ->

    key = 'space'

    if $.getState key

      if @isPressed[key]
        return
      @isPressed[key] = true

      $.press 'space:down'
      player.emit 'jump-start'

    else

      unless @isPressed[key]
        return
      @isPressed[key] = false

      $.press 'space:up'
      player.emit 'jump-end'

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

  checkPick: ->

    key = 'f'

    if $.getState key

      if @isPressed[key]
        return
      @isPressed[key] = true

      $.press 'f:down'
      player.emit 'pick-start'

    else

      unless @isPressed[key]
        return
      @isPressed[key] = false

      $.press 'f:up'
      player.emit 'pick-end'

  checkSprint: ->

    key = 'r-button'

    if $.getState key

      if @isPressed[key]
        return
      @isPressed[key] = true

      $.click 'right:down'
      player.emit 'sprint-start'

    else

      unless @isPressed[key]
        return
      @isPressed[key] = false

      $.click 'right:up'
      player.emit 'sprint-end'

  preventDefault: ->
    for key in [
      'w', 'a', 's', 'd'
      'r-button'
      'space'
      'f'
    ]
      $.on key, -> return

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