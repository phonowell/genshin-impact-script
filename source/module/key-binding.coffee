class KeyBindingX extends EmitterX

  isPressed: {}

  # ---

  constructor: ->
    super()

    # attack
    @bindEvent 'attack', 'l-button', 'left'
    @bindEvent 'toggle-aim', 'r'

    # toggle
    for key in [1, 2, 3, 4]
      @bindEvent 'toggle', key

    # use skill
    @bindEvent 'use-e', 'e'
    @bindEvent 'use-q', 'q'

    # run & jump
    @bindEvent 'sprint', 'r-button', 'right'
    @bindEvent 'jump', 'space'

    # others?
    @bindEvent 'pick', 'f'
    @bindEvent 'find', 'v'
    @bindEvent 'view', 'm-button', 'middle'

  bindEvent: (name, key, key2 = '') ->

    $.on "#{key}", =>

      if @isPressed[key]
        return
      @isPressed[key] = true

      if key2 then $.click "#{key2}:down"
      else $.press "#{key}:down"

      player.emit "#{name}-start", key

    $.on "#{key}:up", =>

      unless @isPressed[key]
        return
      @isPressed[key] = false

      if key2 then $.click "#{key2}:up"
      else $.press "#{key}:up"

      player.emit "#{name}-end", key

  resetKey: ->

    for key in [
      1, 2, 3, 4
      'e', 'f', 'q', 'r', 'space', 'v'
    ]
      if @isPressed[key]
        $.press "#{key}:up"

    if @isPressed['l-button']
      $.click 'left:up'
    if @isPressed['m-button']
      $.click 'middle:up'
    if @isPressed['r-button']
      $.click 'right:up'

# execute

keyBinding = new KeyBindingX()