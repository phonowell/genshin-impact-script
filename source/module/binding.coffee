bind = ->

  for key in ['1', '2', '3', '4', '5']
    $.on key, (key = key) -> toggle key

  $.on 'e', -> $.press 'e:down'
  $.on 'e:up', ->
    $.press 'e:up'
    countDown 5e3

  $.on 'f', ->
    doAs (n) ->
      $.press 'f'
      unless n >= 10
        $.click 'wheel-down:down'
      else $.click 'wheel-down:up'
    , 10

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