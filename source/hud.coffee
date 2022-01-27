### interface
type Point = [number, number]
type Position = 0 | 1 | 2 | 3 | 4 | 5
###

# function
class HudX

  lifetime: 5e3
  map: {}
  mapLast: {}

  # ---

  constructor: ->
    Client.on 'pause', @hideAll
    @watch()

  # hide: (n: Position, isForce: boolean = false): void
  hide: (n, isForce = false) ->
    unless @mapLast[n] or isForce then return
    @mapLast[n] = ''
    id = n + 1
    `ToolTip,, 0, 0, % id`

  # hideAll(): void
  hideAll: -> for n in [0, 1, 2, 3, 4, 5]
    @hide n, true

  # makePosition: (n: Position): Point
  makePosition: (n) ->

    if Client.isFullScreen
      left = Point.vw 80
    else left = Client.width

    unless n then n = Party.total + 1

    return [
      left
      Point.vh [37, 32, 28, 23][Party.total - 1] + 9 * (n - 1) - 1
    ]

  # render(n: Position, msg: string): void
  render: (n, msg) -> @map[n] = [
    $.now() + @lifetime
    msg
  ]

  # reset(): void
  reset: ->
    @map = {}
    @mapLast = {}
    @hideAll()

  # update(): void
  update: ->

    interval = 200
    if Scene.name != 'normal' then interval = 1e3
    unless Timer.checkInterval 'hud/throttle', interval then return

    now = $.now()

    for n in [0, 1, 2, 3, 4, 5]

      [time, msg] = @map[n]

      unless msg
        @hide n
        continue

      unless now < time
        @hide n
        continue

      if msg == @mapLast[n] then continue
      @mapLast[n] = msg

      [x, y] = @makePosition n
      id = n + 1
      `ToolTip, % msg, % x, % y, % id`

  # watch(): void
  watch: ->
    interval = 200
    Client.on 'pause', -> Timer.remove 'hud/watch'
    Client.on 'resume', => Timer.loop 'hud/watch', interval, @update
    Timer.loop 'hud/watch', interval, @update

# execute
Hud = new HudX()