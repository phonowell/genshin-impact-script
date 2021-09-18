class FishingX

  isActive: false
  isPulling: false

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

    # 0, return
    # 1, return
    # 2, pull

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

  delay: (time, callback) ->
    $.clearTimeout timer.delayFishing
    timer.delayFishing = $.setTimeout callback, time

  findColor: (color, start, end) ->
    [x, y] = $.findColor color, start, end
    if x * y > 0 then return [x, y]
    return false

  next: ->

    @isPulling = false

    @delay 2e3, =>
      $.press 'l-button'
      @delay 1e3, @start

  notice: ->
    $.beep()
    @delay 500, =>
      $.beep()
      @delay 500, $.beep

  pull: ->
    @isPulling = true
    $.press 'l-button:down'
    @delay 50, -> $.press 'l-button:up'

  start: ->
    $.clearTimeout timer.noticeFishing
    timer.noticeFishing = $.setTimeout @notice, 60e3
    $.press 'l-button'

  toggle: ->

    @isActive = !@isActive

    $.clearInterval timer.fishing
    $.clearTimeout timer.delayFishing
    $.clearTimeout timer.noticeFishing

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

      if @isPulling
        @next()
        return

      unless @checkStart() then return
      @start()
      return

    unless shape == 2 then return

    @pull()

# execute
Fishing = new FishingX()