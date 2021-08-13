timer.checkFromSkillTimer = 0

# function

class SkillTimerX

  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}

  constructor: ->
    client.on 'tick', @update
    @reset()

  check: ->

    $.clearTimeout timer.checkFromSkillTimer

    {current, name} = party
    {typeE} = Character.data[name]

    if typeE == 1 then return

    timer.checkFromSkillTimer = $.setTimeout =>

      start = client.point [86, 90]
      end = client.point [90, 93]

      if name == 'mona' || name == 'kamisato'
        start = client.point [81, 90]
        end = client.point [85, 93]

      [x, y] = $.findColor 0xFFFFFF, start, end
      if x * y > 0 then return

      console.log 'skill-timer: invalid record'

      @listCountDown[current] = 1
      @listDuration[current] = 1

    , 500

  endTartaglia: ->

    n = party.getIndexBy 'tartaglia'

    unless @listDuration[n] then return false

    now = $.now()

    @listCountDown[n] = now + 30e3 - (@listDuration[n] - now) + 6e3
    @listDuration[n] = 0

    return true

  hide: (n) ->
    unless Config.data.skillTimer then return
    hud.render n, ''

  makeDiff: (n) ->
    if ($.abs n) > 1e3 then return "#{$.floor n * 0.001}s"
    return "#{Round n * 0.001, 1}s"

  record: (step) ->

    {current, name} = party

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

  recordEnd: (now) ->

    {current, name} = party
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

  recordStart: (now) ->

    {current, name} = party
    {cdE} = Character.data[name]

    if @listRecord[current]
      return

    @listRecord[current] = now

  render: (n, message) ->
    unless Config.data.skillTimer then return
    hud.render n, message

  reset: -> for n in [1, 2, 3, 4]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

  update: ->

    now = $.now()

    for n in [1, 2, 3, 4]

      unless @listCountDown[n] or @listDuration[n]
        continue

      if now >= @listCountDown[n]
        @listCountDown[n] = 0

      if now >= @listDuration[n]
        @listDuration[n] = 0

      listMessage = []

      if @listCountDown[n]
        $.push listMessage, @makeDiff now - @listCountDown[n]

      if @listDuration[n]
        $.push listMessage, "[#{@makeDiff @listDuration[n] - now}]"

      unless $.length listMessage
        @hide n
        return

      if n == party.current
        $.push listMessage, '💬'

      @render n, $.join listMessage, ' '

# execute

skillTimer = new SkillTimerX()