# @ts-check

class HudG

  constructor: ->

    ###* @type import('./type/hud').HudG['lifetime'] ###
    @lifetime = 5e3

    ###* @type import('./type/hud').HudG['map'] ###
    @map = {}

    ###* @type import('./type/hud').HudG['mapLast'] ###
    @mapLast = {}

    ###* @type import('./type/hud').HudG['namespace'] ###
    @namespace = 'hud'

  ###* @type import('./type/hud').HudG['hide'] ###
  hide: (n, isForce) ->
    unless @mapLast[n] or isForce then return
    @mapLast[n] = ''
    id = n + 1

    $.noop id
    Native 'ToolTip,, 0, 0, % id'
    return

  ###* @type import('./type/hud').HudG['hideAll'] ###
  hideAll: ->
    for n in [0, 1, 2, 3, 4, 5]
      @hide n, true
    return

  ###* @type import('./type/hud').HudG['init'] ###
  init: -> @watch()

  ###* @type import('./type/hud').HudG['makePosition'] ###
  makePosition: (n) ->

    if Window2.isFullScreen
      left = Point.w '77%'
    else left = Window2.bounds.width

    [a, b] = [Party.size - 1, n - 1]
    unless Party.size then a = 3
    unless n then b = 4

    return [
      left
      Point.h "#{[37, 32, 28, 23, 19][a] + 9 * b - 1}%"
    ]

  ###* @type import('./type/hud').HudG['render'] ###
  render: (n, msg) ->
    @map[n] = [
      $.now() + @lifetime
      msg
    ]
    return

  ###* @type import('./type/hud').HudG['reset'] ###
  reset: ->
    @map = {}
    @mapLast = {}
    @hideAll()

  ###* @type import('./type/hud').HudG['update'] ###
  update: ->

    interval = 200
    unless Timer.hasElapsed 'hud/throttle', interval then return

    now = $.now()

    for n in [0, 1, 2, 3, 4, 5]

      [time, msg] = @map[n]

      unless msg
        @hide n, false
        continue

      unless now < time
        @hide n, false
        continue

      if msg == @mapLast[n] then continue
      @mapLast[n] = msg

      [x, y] = @makePosition n
      id = n + 1
      $.noop x, y, id
      Native 'ToolTip, % msg, % x, % y, % id'

    return

  ###* @type import('./type/hud').HudG['watch'] ###
  watch: -> Client.useActive =>
    [interval, token] = [200, 'hud/watch']
    Timer.loop token, interval, @update
    return =>
      Timer.remove token
      @hideAll()

# @ts-ignore
Hud = new HudG()