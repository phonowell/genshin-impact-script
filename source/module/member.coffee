ts.toggle = 0

# function

class MemberX extends EmitterShellX

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

      if @has name
        continue

      unless char.colorAvatar
        continue

      point = $.findColor char.colorAvatar, pointStart, pointEnd
      unless point[0] * point[1] > 0
        continue

      return name

    return ''

  getIndexBy: (name) ->

    unless @has name
      return 0
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

    @list = ['']

    for n in [1, 2, 3, 4]
      name = @checkCharacterByPosition n
      $.push @list, name
      hud.render n, name

    @emit 'change'

  toggle: (n) ->

    unless n
      return

    player.current = n
    player.name = @list[n]
    ts.toggle = $.now()

    if @has 'tartaglia'
      skillTimer.endTartaglia()

  toggleBy: (name) -> @toggle @getIndexBy name

# execute
member = new MemberX()