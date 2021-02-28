class HudX

  lifetime: 5e3
  listTimer: {}

  constructor: -> client.on 'leave', @hide

  getColor: ->

    color = $.getColor()

    [x, y] = $.getPosition()
    x1 = Math.round (x * 100) / client.width
    y1 = Math.round (y * 100) / client.height

    @render 5, "#{x1}, #{y1} / #{color}"
    ClipBoard = color

  getPosition: (n) ->

    if client.width + 100 < A_ScreenWidth
      left = client.width
    else left = client.vw 80

    return [
      left
      client.vh 4 + 9 * (n + 1)
    ]

  hide: -> for n in [1, 2, 3, 4, 5]
    @render n, ''

  render: (n, msg) ->

    clearTimeout @listTimer[n]
    @listTimer[n] = $.delay @lifetime, =>
      @render n, ''

    [x, y] = @getPosition n
    id = n + 1
    `ToolTip, % msg, % x, % y, % id`

  reset: ->
    for timer of @listTimer
      clearTimeout timer
    @listTimer = {}
    @hide()

# execute
hud = new HudX()