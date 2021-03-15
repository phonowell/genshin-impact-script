tactic.rezor = ->

  unless tactic.isActive
    return

  if $.now() - skillTimer.listQ[player.current] < 15e3
    tactic.normalAttack tactic.rezor
    return

  unless tactic.isFrozen

    unless skillTimer.listCountDown[player.current]
      player.useE()
      tactic.freeze 1e3
      tactic.delay 100, tactic.rezor
      return

  tactic.normalAttack tactic.rezor