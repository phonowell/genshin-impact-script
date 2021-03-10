tactic.klee = ->

  unless tactic.isActive
    return

  if tactic.count > 1
    tactic.count = 0

  switch tactic.count
    when 0 then tactic.normalAttack tactic.klee
    when 1 then kleeChargedAttack()

  tactic.count++

kleeChargedAttack = ->

  tactic.chargedAttack ->

    tactic.delay 200, ->

      unless player.isMoving
        tactic.klee()
        return

      tactic.jump tactic.klee