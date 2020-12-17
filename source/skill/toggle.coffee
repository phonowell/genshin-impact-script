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

  # `BlockInput, On`
  # pauseMove()

  delay = 100
  if $.now() - ts.dash < 500
    delay = 500

  clearTimeout timer.toggle
  timer.toggle = $.delay delay, (key = key) ->

    # resumeMove()
    # `BlockInput, Off`

    if $.getState key
      state.isLongPressing = true
      $.press 'e:down'
    else
      $.press 'e'
      countDown 5e3

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