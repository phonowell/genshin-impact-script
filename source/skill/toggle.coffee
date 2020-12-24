state.character = 0
state.isLongPressing = false
state.isToggleLocked = false
timer.toggle = ''

startToggle = (key) ->

  $.press "#{key}:down"

  state.character = key

  unless config.data.autoESkill
    return

  if state.isToggleLocked
    return
  state.isToggleLocked = true

  limit = [150, 600]
  delay = limit[0]
  diff = $.now() - ts.dash
  if diff > limit[0] and diff < limit[1]
    delay = limit[1] - diff

  clearTimeout timer.toggle
  timer.toggle = $.delay delay, (key = key) ->

    $.blockInput true
    pauseMove()
    client.resetKey()

    if $.getState key
      state.isLongPressing = true
      $.press 'e:down'
    else
      $.press 'e'
      countDown 5e3

    resumeMove()
    $.blockInput false

stopToggle = (key) ->

  $.press "#{key}:up"

  unless config.data.autoESkill
    return

  state.isToggleLocked = false

  unless state.isLongPressing
    return
  state.isLongPressing = false

  $.press 'e:up'
  countDown 10e3