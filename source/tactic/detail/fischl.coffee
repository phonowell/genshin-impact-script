tactic.fischl = ->

  unless tactic.isActive
    return

  unless tactic.isFrozen

    unless skillTimer.listCountDown[player.current]
      player.useE()
      tactic.freeze 1e3
      tactic.count = 0
      tactic.delay 400, tactic.fischl
      return

  if tactic.count > 4
    tactic.count = 0

  switch tactic.count
    when 0, 1, 2, 3 then tactic.normalAttack tactic.fischl
    when 4 then fischlAim()

  tactic.count++

fischlAim = ->
  $.press 'r'
  tactic.delay 100, ->
    $.press 'r'
    tactic.delay 100, tactic.fischl