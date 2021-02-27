class PlayerX extends KeyBindingX

  isMoving: false

  # ---

  constructor: ->
    super()

    # toggle
    for key in [1, 2, 3, 4]
      @bindEvent 'toggle', key

    @

      # attack
      .bindEvent 'attack', 'l-button', 'prevent'
      .bindEvent 'toggle-aim', 'r'

      # use skill
      .bindEvent 'use-e', 'e'
      .bindEvent 'use-q', 'q'

      # run & jump
      .bindEvent 'jump', 'space'
      .bindEvent 'sprint', 'r-button'

      # others?
      .bindEvent 'find', 'v'
      .bindEvent 'pause', 'p'
      .bindEvent 'pick', 'f'
      .bindEvent 'unhold', 'x'
      .bindEvent 'use-item', 'z'
      .bindEvent 'view', 'm-button'

    # menu
    for key in [
      'esc'
      'b', 'c', 'j', 'm'
      'f1', 'f2', 'f3', 'f4', 'f5'
    ]
      @bindEvent "menu-#{key}", key

  jump: -> $.press 'space'

  startMove: (key) ->

    if movement.isPressed[key]
      return @

    $.press "#{key}:down"
    return @

  stopMove: (key) ->

    if movement.isPressed[key]
      return @

    $.press "#{key}:up"
    return @

  toggleQ: (key) ->
    $.press "alt + #{key}"
    member.toggle key
    return @

  useE: (isHolding = false) ->

    unless isHolding
      $.press 'e'
      skillTimer.record 'start'
      skillTimer.record 'end'
      return @

    $.press 'e:down'
    skillTimer.record 'start'
    $.delay 1e3, ->
      $.press 'e:up'
      skillTimer.record 'end'
    return @

  useQ: ->
    $.press 'q'
    return @

# execute
player = new PlayerX()