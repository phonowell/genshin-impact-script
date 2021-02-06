class HudX

  findCharacterByPosition: (n) ->

    [pointStart, pointEnd] = @getRange n

    for name, char of Character

      unless char.color
        continue

      point = $.findColor char.color, pointStart, pointEnd
      unless point[0] * point[1] > 0
        continue

      return name

    return '?'

  getColor: ->

    color = $.getColor()
    console.log color
    ClipBoard = color

  getPosition: (n) ->

    if client.width + 100 < A_ScreenWidth
      left = client.width
    else left = Math.round client.width * 0.8

    return [
      left
      Math.round client.height * (4 + 9 * (n + 1)) * 0.01
    ]

  getRange: (n) ->

    pointStart = [
      client.width - 150
      Math.round client.height * (9 * (n + 1)) * 0.01
    ]

    pointEnd = [
      client.width - 60
      Math.round client.height * (9 * (n + 2)) * 0.01
    ]

    return [pointStart, pointEnd]

  hide: -> for n in [1, 2, 3, 4]
    @render n, ''

  render: (n, msg) ->

    [x, y] = @getPosition n
    id = n + 2
    `ToolTip, % msg, % x, % y, % id`

  scan: ->

    skillTimer.listCountDown = {}

    for n in [1, 2, 3, 4]
      name = @findCharacterByPosition n
      skillTimer.member[n] = name
      @render n, name