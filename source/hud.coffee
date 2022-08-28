### interface
type Point = [number, number]
type Slot = 0 | 1 | 2 | 3 | 4 | 5
###

# function

class Hud

  lifetime: 5e3
  map: {}
  mapLast: {}

  constructor: ->
    Client.on 'leave', @hideAll
    @watch()

  # hide: (n: Slot, isForce: boolean = false): void
  hide: (n, isForce = false) ->
    unless @mapLast[n] or isForce then return
    @mapLast[n] = ''
    id = n + 1
    `ToolTip,, 0, 0, % id`

  # hideAll(): void
  hideAll: -> for n in [0, 1, 2, 3, 4, 5]
    @hide n, true

  # makePosition: (n: Slot): Point
  makePosition: (n) ->

    if Client.isFullScreen
      left = Point.w '80%'
    else left = Client.width

    unless n then n = Party.total + 1

    return [
      left
      Point.h "#{[37, 32, 28, 23, 19][Party.total - 1] + 9 * (n - 1) - 1}%"
    ]

  # render(n: Slot, msg: string): void
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
    token = 'hud/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @update

# execute
Hud = new Hud()