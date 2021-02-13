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

    count = 0

    for key in ['w', 'a', 's', 'd']
      if $.getState key
        count = count + 1
        unless @isPressed[key]
          @isPressed[key] = true
          $.press "#{key}:down"
      else
        if @isPressed[key]
          @isPressed[key] = false
          $.press "#{key}:up"

    if count and !@count
      player.emit 'move-start'
    else if !count and @count
      player.emit 'move-end'

    @count = count

  preventDefault: ->
    for key in ['w', 'a', 's', 'd']
      $.on key, -> return

  startMove: (key) ->
    if $.getState key
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