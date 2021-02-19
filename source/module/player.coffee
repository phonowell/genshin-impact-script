class PlayerX extends EmitterX

  isMoving: false

  # ---

  toggleQ: (key) ->
    $.press "alt + #{key}"
    member.toggle key

  useE: (isHolding = false) ->

    unless isHolding
      $.press 'e'
      skillTimer.record 'start'
      skillTimer.record 'end'
      return

    $.press 'e:down'
    skillTimer.record 'start'
    $.delay 1e3, ->
      $.press 'e:up'
      skillTimer.record 'end'

  useQ: -> $.press 'q'

# execute

player = new PlayerX()