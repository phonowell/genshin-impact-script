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
    Party.switchTo key
    SkillTimer.listQ[Party.current] = $.now()

  useE: (isHolding = false) ->

    delay = 50
    if isHolding then delay = 1e3

    $.press 'e:down'
    SkillTimer.record 'start'
    Client.delay '~player', delay, ->
      $.press 'e:up'
      SkillTimer.record 'end'

  useQ: ->
    $.press 'q'
    SkillTimer.listQ[Party.current] = $.now()

# execute
Player = new PlayerX()