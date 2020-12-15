state.countKlee = 0

tactic.klee = ->

  unless state.countKlee >= 2
    state.countKlee++
    kleeA()
  else
    state.countKlee = 0
    kleeB()

kleeA = ->

  $.click 'left'

  setTacticDelay 550, ->
    $.press 'w'

    setTacticDelay 50, tactic.klee

kleeB = ->

  $.click 'left:down'

  setTacticDelay 250, ->
    $.click 'left:up'

    setTacticDelay 850, ->
      $.press 'w'

      setTacticDelay 50, tactic.klee