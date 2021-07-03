ts.toggle = 0

# function

class MemberX extends EmitterShellX

  isBusy: false
  list: ['']

  constructor: ->
    super()

    @on 'change', =>
      $.press 1
      @toggle 1

    $.on 'f12', @scan

  checkCharacterByPosition: (n) ->

    [pointStart, pointEnd] = @getRange n

    for name, char of Character.data

      if @has name then continue
      unless char.colorAvatar then continue

      point = $.findColor char.colorAvatar, pointStart, pointEnd
      unless point[0] * point[1] > 0 then continue

      return name

    return ''

  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4]
      if @list[n] == name
        return n

  getRange: (n) ->

    start = client.point [
      90
      20 + 9 * (n - 1)
    ]

    end = client.point [
      96
      20 + 9 * n
    ]

    return [start, end]

  has: (name) -> return $.includes @list, name

  scan: ->

    if @isBusy then return
    @isBusy = true

    @list = ['']
    skillTimer.reset()
    hud.reset()

    for n in [1, 2, 3, 4]

      name = @checkCharacterByPosition n
      $.push @list, name

      char = Character.data[name]
      if Config.data.region == 'en'
        hud.render n, char.nameEN
      else hud.render n, char.nameCN

    @emit 'change'
    @isBusy = false

  toggle: (n) ->

    unless n then return

    player.current = n
    player.name = @list[n]
    ts.toggle = $.now()

    if @has 'tartaglia' then skillTimer.endTartaglia()

  toggleBy: (name) -> @toggle @getIndexBy name

# execute
member = new MemberX()