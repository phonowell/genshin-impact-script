doAs = (callback, limit = 1, interval = 100, delay = 0) ->

  if delay
    $.delay delay, (
      callback = callback
      limit = limit
      interval = interval
    ) -> doAs callback, limit, interval, 0
    return

  n = 1
  while n <= limit
    $.delay (n - 1) * interval, (
      n = n
      callback = callback
    ) -> callback n
    n++

isMoving = ->
  for key in ['w', 'a', 's', 'd']
    if $.getState key
      return key
  return false

resetAll = ->

  client.setPriority 'normal'

  for _timer of timer
    clearTimeout _timer

  $.delay 200, ->

    for key in ['middle', 'right']
      if $.getState key
        $.click "#{key}:up"

    for key in ['e', 'f', 's', 'space', 'w', 'x']
      if $.getState key
        $.press "#{key}:up"