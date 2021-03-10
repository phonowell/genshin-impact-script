tactic.hu_tao = ->

  unless tactic.isActive
    return

  if skillTimer.listCountDown[member.current] - $.now() < 7e3
    tactic.normalAttack tactic.hu_tao
    return

  taoChargedAttack()

taoChargedAttack = ->
  tactic.chargedAttack -> tactic.delay 50, ->
    tactic.jump -> tactic.delay 100, tactic.hu_tao