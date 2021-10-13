### interface
type Point = [number, number]
type Position = 1 | 2 | 3 | 4 | 5
###

# function
class HudX

  lifetime: 5e3
  map: {}
  mapLast: {}
  tsUpdate: 0

  # ---

  constructor: ->
    Client.on 'tick', @update
    Client.on 'pause', @hideAll

  # hide: (n: Position, isForce: boolean = false): void
  hide: (n, isForce = false) ->
    unless @mapLast[n] or isForce then return
    @mapLast[n] = ''
    id = n + 1
    `ToolTip,, 0, 0, % id`

  # hideAll(): void
  hideAll: -> for n in [1, 2, 3, 4, 5]
    @hide n, true

  # makePosition: (n: Position): Point
  makePosition: (n) ->

    if Client.isFullScreen
      left = Client.vw 80
    else left = Client.width

    return [
      left
      Client.vh 22 + 9 * (n - 1)
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

    now = $.now()
    unless now - @tsUpdate >= interval then return
    @tsUpdate = now

    for n in [1, 2, 3, 4, 5]

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

    if Config.data.isDebug
      cost = $.now() - now
      if cost >= 20 then console.log "hud/cost: #{$.now() - now} ms"

# execute
Hud = new HudX()