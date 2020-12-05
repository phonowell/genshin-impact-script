state.isJumping = false
timer.jump = ''

jumpTwice = ->

  $.press 'space'

  doAs ->
    $.press 'space'
  , 2, 100, 200

startJumpBack = ->

  if state.isJumping then return
  state.isJumping = true

  timer.jump = $.delay 100, jumpTwice

stopJumpBack = ->

  unless state.isJumping then return
  state.isJumping = false

  clearTimeout timer.jump