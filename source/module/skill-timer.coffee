class SkillTimerX

  listCountDown: {}
  listDuration: {}
  listRecord: {}

  constructor: -> member.on 'change', @reset

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

  # checkSkillStatus: ->

  #   {current, name} = player

  #   unless name
  #     return

  #   if @listRecord[current]
  #     return

  #   unless @listCountDown[current]
  #     return

  #   start = client.point [87, 88]
  #   end = client.point [88, 93]

  #   [x, y] = $.findColor 0xFFFFFF, start, end

  #   if x * y > 0
  #     return

  #   @hide player.current

  hide: (n) ->
    unless Config.data.easySkillTimer
      return
    hud.render n, ''

  record: (step) ->

    {current, name} = player

    unless name
      return

    now = $.now()

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
    {cd, duration, typeE} = Character.data[name]

    unless @listRecord[current]
      return

    if now - @listRecord[current] < 500 # tap
      @listCountDown[current] = @listRecord[current] + (cd[0] * 1e3) + 500
      if duration[0]
        @listDuration[current] = @listRecord[current] + (duration[0] * 1e3)
      @listRecord[current] = 0
      return

    # hold

    if typeE == 1
      @listCountDown[current] = now + (cd[1] * 1e3) + 500
      if duration[1]
        @listDuration[current] = now + (duration[1] * 1e3)
    else
      @listCountDown[current] = @listRecord[current] + (cd[1] * 1e3) + 500
      if duration[1]
        @listDuration[current] = @listRecord[current] + (duration[1] * 1e3)

    @listRecord[current] = 0

  recordStart: (now) ->

    {current, name} = player
    {cd} = Character.data[name]

    if @listRecord[current]
      return

    @listRecord[current] = now

  render: (n, message) ->
    unless Config.data.easySkillTimer
      return
    hud.render n, message

  reset: ->
    @listCountDown = {}
    @listRecord = {}

# execute

skillTimer = new SkillTimerX()

ticker.on 'change', (tick) ->

  unless $.mod tick, 200
    skillTimer.check()

  # unless $.mod tick, 1e3
  #   skillTimer.checkSkillStatus()