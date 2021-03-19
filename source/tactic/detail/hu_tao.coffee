tactic.hu_tao = ->

  unless tactic.isActive
    return

  if skillTimer.listDuration[player.current]
    taoChargedAttack()
    return

  unless tactic.isFrozen

    unless skillTimer.listCountDown[player.current]
      player.useE()
      tactic.freeze 1e3
      tactic.delay 400, tactic.hu_tao
      return

  tactic.normalAttack tactic.hu_tao

taoChargedAttack = ->
  tactic.chargedAttack -> tactic.delay 100, ->
    tactic.jump -> tactic.delay 100, tactic.hu_tao