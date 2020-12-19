state.isJumping = false
timer.jump = ''

jump = ->
  $.press 'space'
  $.delay 50, -> $.press 'space'

startJump = ->

  if state.isJumping then return
  state.isJumping = true

  clearInterval timer.jump
  timer.jump = setInterval jump, 100

  jump()

stopJump = ->

  unless state.isJumping then return
  state.isJumping = false

  clearInterval timer.jump