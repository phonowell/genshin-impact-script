state.isPicking = false
timer.pick = ''

pick = ->

  $.press 'f'
  $.click 'wheel-down'

  clearTimeout timer.pick
  timer.pick = $.delay 100, ->

    unless state.isPicking then return
    pick()

startPick = ->

  if state.isPicking then return
  state.isPicking = true

  pick()

stopPick = -> state.isPicking = false