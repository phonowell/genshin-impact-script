class FishingX

  isActive: false

  constructor: ->
    $.on 'f11', @toggle

  checkIsFishing: ->

    color = 0xFFFFFF
    start = Client.point [94, 94]
    end = Client.point [98, 97]

    p1 = @findColor color, start, end
    unless p1 then return false

    return true

  checkShape: ->

    color = 0xFFFFC0
    start = Client.point [35, 8]
    end = Client.point [65, 18]

    p1 = @findColor color, start, end
    unless p1 then return 0

    p2 = @findColor color, [start[0], p1[1] + 5], end
    unless p2 then return 0

    if p1[0] - p2[0] > (Client.vw 2) then return 1
    return 2

  checkStart: ->

    color = 0xFFE92C
    start = Client.point [82, 87]
    end = Client.point [87, 97]

    p1 = @findColor color, start, end
    if p1 then return false

    return true

  findColor: (color, start, end) ->
    [x, y] = $.findColor color, start, end
    if x * y > 0 then return [x, y]
    return false

  pull: ->
    $.press 'l-button:down'
    $.setTimeout ->
      $.press 'l-button:up'
    , 50

  start: -> $.press 'l-button'

  toggle: ->

    @isActive = !@isActive

    $.clearInterval timer.fishing

    if @isActive
      Scene.name = 'fishing'
      timer.fishing = $.setInterval @watch, 100
      Hud.render 5, 'enter fishing mode'
    else
      Scene.name = 'unknown'
      Hud.render 5, 'leave fishing mode'

    $.beep()

  watch: ->

    unless @checkIsFishing() then return

    shape = @checkShape()

    unless shape
      unless @checkStart() then return
      @start()
      return

    unless shape == 2 then return

    @pull()

# execute
Fishing = new FishingX()