import combo from '../tactic/combo'
import klee from '../tactic/klee'

# variable

tactic =
  combo: combo
  klee: klee

timer.tactic = ''

state.isAttacking = false

# function

setTacticDelay = (delay, callback) ->

  clearTimeout timer.tactic
  timer.tactic = $.delay delay, (callback = callback) ->
    unless state.isAttacking then return
    callback()

startAttack = ->

  paimon.checkVisibility()

  if paimon.state.isVisible
    $.click 'left:down'
    return

  if state.isAttacking
    return
  state.isAttacking = true

  key = config.data.character[state.character]
  unless key
    key = 'Combo'
  if tactic[key]
    tactic[key].attack()

stopAttack = ->

  state.isAttacking = false

  paimon.checkVisibility()

  if paimon.state.isVisible
    $.click 'left:up'
    return