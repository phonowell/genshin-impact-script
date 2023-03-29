# @ts-check

# @ts-ignore
import __e_charge__ from '../../gis-static/data/character-e-charge.yaml'

class SkillG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/skill').SkillG['listCache'] ###
    @listCache = {}

    ###* @type import('./type/skill').SkillG['listCharacterECharge'] ###
    @listCharacterECharge = __e_charge__.list

    ###* @type import('./type/skill').SkillG['listCountDown'] ###
    @listCountDown = {}

    ###* @type import('./type/skill').SkillG['listDuration'] ###
    @listDuration = {}

    ###* @type import('./type/skill').SkillG['listRecord'] ###
    @listRecord = {}

    ###* @type import('./type/skill').SkillG['tsUseE'] ###
    @tsUseE = 0

  ###* @type import('./type/skill').SkillG['aboutBinding'] ###
  aboutBinding: ->
    @registerEvent 'use-e', 'e'
    @registerEvent 'use-q', 'q'
    @on 'use-e:start', @startE
    @on 'use-e:end', @endE
    @on 'use-q:start', @useQ
    return

  ###* @type import('./type/skill').SkillG['correctCD'] ###
  correctCD: (cd) ->
    unless Buff.has 'impetuous winds' then return cd * 1e3
    return cd * 1e3 * 0.95

  ###* @type import('./type/skill').SkillG['endE'] ###
  endE: ->

    {current, name} = Party
    unless current then return

    unless @listRecord[current] then return

    unless Scene.is 'normal' then return

    {typeE} = Character.get name
    switch typeE
      when 1 then @endEAsType1()
      when 2 then @endEAsType2()
      when 3 then @endEAsType3 current
      when 4 then @endEAsType4()
      else
        isHolding = $.now() - @listRecord[current] >= 500
        unless isHolding then @endEAsDefault()
        else @endEAsHolding()

    @tsUseE = $.now()
    return

  ###* @type import('./type/skill').SkillG['endEAsDefault'] ###
  endEAsDefault: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    cd = @correctCD cdE[0]
    duration = durationE[0] * 1e3
    record = @listRecord[current]

    @listCountDown[current] = record + cd
    if duration then @listDuration[current] = record + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    return

  ###* @type import('./type/skill').SkillG['endEAsHolding'] ###
  endEAsHolding: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    cd = @correctCD cdE[1]
    duration = durationE[1] * 1e3
    record = @listRecord[current]

    @listCountDown[current] = record + cd
    if duration then @listDuration[current] = record + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    return

  ###* @type import('./type/skill').SkillG['endEAsType1'] ###
  endEAsType1: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    cd = @correctCD cdE[1]
    duration = durationE[1] * 1e3
    now = $.now()

    @listCountDown[current] = now + cd
    if duration then @listDuration[current] = now + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    return

  ###* @type import('./type/skill').SkillG['endEAsType2'] ###
  endEAsType2: ->
    {current} = Party
    unless @listDuration[current]
      @endEAsDefault()
      return

  ###* @type import('./type/skill').SkillG['endEAsType3'] ###
  endEAsType3: (current) ->

    unless @listDuration[current]
      @endEAsDefault()
      return

    name = Party.list[current]
    {durationE} = Character.get name

    now = $.now()
    cd = (@correctCD 30e3 - (@listDuration[current] - now) + 6e3 - 1e3) / 1e3
    duration = durationE[0] * 1e3

    @listCountDown[current] = now + cd
    @listDuration[current] = 0

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    return

  ###* @type import('./type/skill').SkillG['endEAsType4'] ###
  endEAsType4: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    duration = durationE[1] * 1e3
    cd = (@correctCD cdE[1]) + duration
    record = @listRecord[current]

    @listCountDown[current] = record + cd
    if duration then @listDuration[current] = record + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    return

  ###* @type import('./type/skill').SkillG['freeze'] ###
  freeze: ->
    unless Character.is Party.name, '5-star' then return
    # Scene.freezeAs ['normal', 'single', 'using-q'], 1500

  ###* @type import('./type/skill').SkillG['init'] ###
  init: ->

    return

    unless Config.get 'misc/use-skill-timer' then return
    @reset()
    @aboutBinding()
    @watch()

  ###* @type import('./type/skill').SkillG['isEUsed'] ###
  isEUsed: ->

    unless State.is 'free' then return
    unless $.now() - @tsUseE > 500 then return

    {current, name} = Party
    unless name then return

    {typeE} = Character.get name
    if typeE == 2 then return

    unless @listCountDown[current] then return

    @isEUsed2()

  ###* @type import('./type/skill').SkillG['isEUsed2'] ###
  isEUsed2: ->

    {current} = Party

    if ColorManager.findAll 0xFFFFFF, @makeArea1()
      a = @makeArea2()
      unless $.length a then return
      unless ColorManager.findAll 0x00DCF9, a then return
      else
        @listCountDown[current] = 1
        return

    @listCountDown[current] = 1
    @listDuration[current] = 1
    return

  ###* @type import('./type/skill').SkillG['makeArea1'] ###
  makeArea1: ->
    {name} = Party
    {typeSprint} = Character.get name
    if typeSprint == 1 then return ['81%', '90%', '85%', '93%']
    return ['86%', '90%', '90%', '93%']

  ###* @type import('./type/skill').SkillG['makeArea2'] ###
  makeArea2: ->
    unless $.includes @listCharacterECharge, Party.name then return []
    return ['87%', '87%', '89%', '89%']

  ###* @type import('./type/skill').SkillG['reset'] ###
  reset: ->
    for n in [1, 2, 3, 4, 5]
      @listCache[n] = [0, 0]
      @listCountDown[n] = 0
      @listDuration[n] = 0
      @listRecord[n] = 0
    return

  ###* @type import('./type/skill').SkillG['startE'] ###
  startE: ->

    {current} = Party
    unless current then return

    unless Scene.is 'normal' then return

    now = $.now()
    cd = @listCountDown[current]
    if cd and cd - now > 500  then return
    if @listRecord[current] then return
    @listRecord[current] = now
    return

  ###* @type import('./type/skill').SkillG['switchQ'] ###
  switchQ: (slot) ->

    unless State.is 'free'
      $.press "alt + #{slot}"
      return

    if Party.current == slot
      @useQ()
      return

    $.press "alt + #{slot}"
    Party.emit 'switch', slot
    @freeze()

  ###* @type import('./type/skill').SkillG['useE'] ###
  useE: (isHolding = false, callback = undefined) ->

    unless Scene.is 'normal' then return

    delay = 50
    if isHolding then delay = 800

    $.press 'e:down'
    @startE()

    Timer.add 'skill/use', delay, =>
      $.press 'e:up'
      @endE()
      if callback then callback()

  ###* @type import('./type/skill').SkillG['useQ'] ###
  useQ: ->

    unless State.is 'free' then return

    $.press 'q'
    @freeze()

    {current, name} = Party
    unless current then return
    return

  ###* @type import('./type/skill').SkillG['watch'] ###
  watch: -> Scene.useExact ['single'], =>
    [interval, token] = [200, 'skill/watch']
    Timer.loop token, interval, =>
      Dashboard.update()
      if Timer.hasElapsed 'skill/is-e-used', 1e3 then @isEUsed()
    return -> Timer.remove token

# @ts-ignore
Skill = new SkillG()