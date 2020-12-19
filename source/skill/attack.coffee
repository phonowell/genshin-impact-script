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

  delay = delay + $.random 100

  clearTimeout timer.tactic
  timer.tactic = $.delay delay, (callback = callback) ->
    unless state.isAttacking then return
    callback()

startAttack = ->

  paimon.checkVisibility()

  unless !paimon.state.isVisible and tactic[config.data.character[state.character]]
    $.click 'left:down'
    return

  if state.isAttacking
    return
  state.isAttacking = true

  tactic[config.data.character[state.character]].attack()

stopAttack = ->

  paimon.checkVisibility()

  unless !paimon.state.isVisible and tactic[config.data.character[state.character]]
    $.click 'left:up'
    return

  unless state.isAttacking
    return
  state.isAttacking = false