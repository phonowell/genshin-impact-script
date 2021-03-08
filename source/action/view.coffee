state.isViewing = false
timer.view = ''

# function

toggleView = ->

  $.clearInterval timer.view
  state.isViewing = !state.isViewing

  unless state.isViewing
    return

  timer.view = $.setInterval view, 3e3
  view()

view = ->
  $.click 'middle:down'
  $.delay 2500, -> $.click 'middle:up'

# execute

if Config.data.betterElementalVision
  player.on 'view:end', toggleView