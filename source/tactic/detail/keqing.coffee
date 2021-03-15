tactic.backend.keqing = (callback) ->
  $$.vt 'tactic.backend.keqing', callback, 'function'
  player.useE()
  tactic.delay 700, ->
    $.press 'e'
    tactic.delay 300, callback