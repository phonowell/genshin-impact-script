class KeyBindingX extends EmitterX

  isPressed: {}

  # ---

  constructor: ->
    super()

    # toggle
    for key in [1, 2, 3, 4]
      @bindEvent 'toggle', key

    @

      # attack
      .bindEvent 'attack', 'l-button', 'left'
      .bindEvent 'toggle-aim', 'r'

      # use skill
      .bindEvent 'use-e', 'e'
      .bindEvent 'use-q', 'q'

      # run & jump
      .bindEvent 'jump', 'space'
      .bindEvent 'sprint', 'r-button', 'right'

      # others?
      .bindEvent 'find', 'v'
      .bindEvent 'pause', 'p'
      .bindEvent 'pick', 'f'
      .bindEvent 'unhold', 'x'
      .bindEvent 'use-item', 'z'
      .bindEvent 'view', 'm-button', 'middle'

    # menu
    for key in [
      'esc'
      'b', 'c', 'j', 'm'
      'f1', 'f2', 'f3', 'f4', 'f5'
    ]
      @bindEvent "menu-#{key}", key

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

    return @

  resetKey: ->

    for key, value of @isPressed

      unless value
        continue

      if key == 'l-button' then $.click 'left:up'
      if key == 'm-button' then $.click 'middle:up'
      if key == 'r-button' then $.click 'right:up'

      $.press "#{key}:up"

    return @

# execute
keyBinding = new KeyBindingX()