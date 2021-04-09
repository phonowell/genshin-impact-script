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

    $$.vt 'member.checkCharacterByPosition', n, 'number'

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

    $$.vt 'member.getIndexBy', name, 'string'

    unless @has name
      return 0
    for n in [1, 2, 3, 4]
      if @list[n] == name
        return n

  getRange: (n) ->

    $$.vt 'member.getRange', n, 'number'

    start = client.point [
      90
      9 * (n + 1)
    ]

    end = client.point [
      96
      9 * (n + 2)
    ]

    return [start, end]

  has: (name) ->
    $$.vt 'client.has', name, 'string'
    return $.includes @list, name

  scan: ->

    @list = ['']

    for n in [1, 2, 3, 4]
      name = @checkCharacterByPosition n
      $.push @list, name
      hud.render n, name

    @emit 'change'

  toggle: (n) ->

    $$.vt 'member.toggle', n, 'number'

    unless n
      return

    player.current = n
    player.name = @list[n]
    ts.toggle = $.now()

    if @has 'tartaglia'
      skillTimer.endTartaglia()

  toggleBy: (name) ->
    $$.vt 'client.toggleBy', name, 'string'
    @toggle @getIndexBy name

# execute
member = new MemberX()