state.isViewing = false
timer.view = ''

toggleView = ->

  clearInterval timer.view
  state.isViewing = !state.isViewing

  # reset key
  $.click 'middle:up'

  unless state.isViewing
    return

  timer.view = setInterval view, 3e3
  view()

view = ->

  $.click 'middle:down'

  setTimeout ->
    $.click 'middle:up'
  , 2500