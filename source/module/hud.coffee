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
    [x, y] = $.getPosition()
    x1 = Math.round (x * 100) / client.width
    y1 = Math.round (y * 100) / client.height
    console.log "#{x1}, #{y1} / #{color}"
    ClipBoard = color

  getPosition: (n) ->

    if client.width + 100 < A_ScreenWidth
      left = client.width
    else left = client.vw 80

    return [
      left
      client.vh 4 + 9 * (n + 1)
    ]

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
      skillTimer.hide n