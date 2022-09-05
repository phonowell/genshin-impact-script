class Alice

  isActive: false

  constructor: ->
    $.on 'Sc029', =>
      unless @isActive then @start()
      else @stop()
    @watch()

  # check(): void
  check: ->
    unless Scene.is 'normal' then return
    unless @isActive then return
    if Tactic.isActive then return
    @next()

  # next(): void
  next: ->

    unless Scene.is 'normal' then return

    isIdle = true

    if $.now() - Party.tsSwitch > 1e3
      isIdle = @nextSub()

    if isIdle then Tactic.start 'a', $.noop

  # nextSub(): boolean
  nextSub: ->

    isIdle = true

    for n in [1, 2, 3, 4, 5]

      if n > Party.total then break

      name = Party.listMember[n]
      unless name then continue

      onLongPress = Character.get name, 'onLongPress'
      unless onLongPress then continue
      unless $.includes onLongPress, 'e' then continue
      if $.includes onLongPress, 'q' then continue

      cd = Skill.listCountDown[n]
      if cd then continue

      isIdle = false
      @switchTo n, -> Tactic.start onLongPress, $.noop
      break

    return isIdle

  # start(): void
  start: ->
    Tactic.stop()
    @isActive = true
    Hud.render 0, 'hosting [on]'

  # stop(): void
  stop: ->
    Tactic.stop()
    @isActive = false
    Hud.render 0, 'hosting [off]'

  # switchTo(n: number, callback: Fn): void
  switchTo: (n, callback = '') ->

    $.press n
    Party.switchTo n

    interval = 50
    limit = 10e3
    token = 'alice/switchTo'

    Timer.remove token

    tsCheck = $.now()
    Timer.loop token, interval, ->

      if n == Party.current
        Timer.remove token
        Timer.add token, interval, callback
        return

      unless $.now() - tsCheck >= limit
        $.press n
        Party.switchTo n
        return

      Timer.remove token

  # watch(): void
  watch: ->

    interval = 500
    token = 'alice/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @check

# execute
Alice = new Alice()