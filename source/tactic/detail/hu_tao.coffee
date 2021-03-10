tactic.hu_tao = ->

  unless tactic.isActive
    return

  if tactic.count > 1
    tactic.count = 0

  switch tactic.count
    when 0 then tactic.normalAttack tactic.hu_tao
    when 1 then taoChargedAttack()

  tactic.count++

taoChargedAttack = ->

  tactic.chargedAttack ->

    tactic.delay 300, ->

      tactic.jump tactic.hu_tao
