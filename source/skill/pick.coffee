state.isPicking = false
timer.pick = ''

pick = ->
  $.press 'f'
  $.click 'wheel-down'

startPick = ->

  if state.isPicking then return
  state.isPicking = true

  clearInterval timer.pick
  timer.pick = setInterval pick, 100
  
  pick()

stopPick = ->

  unless state.isPicking then return
  state.isPicking = false

  clearInterval timer.pick