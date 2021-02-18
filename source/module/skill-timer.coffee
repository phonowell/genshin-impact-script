class SkillTimerX

  listCountDown: {}
  listRecord: {}

  # ---

  check: ->

    if client.isSuspend
      return

    now = $.now()

    for n in [1, 2, 3, 4]

      unless @listCountDown[n]
        continue

      if now >= @listCountDown[n]
        @listCountDown[n] = 0
        hud.render n, ''
      else
        diff = Math.floor (now - @listCountDown[n]) * 0.001
        hud.render n, "#{diff}s"

  record: (step) ->

    n = member.current
    name = member.name

    unless name
      return

    if @listCountDown[n]
      return

    now = $.now()

    if step == 'end'
      @recordEnd now
      return

    if step == 'start'
      @recordStart now
      return

  recordEnd: (now) ->

    n = member.current
    name = member.name
    {cd, typeE} = Character[name]

    unless @listRecord[n]
      return

    diff = now - @listRecord[n]

    if diff < 500 # short press
      @listCountDown[n] = @listRecord[n] + (cd[0] * 1e3)
      @listRecord[n] = 0
      return

    # long press

    if typeE == 1
      @listCountDown[n] = now + (cd[1] * 1e3)
    else @listCountDown[n] = @listRecord[n] + (cd[1] * 1e3)

    @listRecord[n] = 0

  recordStart: (now) ->

    n = member.current
    name = member.name
    {cd} = Character[name]

    if @listRecord[n]
      return

    @listRecord[n] = now

  reset: ->
    @listCountDown = {}
    @listRecord = {}

# execute

skillTimer = new SkillTimerX()

if Config.data.easySkillTimer
  ticker.on 'change', (tick) ->
    if Mod tick, 200
      return
    skillTimer.check()