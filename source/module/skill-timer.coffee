class SkillTimerX

  current: 0
  listCountDown: {}
  listRecord: {}
  member: {}

  check: ->

    if client.state.isSuspend
      hud.hide()
      return

    now = $.now()

    for n in [1, 2, 3, 4]

      name = @member[n]

      if name == '?'
        continue

      unless @listCountDown[n]
        continue

      if now >= @listCountDown[n]
        @listCountDown[n] = 0
        hud.render n, 'OK'
      else
        diff = Math.floor (now - @listCountDown[n]) * 0.001
        hud.render n, "#{diff}s"

  record: (step) ->

    n = @current
    name = @member[n]

    if name == '?'
      return

    if @listCountDown[n]
      return

    now = $.now()
    char = Character[name]

    if step == 'start'
      @listRecord[n] = now
      return

    if step == 'end'

      diff = now - @listRecord[n]

      if diff <= 200
        @listCountDown[n] = now + (char.cd[0] * 1e3)
      else @listCountDown[n] = now + (char.cd[1] * 1e3)
      return

  toggle: (n) -> @current = n