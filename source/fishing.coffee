### interface
type Shape = 0 | 1 | 2 # return, return, pull
###

# function

class Fishing

  isActive: false
  isPulling: false

  constructor: ->
    $.on 'f11', @toggle

  # checkIsFishing(): boolean
  checkIsFishing: -> return ColorManager.findAll 0xFFFFFF, [
    '94%', '94%'
    '98%', '97%'
  ]

  # checkShapre(): Shape
  checkShape: ->

    color = 0xFFFFC0
    start = ['35%', '8%']
    end = ['65%', '18%']

    p1 = ColorManager.findAny color, [start, end]
    unless p1 then return 0

    p2 = ColorManager.findAny color, [[start[0], p1[1] + 5], end]
    unless p2 then return 0

    if p1[0] - p2[0] > (Point.w '2%') then return 1
    return 2

  # checkStart(): boolean
  checkStart: -> return !ColorManager.findAll 0xFFE92C, [
    '82%', '87%'
    '87%', '97%'
  ]

  # next(): void
  next: ->

    @isPulling = false

    Timer.add 'fishing', 2e3, =>
      $.press 'l-button'
      Timer.add 'fishing', 1e3, @start

  # pull(): void
  pull: ->
    @isPulling = true
    $.press 'l-button:down'
    Timer.add 50, -> $.press 'l-button:up'

  # start(): void
  start: ->
    Timer.add 'fishing/notice', 60e3, -> Sound.beep 3
    $.press 'l-button'

  # toggle(): void
  toggle: ->

    @isActive = !@isActive

    Timer.remove 'fishing/watch'
    Timer.remove 'fishing'
    Timer.remove 'fishing/notice'

    if @isActive
      Scene.is 'fishing'
      Timer.loop 'fishing/watch', 100, @watch
      Hud.render 0, 'auto fish [ON]'
    else
      Scene.is 'unknown'
      Hud.render 0, 'auto fish [OFF]'

  # watch(): void
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
Fishing = new Fishing()