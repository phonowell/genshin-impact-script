class PlayerX extends KeyBindingX

  constructor: ->
    super()

    # switch
    for key in [1, 2, 3, 4]
      @bindEvent 'switch', key, 'prevent'

    # attack
    @bindEvent 'attack', 'l-button', 'prevent'

    # use skill
    @bindEvent 'use-e', 'e'
    @bindEvent 'use-q', 'q', 'prevent'

    # others
    @bindEvent 'pick', 'f', 'prevent'

  switchQ: (key) ->
    $.press "alt + #{key}"
    party.switchTo key
    skillTimer.listQ[party.current] = $.now()

  useE: (isHolding = false) ->

    delay = 50
    if isHolding then delay = 1e3

    $.press 'e:down'
    skillTimer.record 'start'
    $.setTimeout ->
      $.press 'e:up'
      skillTimer.record 'end'
    , delay

  useQ: ->
    $.press 'q'
    skillTimer.listQ[party.current] = $.now()

# execute
player = new PlayerX()