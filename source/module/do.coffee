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
