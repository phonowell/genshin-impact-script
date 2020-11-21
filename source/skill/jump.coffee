isJumping = false
timer.jump = ''

jumpTwice = ->

  $.press 'space'

  doAs ->
    $.press 'space'
  , 2, 100, 200

startJumpBack = ->

  if isJumping then return
  isJumping = true

  timer.jump = setTimeout jumpTwice, 100

stopJumpBack = ->

  unless isJumping then return
  isJumping = false

  clearTimeout timer.jump