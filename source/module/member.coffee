class MemberX

  current: 0
  map: {}
  name: ''

  checkCharacterByPosition: (n) ->

    [pointStart, pointEnd] = @getRange n

    for name, char of Character

      unless char.color
        continue

      point = $.findColor char.color, pointStart, pointEnd
      unless point[0] * point[1] > 0
        continue

      return name

    return ''

  getRange: (n) ->

    pointStart = [
      client.vw 90
      client.vh 9 * (n + 1)
    ]

    pointEnd = [
      client.vw 96
      client.vh 9 * (n + 2)
    ]

    return [pointStart, pointEnd]

  scan: ->

    skillTimer.listCountDown = {}

    for n in [1, 2, 3, 4]
      $.delay (n - 1) * 500, =>
        name = @checkCharacterByPosition n
        @map[n] = name
        hud.render n, name
        skillTimer.hide n

  toggle: (n) ->

    @current = n
    @name = @map[n]