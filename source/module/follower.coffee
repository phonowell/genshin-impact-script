timer.follower = ''
timer.moveFollower = ''

# function

class FollowerX

  isActive: false
  pointCenter: [0, 0]
  pointEnd: client.point [16, 22]
  pointStart: client.point [2, 0]

  constructor: ->

    client.on 'leave', @stop

    $.on 'f8', =>
      unless @isActive
        @start()
      else @stop()

  move: (key) ->

    $$.vt 'follower.move', key, 'string'

    $.press "#{key}:down"

    $.clearTimeout timer.moveFollower
    timer.moveFollower = $.setTimeout ->
      player.jump()

      $.clearTimeout timer.moveFollower
      timer.moveFollower = $.setTimeout ->
        $.press "#{key}:up"
      , 600
    , 300

  next: ->

    if menu.checkVisibility()
      return

    listColor = [0x3D7E00, 0x408000, 0x4B870F]
    point = ''

    for color in listColor
      [x, y] = $.findColor color, @pointStart, @pointEnd, 0.9
      if x * y > 0
        point = [x, y]
        break

    unless point
      return

    diffX = point[0] - @pointCenter[0]
    diffY = point[1] - @pointCenter[1]

    if ($.abs diffX) > $.abs diffY
      if diffX > 0
        $$.log 'right'
        @move 'd'
      else
        $$.log 'left'
        @move 'a'
    else
      if diffY > 0
        $$.log 'down'
        @move 's'
      else
        $$.log 'up'
        @move 'w'

  resetKey: ->
    for key in ['w', 'a', 's', 'd']
      if $.getState key
        $.press "#{key}:up"

  start: ->

    $.beep()

    if menu.checkVisibility()
      return

    [x, y] = $.findColor 0x00FCFE, @pointStart, @pointEnd
    unless x * y > 0
      return
    @pointCenter = [x, y]

    if @isActive
      return
    @isActive = true

    $.clearInterval timer.follower
    timer.follower = $.setInterval @next, 1e3

  stop: ->

    $.beep()

    unless @isActive
      return
    @isActive = false

    $.clearInterval timer.follower
    @resetKey()

# execute
follower = new FollowerX()