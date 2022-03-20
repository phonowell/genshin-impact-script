### interface
type Fn = () => unknown
type Slot = 1 | 2 | 3 | 4 | 5
###

# function

class Player extends KeyBinding

  constructor: ->
    super()

    @aboutSkill()
    @aboutSwitch()

    # attack
    @registerEvent 'attack', 'l-button', 'prevent'

    # others
    @registerEvent 'pick', 'f', 'prevent'

  # aboutSkill(): void
  aboutSkill: ->
    @registerEvent 'use-e', 'e'
    @registerEvent 'use-q', 'q'
    @on 'use-e:start', -> Skill.record 'start'
    @on 'use-e:end', -> Skill.record 'end'
    @on 'use-q:start', Skill.useQ

  # aboutSwitch(): void
  aboutSwitch: ->

    for key in [1, 2, 3, 4, 5]
      @registerEvent 'raw-switch', key
      $.on "alt + #{key}", => @useQ key

    for step in ['start', 'end']
      @on "raw-switch:#{step}", (key) =>
        unless Scene.name == 'normal' then return
        unless key <= Party.total then return
        @emit "switch:#{step}", key

    @on 'switch:start', (key) =>
      Party.switchTo key
      @waitForSwitch 'start', key, =>

        onSwitch = @getOnSwitch()
        unless onSwitch then return

        if onSwitch == 'e~'
          Skill.useE 'holding'
          return

        $.press 'e:down'
        Skill.record 'start'

    @on 'switch:end', (key) => @waitForSwitch 'end', key, => Timer.add 50, =>

      onSwitch = @getOnSwitch()
      unless onSwitch then return

      if onSwitch == 'e~' then return

      $.press 'e:up'
      Skill.record 'end'

  # getOnSwitch(): string
  getOnSwitch: ->

    {name} = Party
    unless name then return ''

    {onSwitch} = Character.data[name]
    unless onSwitch then return ''

    return onSwitch

  # useQ(key: Slot): void
  useQ: (key) ->

    if key == Party.current
      Skill.useQ()
      return

    Skill.switchQ key

  # waitForSwitch(token: string, n: Slot, callback: Fn)
  waitForSwitch: (token, n, callback) ->

    interval = 50
    limit = 1e3
    token = "player/wait-for-switch-#{token}"

    Timer.remove token

    tsCheck = $.now()
    Timer.loop token, interval, ->

      if n == Party.current
        Timer.remove token
        callback()
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

# execute
Player = new Player()