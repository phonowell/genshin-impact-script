class MemberX

  map: {}

  constructor: -> $.on 'f12', @scan

  checkCharacterByPosition: (n) ->

    [pointStart, pointEnd] = @getRange n

    for name, char of Character.data

      unless char.color
        continue

      point = $.findColor char.color, pointStart, pointEnd
      unless point[0] * point[1] > 0
        continue

      return name

    return ''

  getIndexBy: (name) ->
    unless @has name
      return 0
    for n in [1, 2, 3, 4]
      if @map[n] == name
        return n

  getRange: (n) ->

    start = client.point [
      90
      9 * (n + 1)
    ]

    end = client.point [
      96
      9 * (n + 2)
    ]

    return [start, end]

  has: (name) -> return $.includes ($.values @map), name

  scan: ->

    for n in [1, 2, 3, 4]
      name = @checkCharacterByPosition n
      @map[n] = name
      hud.render n, name

    skillTimer.reset()

    unless player.current
      $.press '1'
      @toggle 1
    else @toggle player.current

  toggle: (n) ->
    unless n
      return
    player.current = n
    player.name = @map[n]

  toggleBy: (name) -> @toggle @getIndexBy name

# execute
member = new MemberX()