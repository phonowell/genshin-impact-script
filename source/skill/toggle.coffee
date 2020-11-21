tsToggle = 0

toggle = (key) ->

  unless $.now() - tsToggle > 1e3
    $.beep()
    return
  tsToggle = $.now()

  $.press key

  doAs ->
    $.press 'e'
  , 2, 100, 100

  countDown 5e3