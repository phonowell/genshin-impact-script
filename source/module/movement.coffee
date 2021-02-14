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

    # toggle
    for key in [1, 2, 3, 4]
      @checkEvent 'toggle', key
    @checkEvent 'use-skill', 'e'

    # run & jump
    @checkEvent 'sprint', 'r-button', 'right'
    @checkEvent 'jump', 'space'

    # others?
    @checkEvent 'pick', 'f'
    @checkEvent 'view', 'm-button', 'middle'

  checkEvent: (name, key, key2 = '') ->

    if $.getState key

      if @isPressed[key]
        return
      @isPressed[key] = true

      if key2 then $.click "#{key2}:down"
      else $.press "#{key}:down"

      player.emit "#{name}-start", key

    else

      unless @isPressed[key]
        return
      @isPressed[key] = false

      if key2 then $.click "#{key2}:up"
      else $.press "#{key}:up"

      player.emit "#{name}-end", key

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
    for key in [
      'w', 'a', 's', 'd'
      1, 2, 3, 4
      'm-button', 'r-button'
      'e', 'f', 'space'
    ]
      $.on key, -> return

  resetKey: ->

    for key in [
      'w', 'a', 's', 'd'
      1, 2, 3, 4
      'e', 'f', 'space'
    ]
      if $.getState key
        $.press "#{key}:up"

    if $.getState 'm-button'
      $.click 'middle:up'
    if $.getState 'r-button'
      $.click 'right:up'

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