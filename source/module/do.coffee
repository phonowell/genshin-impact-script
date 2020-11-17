$dataDoAs =
  count: 0
  fn: ''
  interval: 0
  limit: 1

doAs = (fn = '', interval = 100, limit = 1, delay = 0) ->

  if fn
    $dataDoAs.count = 0
    $dataDoAs.fn = fn
    $dataDoAs.interval = interval
    $dataDoAs.limit = limit

  if delay
    setTimeout doAs, delay
    return

  if $dataDoAs.count >= $dataDoAs.limit
    return

  $dataDoAs.count++
  $dataDoAs.fn $dataDoAs

  setTimeout ->
    doAs()
  , $dataDoAs.interval
