class PlayerX extends KeyBindingX

  current: 0
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

  toggleQ: (key) ->
    $.press "alt + #{key}"
    member.toggle key
    skillTimer.listQ[player.current] = $.now()

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

# execute
player = new PlayerX()