class Alice

  map: {}

  constructor: ->
    @init()

  # init(): void
  init: ->
    Party.on 'change', @prepare
    $.on 'Sc029', @next

  # next(): void
  next: ->

    unless $.length @map then return
    unless Scene.is 'normal' then return

    list = $.keys @map
    list = $.map list, (it) -> return $.subString it, 1
    list = $.filter list, (n) -> return n != Party.current
    $.unshift list, Party.current

    for n in list

      cd = Skill.listCountDown[n]
      if cd then continue

      @switchTo n, => Tactic.start @map["p#{n}"], $.noop
      break

  # prepare(): void
  prepare: ->

    @map = {}

    for n in [1, 2, 3, 4, 5]
      if n > Party.total then break

      name = Party.listMember[n]
      unless name then continue

      lines = Character.get name, 'onSwitch'
      unless lines then continue

      @map["p#{n}"] = lines

  # switchTo(n: number, callback: Fn): void
  switchTo: (n, callback = '') ->

    $.press n
    Party.switchTo n

    interval = 50
    limit = 5e3
    token = 'alice/switchTo'

    Timer.remove token

    tsCheck = $.now()
    Timer.loop token, interval, ->

      if n == Party.current
        Timer.remove token
        Timer.add token, interval, callback
        return

      unless $.now() - tsCheck >= limit
        Party.switchTo n
        return

      Timer.remove token
      $.beep()

# execute
Alice = new Alice()