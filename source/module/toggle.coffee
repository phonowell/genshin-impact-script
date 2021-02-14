state.isToggleDown = false
state.toggleDelay = 100
timer.toggleDown = ''
timer.toggleUp = ''

# function

getToggleDelay = ->
  delay = 500 - ($.now() - ts.sprint)
  if delay < 200
    delay = 200
  return delay

startToggle = (key) ->

  member.toggle key

  unless config.data.autoESkill
    return

  if state.isToggleDown
    return
  state.isToggleDown = true

  state.toggleDelay = getToggleDelay()

  timer.toggleDown = $.delay state.toggleDelay, ->
    $.press 'e:down'
    skillTimer.record 'start'

stopToggle = (key) ->

  unless config.data.autoESkill
    return

  timer.toggleUp = $.delay state.toggleDelay, ->
    state.isToggleDown = false
    $.press 'e:up'
    skillTimer.record 'end'

# binding

player
  .on 'toggle-start', startToggle
  .on 'toggle-end', stopToggle

for key in [1, 2, 3, 4]
  $.on "alt + #{key}", ->
    $.press "alt + #{key}"
    member.toggle key