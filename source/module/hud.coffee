class HudX

  lifetime: 5e3
  listTimer: {}

  constructor: -> client.on 'pause', @hide

  getPosition: (n) ->

    if client.isFullScreen
      left = client.vw 80
    else left = client.width

    return [
      left
      client.vh 22 + 9 * (n - 1)
    ]

  hide: -> for n in [1, 2, 3, 4, 5]
    @render n, ''

  render: (n, msg) ->

    $.clearTimeout @listTimer[n]
    @listTimer[n] = $.setTimeout =>
      @render n, ''
    , @lifetime

    [x, y] = @getPosition n
    id = n + 1
    `ToolTip, % msg, % x, % y, % id`

  reset: ->
    for timer of @listTimer
      $.clearTimeout timer
    @listTimer = {}
    @hide()

# execute
hud = new HudX()