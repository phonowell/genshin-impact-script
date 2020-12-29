state.isLongPressing = false
state.isToggleLocked = false
timer.toggle = ''

getToggleDelay = ->

  limit = [200, 600]
  delay = limit[0]
  diff = $.now() - ts.dash
  if diff > limit[0] and diff < limit[1]
    delay = limit[1] - diff
  return delay

startToggle = (key) ->

  # default
  $.press "#{key}:down"
  unless config.data.autoESkill
    return

  # extended

  if state.isToggleLocked
    return
  state.isToggleLocked = true

  pauseMove()

  clearTimeout timer.toggle
  timer.toggle = $.delay getToggleDelay(), (key = key) ->

    if $.getState key
      state.isLongPressing = true
      $.press 'e:down'
    else $.press 'e'

    resumeMove()

stopToggle = (key) ->

  # default
  $.press "#{key}:up"
  unless config.data.autoESkill
    return

  # extend

  state.isToggleLocked = false

  if state.isLongPressing
    $.press 'e:up'
    coundDown 10e3
  else coundDown 5e3

  state.isLongPressing = false