tactic.qiqi = ->

  unless tactic.isActive
    return

  if tactic.count > 1
    tactic.count = 0

  switch tactic.count
    when 0 then tactic.normalAttack tactic.qiqi
    when 1 then tactic.chargedAttack tactic.qiqi

  tactic.count++