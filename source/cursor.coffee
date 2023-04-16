# @ts-check

class CursorG

  constructor: ->

    ###* @type import('./type/cursor').CursorG['map'] ###
    @map = {
      left: false
      right: false
      up: false
      down: false
    }

    ###* @type import('./type/cursor').CursorG['speed'] ###
    @speed = 0

  ###* @type import('./type/cursor').CursorG['end'] ###
  end: (direction, speed) ->
    if speed != @speed then return
    @map[direction] = false
    @watch()

  ###* @type import('./type/cursor').CursorG['move'] ###
  move: ->

    if Scene.is 'normal'
      @stop()
      return

    d = @speed

    [x, y] = $.getPosition()
    if @map['left'] then x -= d
    if @map['right'] then x += d
    if @map['up'] then y -= d
    if @map['down'] then y += d

    margin = 10
    {width, height} = Window2.bounds
    if x < margin then x = margin
    if x > width - margin then x = width - margin
    if y < margin then y = margin
    if y > height - margin then y = height - margin

    $.move [x, y]

  ###* @type import('./type/cursor').CursorG['start'] ###
  start: (direction, speed) ->
    if @speed and speed != @speed then return
    @map[direction] = true
    @speed = speed
    @watch()

  ###* @type import('./type/cursor').CursorG['stop'] ###
  stop: ->
    @map['left'] = false
    @map['right'] = false
    @map['up'] = false
    @map['down'] = false
    @speed = 0
    @watch()

  ###* @type import('./type/cursor').CursorG['watch'] ###
  watch: ->

    interval = 15
    token = 'cursor/watch'
    eventIdle = 'idle.cursor'
    eventActivate = 'activate.cursor'

    unless (@map['left'] or @map['right'] or @map['up'] or @map['down'])
      @speed = 0
      Client.off eventIdle
      Client.off eventActivate
      Timer.remove token
      return

    Client.on eventIdle, -> Timer.remove token
    Client.on eventActivate, => Timer.loop token, interval, @move
    Timer.loop token, interval, @move

# @ts-ignore
Cursor = new CursorG()