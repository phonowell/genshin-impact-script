tactic.common = ->

  unless tactic.isActive
    return

  if tactic.useBackend tactic.common
    return

  unless tactic.isFrozen

    unless skillTimer.listCountDown[player.current]
      player.useE()
      tactic.freeze 1e3
      tactic.delay 100, tactic.common
      return

  tactic.normalAttack tactic.common

member.on 'change', ->

  for name, n in member.list

    {backend} = Character.data[name]
    unless backend
      continue

    if backend > 0
      tactic.backend[name] = (callback) ->
        $$.vt "tactic.backend.#{name}", callback, 'function'
        player.useE()
        tactic.delay backend * 1e3, callback
      continue

    tactic.backend[name] = (callback) ->
      $$.vt "tactic.backend.#{name}", callback, 'function'
      player.useE 'holding'
      tactic.delay 0 - backend * 1e3, callback