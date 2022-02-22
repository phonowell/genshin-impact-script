### interface
type Position = 1 | 2 | 3 | 4
type Step = 'end' | 'start'
type Timestamp = number
###

# function

class SkillTimer

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

    Timer.remove 'skill-timer/check'

    {current, name} = Party
    {preswingE, typeE} = Character.data[name]

    if typeE == 1 then return

    delay = preswingE * 1e3 + 400
    interval = 200
    limit = delay + 600

    tsCheck = $.now()
    Timer.add 'skill-timer/check', delay, => Timer.loop 'skill-timer/check', interval, =>

      start = Point.new ['86%', '90%']
      end = Point.new ['90%', '93%']

      if name == 'mona' || name == 'kamisato_ayaka'
        start = Point.new ['81%', '90%']
        end = Point.new ['85%', '93%']

      p = ColorManager.find 0xFFFFFF, start, end
      if Point.isValid p
        Timer.remove 'skill-timer/check'
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove 'skill-timer/check'

      console.log "skill-timer: invalid record of #{name}"

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

  # hide(n: Position): void
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

    now = $.now()

    if (name == 'tartaglia') and @endTartaglia() then return

    countdown = @listCountDown[current]
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

  # render(n: Position, message: string): void
  render: (n, message) ->
    unless Config.data.skillTimer then return
    Hud.render n, message

  # reset(): void
  reset: -> for n in [1, 2, 3, 4, 5]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

  # update(): void
  update: ->

    interval = 200
    if Scene.name != 'normal' then interval = 1e3
    unless Timer.checkInterval 'skill-timer/throttle', interval then return

    now = $.now()
    for n in [1, 2, 3, 4, 5]
      @updateItem n, now

  # update(n: Position, now: number): void
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

  # watch(): void
  watch: ->
    interval = 200
    Client.on 'pause', -> Timer.remove 'skill-timer/watch'
    Client.on 'resume', => Timer.loop 'skill-timer/watch', interval, @update
    Timer.loop 'skill-timer/watch', interval, @update

# execute
SkillTimer = new SkillTimer()