class PlayerX extends EmitterX

  isMoving: false

  # ---

  startMove: (key) ->

    if movement.isPressed[key]
      return @

    $.press "#{key}:down"
    return @

  stopMove: (key) ->

    if movement.isPressed[key]
      return @

    $.press "#{key}:up"
    return @

  toggleQ: (key) ->
    $.press "alt + #{key}"
    member.toggle key
    return @

  useE: (isHolding = false) ->

    unless isHolding
      $.press 'e'
      skillTimer.record 'start'
      skillTimer.record 'end'
      return @

    $.press 'e:down'
    skillTimer.record 'start'
    $.delay 1e3, ->
      $.press 'e:up'
      skillTimer.record 'end'
    return @

  useQ: ->
    $.press 'q'
    return @

# execute

player = new PlayerX()