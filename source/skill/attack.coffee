import klee from '../tactic/klee'

# variable

tactic =
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

  unless tactic[config.data[state.character]]
    $.click 'left:down'
    return

  if state.isAttacking
    return
  state.isAttacking = true

  tactic[config.data[state.character]].attack()

stopAttack = ->

  unless tactic[config.data[state.character]]
    $.click 'left:up'
    return

  unless state.isAttacking
    return
  state.isAttacking = false