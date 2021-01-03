state.isToggleDown = false
state.toggleDelay = 100
timer.toggleDown = ''
timer.toggleUp = ''

getToggleDelay = ->
  delay = 600 - ($.now() - ts.dash)
  if delay < 200
    delay = 200
  return delay

startToggle = (key) ->

  # default
  $.press "#{key}:down"
  unless config.data.autoESkill
    return

  # extended

  if state.isToggleDown
    return
  state.isToggleDown = true

  state.toggleDelay = getToggleDelay()

  timer.toggleDown = $.delay state.toggleDelay, ->
    $.press 'e:down'

stopToggle = (key) ->

  # default
  $.press "#{key}:up"
  unless config.data.autoESkill
    return

  # extend

  timer.toggleUp = $.delay state.toggleDelay, ->
    state.isToggleDown = false
    $.press 'e:up'