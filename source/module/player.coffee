class PlayerX extends EmitterX

  isMoving: false

  # ---

  toggleQ: (key) ->
    $.press "alt + #{key}"
    member.toggle key

# execute

player = new PlayerX()