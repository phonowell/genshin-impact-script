### interface
type Slot = 1 | 2 | 3 | 4 | 5
###

# function

class Skill

  listCache: {}
  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}

  constructor: ->
    @reset()
    @watch()

  # cancelCheck(): void
  cancelCheck: ->

    token = 'skill/check'
    Timer.remove token

    {current, name} = Party
    unless @listCountDown[current] then return
    console.log "#{token}: #{name} cancelled"

  # check(): void
  check: ->

    token = 'skill/check'
    Timer.remove token

    {current, name} = Party

    interval = 15
    limit = 1e3

    tsCheck = $.now()
    Timer.loop token, interval, =>

      a = [
        '86%', '90%'
        '90%', '93%'
      ]

      if name == 'mona' || name == 'kamisato_ayaka'
        a = [
          '81%', '90%'
          '85%', '93%'
        ]

      diff = $.now() - tsCheck

      if ColorManager.findAll 0xFFFFFF, a
        Timer.remove token
        console.log "#{token}: #{name} passed in #{diff} ms"
        return

      unless diff >= limit then return
      Timer.remove token

      console.log "#{token}: #{name} failed after #{diff} ms"

      @listCountDown[current] = 1
      @listDuration[current] = 1

  # correctCD(cd: number): number
  correctCD: (cd) ->
    unless Party.hasBuff 'impetuous winds' then return cd * 1e3
    return cd * 1e3 * 0.95

  # endE(): void
  endE: ->

    {current, name} = Party
    unless name then return

    unless @listRecord[current] then return

    {typeE} = Character.get name
    switch typeE
      when 1 then @endEAsType1()
      when 2 then @endEAsType2 current
      when 3 then @endEAsType3()
      else
        isHolding = $.now() - @listRecord[current] > 500
        unless isHolding then @endEAsDefault()
        else @endEAsHolding()

  # endEAsDefault(): void
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
    @check()

  # endEAsHolding(): void
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
    @check()

  # endEAsType1(): void
  endEAsType1: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    cd = @correctCD cdE[1]
    duration = durationE[1] * 1e3
    now = $.now()
    record = @listRecord[current]

    @listCountDown[current] = now + cd
    if duration then @listDuration[current] = now + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    @check()

  # endEAsType2(current: Slot): void
  endEAsType2: (current) ->

    unless @listDuration[current]
      @endEAsDefault()
      return

    name = Party.listMember[current]
    {durationE} = Character.get name

    now = $.now()
    cd = (@correctCD 30e3 - (@listDuration[current] - now) + 6e3 - 1e3) / 1e3
    duration = durationE[0] * 1e3

    @listCountDown[current] = now + cd
    @listDuration[current] = 0

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    @check()

  # endEAsType3(): void
  endEAsType3: ->

    {current, name} = Party
    {cdE, durationE} = Character.get name

    duration = durationE[1] * 1e3
    cd = (@correctCD cdE[1]) + duration
    record = @listRecord[current]

    @listCountDown[current] = record + cd
    if duration then @listDuration[current] = record + duration

    @listCache[current] = [cd, duration]
    @listRecord[current] = 0
    # @check()

  # format(n: number): string
  format: (n) ->
    if ($.abs n) > 1e3 then return "#{$.floor n * 0.001}s"
    return "#{Round n * 0.001, 1}s"

  # hide(n: Slot): void
  hide: (n) ->
    unless Config.get 'skill-timer' then return
    Hud.render n, ''

  # max(list: [number, number]): number
  max: (list) ->
    if list[0] >= list[1] then return list[0]
    return list[1]

  # render(n: Slot, message: string): void
  render: (n, message) ->
    unless Config.get 'skill-timer' then return
    Hud.render n, message

  # renderProgress(n: number, m: number, method = 'round'): string
  renderProgress: (n, m, method = 'round') ->
    listChar = ['◾️', '◽️', '⬛']
    percent = $[method] n * 5 / m
    listResult = []
    for i in [1, 2, 3, 4, 5]
      if percent > i then $.push listResult, listChar[0]
      else if percent == i then $.push listResult, listChar[2]
      else $.push listResult, listChar[1]
    return $.join listResult, ''

  # reset(): void
  reset: -> for n in [1, 2, 3, 4, 5]
    @listCache = [0, 0]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

  # startE(): void
  startE: ->

    {current, name} = Party
    unless name then return

    cd = @listCountDown[current]
    now = $.now()
    if cd and cd - now > 500 then return

    if @listRecord[current] then return
    @listRecord[current] = now

  # switchQ(key: Key): void
  switchQ: (key) ->

    unless Scene.is 'normal' then return

    $.press "alt + #{key}"
    Party.switchTo key

    unless Party.current then return
    @listQ[Party.current] = $.now()

    @cancelCheck()

  # update(): void
  update: ->

    interval = 200
    unless Timer.checkInterval 'skill/throttle', interval then return

    now = $.now()
    for n in [1, 2, 3, 4, 5]
      @updateItem n, now

  # update(n: Slot, now: number): void
  updateItem: (n, now) ->

    unless @listCountDown[n] or @listDuration[n] then return

    if now >= @listCountDown[n] then @listCountDown[n] = 0
    if now >= @listDuration[n] then @listDuration[n] = 0

    listMessage = []

    tagCurrent = ''
    if n == Party.current then tagCurrent = ' 🎮'

    if @listCountDown[n]
      progress = @renderProgress @listCache[n][0] - (@listCountDown[n] - now), @listCache[n][0], 'floor'
      formatted = @format now - @listCountDown[n]
      $.push listMessage, "#{progress} #{formatted}#{tagCurrent}"
    else $.push listMessage, "◾️◾️◾️◾️◾️#{tagCurrent}"

    if @listDuration[n]
      progress = @renderProgress @listDuration[n] - now, @listCache[n][1], 'ceil'
      formatted = @format @listDuration[n] - now
      $.push listMessage, "#{progress} [#{formatted}]"

    unless ($.abs @listCountDown[n]) + @listDuration[n]
      @hide n
      return

    @render n, $.join listMessage, '\n'

  # useE(isHolding: boolean = false): void
  useE: (isHolding = false) ->

    unless Scene.is 'normal' then return

    delay = 50
    if isHolding then delay = 1e3

    $.press 'e:down'
    @startE()

    Timer.add 'skill/use', delay, =>
      $.press 'e:up'
      @endE()

  # useQ(): void
  useQ: ->

    unless Scene.is 'normal' then return

    $.press 'q'

    {current, name} = Party
    unless current then return
    @listQ[current] = $.now()

    if (Character.get name, 'star') == 5
      @cancelCheck()
      Scene.freeze 'normal', '5-star-q', 1500

  # watch(): void
  watch: ->

    interval = 200
    token = 'skill/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @update

# execute
Skill = new Skill()