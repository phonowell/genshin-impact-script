class FishingX

  isActive: false
  isPulling: false

  constructor: ->
    $.on 'f11', @toggle

  checkIsFishing: -> return !!(@findColor 0xFFFFFF, ['94%', '94%'], ['98%', '97%'])

  checkShape: ->

    # 0, return
    # 1, return
    # 2, pull

    color = 0xFFFFC0
    start = ['35%', '8%']
    end = ['65%', '18%']

    p1 = @findColor color, start, end
    unless p1 then return 0

    p2 = @findColor color, [start[0], p1[1] + 5], end
    unless p2 then return 0

    if p1[0] - p2[0] > (Point.vw 2) then return 1
    return 2

  checkStart: -> return !(@findColor 0xFFE92C, ['82%', '87%'], ['87%', '97%'])

  findColor: (color, start, end) ->
    p = ColorManager.find color, (Point.new start), Point.new end
    if Point.isValid p then return p
    return false

  next: ->

    @isPulling = false

    Timer.add 'fishing', 2e3, =>
      $.press 'l-button'
      Timer.add 'fishing', 1e3, @start

  pull: ->
    @isPulling = true
    $.press 'l-button:down'
    Timer.add 50, -> $.press 'l-button:up'

  start: ->
    Timer.add 'fishing/notice', 60e3, -> Sound.beep 3
    $.press 'l-button'

  toggle: ->

    @isActive = !@isActive

    Timer.remove 'fishing/watch'
    Timer.remove 'fishing'
    Timer.remove 'fishing/notice'

    if @isActive
      Scene.name = 'fishing'
      Timer.loop 'fishing/watch', 100, @watch
      Hud.render 0, 'auto fish [ON]'
    else
      Scene.name = 'unknown'
      Hud.render 0, 'auto fish [OFF]'

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