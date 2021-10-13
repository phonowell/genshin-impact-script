### interface
type Position = 1 | 2 | 3 | 4
type Step = 'end' | 'start'
type Timestamp = number
###

# function

class SkillTimerX

  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}
  tsUpdate: 0

  # ---

  constructor: ->
    Client.on 'tick', @update
    @reset()

  # check(): void
  check: ->

    if Config.data.weakNetwork then return

    Client.delay 'skill-timer'

    {current, name} = Party
    {typeE} = Character.data[name]

    if typeE == 1 then return

    Client.delay 'skill-timer', 500, =>

      start = Client.point [86, 90]
      end = Client.point [90, 93]

      if name == 'mona' || name == 'kamisato_ayaka'
        start = Client.point [81, 90]
        end = Client.point [85, 93]

      [x, y] = $.findColor 0xFFFFFF, start, end
      if x * y > 0 then return

      console.log 'skill-timer: invalid record'

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

    if (name == 'tartaglia') and @endTartaglia()
      return

    countdown = @listCountDown[current]
    if countdown and countdown - now > 1e3
      return

    if step == 'end'
      @recordEnd now
      return

    if step == 'start'
      @recordStart now
      return

  # recordEnd(now: Timestamp): void
  recordEnd: (now) ->

    {current, name} = Party
    {cdE, durationE, typeE} = Character.data[name]

    unless @listRecord[current] then return

    if now - @listRecord[current] < 500 # tap
      @listCountDown[current] = @listRecord[current] + (cdE[0] * 1e3) + 500
      if durationE[0]
        @listDuration[current] = @listRecord[current] + (durationE[0] * 1e3)
      @listRecord[current] = 0
      @check()
      return

    # hold

    if typeE == 1
      @listCountDown[current] = now + (cdE[1] * 1e3) + 500
      if durationE[1]
        @listDuration[current] = now + (durationE[1] * 1e3)
    else
      @listCountDown[current] = @listRecord[current] + (cdE[1] * 1e3) + 500
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
  reset: -> for n in [1, 2, 3, 4]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

  # update(): void
  update: ->

    interval = 200
    if Scene.name != 'normal' then interval = 1e3

    now = $.now()
    unless now - @tsUpdate >= interval then return
    @tsUpdate = now

    for n in [1, 2, 3, 4]
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

# execute
SkillTimer = new SkillTimerX()