isMoving = ->

  for key in ['w', 'a', 's', 'd']
    if $.getState key
      return key
  return false

pauseMove = ->

  for key in ['w', 'a', 's', 'd']
    if $.getState key
      $.press "#{key}:up"

resumeMove = ->

  for key in ['w', 'a', 's', 'd']
    if $.getState key
      $.press "#{key}:down"