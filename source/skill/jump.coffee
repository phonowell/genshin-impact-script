isJumping = false
timerJump = ''

jumpTwice = ->

  $.press 'space'

  doAs ->
    $.press 'space'
  , 2, 100, 200

startJumpBack = ->

  if isJumping then return
  isJumping = true

  timerJump = setTimeout jumpTwice, 100

stopJumpBack = ->

  unless isJumping then return
  isJumping = false

  clearTimeout timerJump