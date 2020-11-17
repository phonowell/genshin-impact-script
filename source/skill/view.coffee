isViewing = false
timerView = ''

toggleView = ->

  clearInterval timerView
  isViewing = !isViewing

  # reset key
  $.click 'middle:up'

  unless isViewing
    return

  timerView = setInterval view, 3e3
  view()

view = ->

  $.click 'middle:down'

  setTimeout ->
    $.click 'middle:up'
  , 2500