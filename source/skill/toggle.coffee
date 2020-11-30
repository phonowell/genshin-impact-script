ts.toggle = 0

toggle = (key) ->

  $.press key

  unless $.now() - ts.toggle > 1e3
    $.beep()
    return
  ts.toggle = $.now()

  doAs ->
    $.press 'e'
  , 2, 100, 100

  countDown 5e3