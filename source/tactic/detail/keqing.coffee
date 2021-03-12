tactic.backend.keqing = (callback) ->
  player.useE()
  tactic.delay 700, ->
    $.press 'e'
    tactic.delay 300, callback