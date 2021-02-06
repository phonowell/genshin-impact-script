class HudX

  checkPosition: (n) ->

    [pointStart, pointEnd] = @getRange n

    for name, char of Character

      unless char.color
        continue

      point = $.findColor char.color, pointStart, pointEnd
      unless point[0] * point[1] > 0
        continue

      return name

    return '?'

  find: ->

    for n in [1, 2, 3, 4]
      skillTimer.member[n] = @checkPosition n
    skillTimer.listMember()

  getColor: ->

    color = $.getColor()
    console.log color
    ClipBoard = color

  getPosition: (n) ->

    return [
      client.width - 300
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