timer.jump = ''

jumpTwice = ->

  $.press 'space'

  clearTimeout timer.jump
  timer.jump = $.delay 200, ->

    $.press 'space'

    clearTimeout timer.jump
    timer.jump = $.delay 50, -> $.press 'space'