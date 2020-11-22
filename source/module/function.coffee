isMoving = ->
  for key in ['w', 'a', 's', 'd']
    if $.getState key
      return key
  return false