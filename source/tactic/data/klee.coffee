tactic.klee = ->

  unless tactic.isActive
    return

  if tactic.count > 1
    tactic.count = 0

  switch tactic.count
    when 0 then kleeAttackA()
    when 1 then kleeAttackB()

  tactic.count++

kleeAttackA = ->
  $.click 'left'
  tactic.delay 100, tactic.klee

kleeAttackB = ->

  $.click 'left:down'

  tactic.delay 300, ->

    $.click 'left:up'

    tactic.delay 200, ->

      unless player.isMoving
        tactic.klee()
        return

      player.jump()
      tactic.delay 600, tactic.klee