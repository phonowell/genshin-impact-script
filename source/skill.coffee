### interface
type Slot = 1 | 2 | 3 | 4 | 5
type Step = 'end' | 'start'
type Timestamp = number
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
    {preswingE, typeE} = Character.get name

    if typeE == 1 then return

    delay = preswingE * 1e3 + 400
    interval = 100
    limit = delay + 600

    tsCheck = $.now()
    Timer.add token, delay, => Timer.loop token, interval, =>

      start = Point.new ['86%', '90%']
      end = Point.new ['90%', '93%']

      if name == 'mona' || name == 'kamisato_ayaka'
        start = Point.new ['81%', '90%']
        end = Point.new ['85%', '93%']

      p = ColorManager.find 0xFFFFFF, start, end
      if Point.isValid p
        Timer.remove token
        console.log "#{token}: #{name} passed"
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

      console.log "#{token}: #{name} failed"

      @listCountDown[current] = 1
      @listDuration[current] = 1

  # correctCD(cd: number): number
  correctCD: (cd) ->
    unless Party.hasBuff 'impetuous winds' then return cd
    return cd * 0.95

  # endTartaglia(): boolean
  endTartaglia: ->

    n = Party.getIndexBy 'tartaglia'

    unless @listDuration[n] then return false

    now = $.now()

    @listCountDown[n] = now + 30e3 - (@listDuration[n] - now) + 6e3
    @listDuration[n] = 0

    return true

  # format(n: number): string
  format: (n) ->
    if ($.abs n) > 1e3 then return "#{$.floor n * 0.001}s"
    return "#{Round n * 0.001, 1}s"

  # hide(n: Slot): void
  hide: (n) ->
    unless Config.get 'skill-timer' then return
    Hud.render n, ''

  # record(step: Step): void
  record: (step) ->

    {current, name} = Party
    unless name then return
    if (name == 'tartaglia') and @endTartaglia() then return

    countdown = @listCountDown[current]
    now = $.now()
    if countdown and countdown - now > 1e3 then return

    if step == 'end'
      @recordEnd now
      return

    if step == 'start'
      @recordStart now
      return

  # recordEnd(now: Timestamp): void
  recordEnd: (now) ->

    {current, name} = Party
    {cdE, durationE, preswingE, typeE} = Character.get name

    unless @listRecord[current] then return

    correction = preswingE * 1e3

    # tap
    if now - @listRecord[current] < 500
      @listCountDown[current] = @listRecord[current] + @correctCD (cdE[0] * 1e3) + correction
      if durationE[0]
        @listDuration[current] = @listRecord[current] + (durationE[0] * 1e3)
      @listCache[current] = [(@correctCD cdE[0]), durationE[0]]
      @listRecord[current] = 0
      @check()
      return

    # hold

    if typeE == 1
      @listCountDown[current] = now + @correctCD (cdE[1] * 1e3) + correction
      if durationE[1]
        @listDuration[current] = now + (durationE[1] * 1e3)
    else
      @listCountDown[current] = @listRecord[current] + @correctCD (cdE[1] * 1e3) + correction
      if durationE[1]
        @listDuration[current] = @listRecord[current] + (durationE[1] * 1e3)

    @listCache[current] = [(@correctCD cdE[1]), durationE[1]]
    @listRecord[current] = 0
    @check()

  # recordStart(now: Timestamp): void
  recordStart: (now) ->
    {current} = Party
    if @listRecord[current] then return
    @listRecord[current] = now

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

    if @listCountDown[n]
      progress = @renderProgress @listCache[n][0] - (@listCountDown[n] - now) * 0.001, @listCache[n][0], 'floor'
      formatted = @format now - @listCountDown[n]
      $.push listMessage, "#{progress} #{formatted}"
    else $.push listMessage, '◾️◾️◾️◾️◾️'

    if @listDuration[n]
      progress = @renderProgress (@listDuration[n] - now) * 0.001, @listCache[n][1], 'ceil'
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
    @record 'start'
    Timer.add 'skill/use', delay, =>
      $.press 'e:up'
      @record 'end'

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

    Client.on 'leave', -> Timer.remove token
    Client.on 'enter', => Timer.loop token, interval, @update

# execute
Skill = new Skill()