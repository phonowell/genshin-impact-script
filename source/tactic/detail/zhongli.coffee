tactic.zhongli = ->

  unless tactic.isActive
    return

  unless skillTimer.listCountDown[player.current]
    player.useE 'holding'
    tactic.delay 100, tactic.zhongli
    return

  tactic.normalAttack tactic.zhongli