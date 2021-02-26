state.isViewing = false
timer.view = ''

# function

toggleView = ->

  clearInterval timer.view
  state.isViewing = !state.isViewing

  unless state.isViewing
    return

  timer.view = setInterval view, 3e3
  view()

view = ->

  $.click 'middle:down'

  setTimeout ->
    $.click 'middle:up'
  , 2500

# execute

if Config.data.betterElementalVision
  player.on 'view:end', toggleView