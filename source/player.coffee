### interface
type Key = string
###

# function
class PlayerX extends KeyBindingX

  constructor: ->
    super()

    # switch
    for key in [1, 2, 3, 4, 5]
      @bindEvent 'switch', key, 'prevent'

    # attack
    @bindEvent 'attack', 'l-button', 'prevent'

    # use skill
    @bindEvent 'use-e', 'e'
    @bindEvent 'use-q', 'q'

    # others
    @bindEvent 'pick', 'f', 'prevent'

  # switchQ(key: Key): void
  switchQ: (key) ->

    unless Scene.name == 'normal' then return

    $.press "alt + #{key}"
    Party.switchTo key
    SkillTimer.listQ[Party.current] = $.now()

    Scene.freeze 'normal', 2e3

  # useE(isHolding: boolean = false): void
  useE: (isHolding = false) ->

    unless Scene.name == 'normal' then return

    delay = 50
    if isHolding then delay = 1e3

    $.press 'e:down'
    SkillTimer.record 'start'
    Timer.add 'player', delay, ->
      $.press 'e:up'
      SkillTimer.record 'end'

  # useQ(): void
  useQ: ->

    unless Scene.name == 'normal' then return

    $.press 'q'
    SkillTimer.listQ[Party.current] = $.now()

    Scene.freeze 'normal', 2e3

# execute
Player = new PlayerX()