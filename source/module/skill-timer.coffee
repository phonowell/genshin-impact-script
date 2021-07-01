class SkillTimerX

  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}

  constructor: ->
    @reset()
    member.on 'change', @reset

  check: ->

    if client.isSuspend
      return

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
        diff = $.floor (now - @listCountDown[n]) * 0.001
        $.push listMessage, "#{diff}s"

      if @listDuration[n]
        diff = $.abs $.floor (now - @listDuration[n]) * 0.001
        $.push listMessage, "[#{diff}s]"

      unless $.length listMessage
        @hide n
        return

      @render n, $.join listMessage, ' '

  endTartaglia: ->

    n = member.getIndexBy 'tartaglia'

    unless @listDuration[n]
      return false

    now = $.now()

    @listCountDown[n] = now + 30e3 - (@listDuration[n] - now) + 6e3
    @listDuration[n] = 0

    return true

  hide: (n) ->
    unless Config.data.easySkillTimer
      return
    hud.render n, ''

  record: (step) ->

    {current, name} = player

    unless name
      return

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

    {current, name} = player
    {cdE, durationE, typeE} = Character.data[name]

    unless @listRecord[current]
      return

    if now - @listRecord[current] < 500 # tap
      @listCountDown[current] = @listRecord[current] + (cdE[0] * 1e3) + 500
      if durationE[0]
        @listDuration[current] = @listRecord[current] + (durationE[0] * 1e3)
      @listRecord[current] = 0
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

  recordStart: (now) ->

    {current, name} = player
    {cdE} = Character.data[name]

    if @listRecord[current]
      return

    @listRecord[current] = now

  render: (n, message) ->
    unless Config.data.easySkillTimer
      return
    hud.render n, message

  reset: -> for n in [1, 2, 3, 4]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

# execute

skillTimer = new SkillTimerX()

client.on 'tick', (tick) ->
  unless $.mod tick, 200
    skillTimer.check()