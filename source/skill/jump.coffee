state.isJumping = false
timer.jump = ''

jump = ->
  $.press 'space'
  $.delay 75, -> $.press 'space'

startJump = ->

  if state.isJumping then return
  state.isJumping = true

  clearInterval timer.jump
  timer.jump = setInterval jump, 150

  jump()

stopJump = ->

  unless state.isJumping then return
  state.isJumping = false

  clearInterval timer.jump