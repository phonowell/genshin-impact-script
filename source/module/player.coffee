class PlayerX extends KeyBindingX

  current: 0
  isMoving: false
  name: ''

  constructor: ->
    super()

    # toggle
    for key in [1, 2, 3, 4]
      @bindEvent 'toggle', key, 'prevent'

    # attack
    @bindEvent 'attack', 'l-button', 'prevent'
    @bindEvent 'toggle-aim', 'r'

    # use skill
    @bindEvent 'use-e', 'e'
    @bindEvent 'use-q', 'q', 'prevent'

    # run & jump
    @bindEvent 'jump', 'space', 'prevent'
    @bindEvent 'sprint', 'r-button', 'prevent'

    # others
    @bindEvent 'pick', 'f', 'prevent'
    @bindEvent 'unhold', 'x', 'prevent'

    # unknown
    @bindEvent 'm-button', 'm-button'
    @bindEvent 'g', 'g'
    @bindEvent 'p', 'p'
    @bindEvent 'v', 'v'
    @bindEvent 'y', 'y'
    @bindEvent 'z', 'z'

    # menu
    for key in [
      'esc'
      'b', 'c', 'j', 'l', 'm', 'o'
      'f1', 'f2', 'f3', 'f4', 'f5'
    ]
      @bindEvent "menu-#{key}", key

  jump: -> $.press 'space'

  sprint: ->
    $.click 'right'
    ts.sprint = $.now()

  startMove: (key) ->

    $$.vt 'player.startMove', key, 'string'

    if movement.isPressed[key]
      return

    $.setTimeout ->
      $.press "#{key}:down"
    , 30

  stopMove: (key) ->

    $$.vt 'player.stopMove', key, 'string'

    if movement.isPressed[key]
      return

    $.press "#{key}:up"

  toggleQ: (key) ->

    $$.vt 'player.toggleQ', key, 'number'

    $.press "alt + #{key}"
    member.toggle key
    skillTimer.listQ[player.current] = $.now()

    $.setTimeout ->
      statusChecker.setIsActive true
    , statusChecker.interval

  useE: (isHolding = false) ->

    unless isHolding
      $.press 'e'
      skillTimer.record 'start'
      skillTimer.record 'end'
      return

    $.press 'e:down'
    skillTimer.record 'start'
    $.setTimeout ->
      $.press 'e:up'
      skillTimer.record 'end'
    , 1e3

  useQ: ->

    $.press 'q'
    skillTimer.listQ[player.current] = $.now()

    $.setTimeout ->
      statusChecker.setIsActive true
    , statusChecker.interval

# execute
player = new PlayerX()