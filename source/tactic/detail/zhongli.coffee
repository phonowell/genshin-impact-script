tactic.zhongli = ->

  unless tactic.isActive
    return

  if tactic.useBackend tactic.zhongli
    return

  unless tactic.isFrozen

    unless skillTimer.listCountDown[player.current]
      player.useE 'holding'
      tactic.freeze 2e3
      tactic.delay 100, tactic.zhongli
      return

  tactic.normalAttack tactic.zhongli