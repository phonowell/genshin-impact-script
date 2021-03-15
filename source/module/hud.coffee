class HudX

  lifetime: 5e3
  listTimer: {}

  constructor: ->

    client.on 'leave', @hide

    $.on 'alt + f9', ->
      $.beep()
      hud.getColor()

  getColor: ->

    color = $.getColor()

    [x, y] = $.getPosition()
    x1 = $.round (x * 100) / client.width
    y1 = $.round (y * 100) / client.height

    @render 5, "#{x1}, #{y1} / #{color}"
    ClipBoard = color

  getPosition: (n) ->

    $$.vt 'hud.getPosition', n, 'number'

    if client.isFullScreen
      left = client.vw 80
    else left = client.width

    return [
      left
      client.vh 4 + 9 * (n + 1)
    ]

  hide: -> for n in [1, 2, 3, 4, 5]
    @render n, ''

  render: (n, msg) ->

    $$.vt 'hud.render', n, 'number'
    $$.vt 'hud.render', msg, 'string'

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

$$.log = (message) ->

  unless $$.isDebug
    return

  $$.vt '$$.log', message, 'string'

  hud.render 5, message
  return message