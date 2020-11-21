timer.countDown = ''

countDown = (time) ->
  clearTimeout timer.countDown
  timer.countDown = $.delay time, $.beep