state.isJumping = false
timer.jump = ''

jump = ->

  if state.isJumping then return
  state.isJumping = true

  jumpTwice -> state.isJumping = false

jumpTwice = (callback) ->

  $.press 'space'

  clearTimeout timer.jump
  timer.jump = $.delay 200, (callback = callback) ->

    unless isMoving()
      callback()
      return

    $.press 'space'

    clearTimeout timer.jump
    timer.jump = $.delay 100, (callback = callback) ->

      $.press 'space'
      callback()