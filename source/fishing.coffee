# @ts-check

### interface
type Shape = 0 | 1 | 2 # return, return, pull
###

class FishingG

  constructor: ->

    ###* @type import('./type/fishing').FishingG['isActive'] ###
    @isActive = false

    ###* @type import('./type/fishing').FishingG['isPulling'] ###
    @isPulling = false

    ###* @type import('./type/fishing').FishingG['namespace'] ###
    @namespace = 'fishing'

  ###* @type import('./type/fishing').FishingG['checkIsFishing'] ###
  checkIsFishing: -> ColorManager.findAll 0xFFFFFF, [
    '94%', '94%'
    '98%', '97%'
  ]

  ###* @type import('./type/fishing').FishingG['checkShape'] ###
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

  ###* @type import('./type/fishing').FishingG['checkStart'] ###
  checkStart: -> not ColorManager.findAll 0xFFE92C, [
    '82%', '87%'
    '87%', '97%'
  ]

  ###* @type import('./type/fishing').FishingG['init'] ###
  init: -> $.on 'f11', @toggle

  ###* @type import('./type/fishing').FishingG['next'] ###
  next: ->

    @isPulling = false

    Timer.add 'fishing/next', 2e3, =>
      $.press 'l-button'
      Timer.add 'fishing/next', 1e3, @start

  ###* @type import('./type/fishing').FishingG['pull'] ###
  pull: ->
    @isPulling = true
    $.press 'l-button:down'
    Timer.add 50, -> $.press 'l-button:up'

  ###* @type import('./type/fishing').FishingG['start'] ###
  start: ->
    Timer.add 'fishing/notice', 60e3, -> Sound.beep 3
    $.press 'l-button'

  ###* @type import('./type/fishing').FishingG['toggle'] ###
  toggle: ->

    unless @isActive

      unless Scene.is 'normal'
        Sound.beep()
        return

      if State.is 'free', 'not-domain'
        Sound.beep()
        return

      @isActive = true

    else @isActive = false

    Timer.remove 'fishing/watch'
    Timer.remove 'fishing/next'
    Timer.remove 'fishing/notice'

    if @isActive
      Timer.loop 'fishing/watch', 50, @watch
      Hud.render 0, 'auto fish [ON]'
    else Hud.render 0, 'auto fish [OFF]'

  ###* @type import('./type/fishing').FishingG['watch'] ###
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

# @ts-ignore
Fishing = new FishingG()