class HudX

  lifetime: 5e3
  map: {}

  constructor: ->
    client.on 'tick', @update
    client.on 'pause', @hideAll

  hide: (n) ->
    id = n + 1
    `ToolTip,, 0, 0, % id`

  hideAll: -> for n in [1, 2, 3, 4, 5]
    @hide n

  makePosition: (n) ->

    if client.isFullScreen
      left = client.vw 80
    else left = client.width

    return [
      left
      client.vh 22 + 9 * (n - 1)
    ]

  render: (n, msg) -> @map[n] = [
    $.now() + @lifetime
    msg
  ]

  reset: ->
    @map = {}
    @hide()

  update: ->

    unless Scene.name == 'normal' then return

    now = $.now()

    for n in [1, 2, 3, 4, 5]

      [time, msg] = @map[n]

      unless msg
        @hide n
        continue

      unless now < time
        @hide n
        continue

      [x, y] = @makePosition n
      id = n + 1
      `ToolTip, % msg, % x, % y, % id`

# execute
hud = new HudX()