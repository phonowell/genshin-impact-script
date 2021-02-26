class MemberX

  current: 0
  map: {}
  name: ''

  # ---

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

  scan: ->
    for n in [1, 2, 3, 4]
      name = @checkCharacterByPosition n
      @map[n] = name
      hud.render n, name
    skillTimer.reset()

  toggle: (n) ->
    @current = n
    @name = @map[n]

# execute
member = new MemberX()