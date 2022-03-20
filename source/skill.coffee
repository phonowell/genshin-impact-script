### interface
type Slot = 1 | 2 | 3 | 4 | 5
type Step = 'end' | 'start'
type Timestamp = number
###

# function

class Skill

  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}

  # ---

  constructor: ->
    @reset()
    @watch()

  # check(): void
  check: ->

    token = 'skill/check'
    Timer.remove token

    {current, name} = Party
    {preswingE, typeE} = Character.data[name]

    if typeE == 1 then return

    delay = preswingE * 1e3 + 400
    interval = 200
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
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

      console.log "skill: invalid record of #{name}"

      @listCountDown[current] = 1
      @listDuration[current] = 1

  # endTartaglia(): boolean
  endTartaglia: ->

    n = Party.getIndexBy 'tartaglia'

    unless @listDuration[n] then return false

    now = $.now()

    @listCountDown[n] = now + 30e3 - (@listDuration[n] - now) + 6e3
    @listDuration[n] = 0

    return true

  # hide(n: Slot): void
  hide: (n) ->
    unless Config.data.skillTimer then return
    Hud.render n, ''

  # makeDiff(n: number): string
  makeDiff: (n) ->
    if ($.abs n) > 1e3 then return "#{$.floor n * 0.001}s"
    return "#{Round n * 0.001, 1}s"

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
    {cdE, durationE, preswingE, typeE} = Character.data[name]

    unless @listRecord[current] then return

    correction = preswingE * 1e3

    # tap
    if now - @listRecord[current] < 500
      @listCountDown[current] = @listRecord[current] + (cdE[0] * 1e3) + correction
      if durationE[0]
        @listDuration[current] = @listRecord[current] + (durationE[0] * 1e3)
      @listRecord[current] = 0
      @check()
      return

    # hold

    if typeE == 1
      @listCountDown[current] = now + (cdE[1] * 1e3) + correction
      if durationE[1]
        @listDuration[current] = now + (durationE[1] * 1e3)
    else
      @listCountDown[current] = @listRecord[current] + (cdE[1] * 1e3) + correction
      if durationE[1]
        @listDuration[current] = @listRecord[current] + (durationE[1] * 1e3)

    @listRecord[current] = 0
    @check()

  # recordStart(now: Timestamp): void
  recordStart: (now) ->

    {current, name} = Party
    {cdE} = Character.data[name]

    if @listRecord[current]
      return

    @listRecord[current] = now

  # render(n: Slot, message: string): void
  render: (n, message) ->
    unless Config.data.skillTimer then return
    Hud.render n, message

  # reset(): void
  reset: -> for n in [1, 2, 3, 4, 5]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

  # switchQ(key: Key): void
  switchQ: (key) ->

    unless Scene.name == 'normal' then return

    $.press "alt + #{key}"
    Party.switchTo key

    unless Party.current then return
    @listQ[Party.current] = $.now()

    Scene.freeze 'unknown/unknown', 200

  # update(): void
  update: ->

    interval = 200
    if Scene.name != 'normal' then interval = 1e3
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

    if @listCountDown[n] then $.push listMessage, @makeDiff now - @listCountDown[n]
    if @listDuration[n] then $.push listMessage, "[#{@makeDiff @listDuration[n] - now}]"

    unless $.length listMessage
      @hide n
      return

    if n == Party.current then $.push listMessage, '💬'

    @render n, $.join listMessage, ' '

  # useE(isHolding: boolean = false): void
  useE: (isHolding = false) ->

    unless Scene.name == 'normal' then return

    delay = 50
    if isHolding then delay = 1e3

    $.press 'e:down'
    @record 'start'
    Timer.add 'skill/use', delay, =>
      $.press 'e:up'
      @record 'end'

  # useQ(): void
  useQ: ->

    unless Scene.name == 'normal' then return

    $.press 'q'

    unless Party.current then return
    @listQ[Party.current] = $.now()

  # watch(): void
  watch: ->
    interval = 200
    token = 'skill/watch'
    Client.on 'leave', -> Timer.remove token
    Client.on 'enter', => Timer.loop token, interval, @update
    Timer.loop token, interval, @update

# execute
Skill = new Skill()