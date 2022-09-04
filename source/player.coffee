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

  # aboutSkill(): void
  aboutSkill: ->
    @registerEvent 'use-e', 'e'
    @registerEvent 'use-q', 'q'
    @on 'use-e:start', Skill.startE
    @on 'use-e:end', Skill.endE
    @on 'use-q:start', Skill.useQ

  # aboutSwitch(): void
  aboutSwitch: ->

    for key in [1, 2, 3, 4, 5]
      @registerEvent 'raw-switch', key
      $.on "alt + #{key}", => @switchQ key

    for step in ['start', 'end']
      @on "raw-switch:#{step}", (key) =>
        unless Scene.is 'normal' then return
        unless key <= Party.total then return
        @emit "switch:#{step}", key

    @on 'switch:start', (key) =>

      Party.switchTo key
      @waitForSwitch 'start', key, =>

        onSwitch = @getOnSwitch()
        unless onSwitch then return

        if onSwitch == 'e'
          $.press 'e:down'
          Skill.startE()
          return

    @on 'switch:end', (key) => @waitForSwitch 'end', key, => Timer.add 50, =>

      onSwitch = @getOnSwitch()
      unless onSwitch then return

      if onSwitch == 'e'
        $.press 'e:up'
        Skill.endE()
        return

      Tactic.start onSwitch, true

  # getOnSwitch(): string
  getOnSwitch: ->

    {name} = Party
    unless name then return ''

    {onSwitch} = Character.get name
    unless onSwitch then return ''

    return onSwitch

  # switchQ(key: Slot): void
  switchQ: (key) ->

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