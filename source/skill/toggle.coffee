state.isLongPressing = false
timer.toggle = ''
ts.toggle = 0

startToggle = (key) ->

  unless $.now() - ts.toggle >= 500
    return
  ts.toggle = $.now()

  $.press key

  clearTimeout timer.toggle
  timer.toggle = $.delay 100, (key = key) ->

    if $.getState key
      state.isLongPressing = true
      $.press 'e:down'
    else
      $.press 'e'
      countDown 5e3

stopToggle = ->

  unless state.isLongPressing
    return
  state.isLongPressing = false

  $.press 'e:up'
  countDown 10e3