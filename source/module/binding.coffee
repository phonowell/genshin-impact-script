bind = ->

  for key in ['1', '2', '3', '4', '5']
    $.on key, (key = key) -> toggle key

  $.on 'e', -> $.press 'e:down'
  $.on 'e:up', ->
    $.press 'e:up'
    clearTimeout timer
    timer = setTimeout $.beep, 5e3

  $.on 'f', ->
    doAs (e) ->
      $.press 'f'
      unless e.count >= 10
        $.click 'wheel-down:down'
      else $.click 'wheel-down:up'
    , 100, 10

  $.on 'mbutton', toggleView

  $.on 'rbutton', startDash
  $.on 'rbutton:up', stopDash

  $.on 's', ->
    $.press 's:down'
    startJumpBack()

  $.on 's:up', ->
    $.press 's:up'
    stopJumpBack()

  $.on 'space', jumpTwice