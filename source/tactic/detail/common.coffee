tactic.common = ->

  unless tactic.isActive
    return

  if tactic.useBackendE tactic.common
    return

  unless skillTimer.listCountDown[player.current]
    player.useE()
    tactic.freeze 2e3
    tactic.delay 100, tactic.common
    return

  tactic.normalAttack tactic.common

do ->

  for name, char of Character.data

    {backend} = char
    unless backend
      continue

    if backend > 0
      tactic.backend[name] = (callback) ->
        player.useE()
        tactic.delay backend * 1e3, callback
      continue

    tactic.backend[name] = (callback) ->
      player.useE 'holding'
      tactic.delay 0 - backend * 1e3, callback