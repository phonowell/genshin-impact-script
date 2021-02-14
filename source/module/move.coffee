# binding

player

  .on 'move-start', ->
    if player.isMoving
      return
    player.isMoving = true
  .on 'move-end', ->
    unless player.isMoving
      return
    player.isMoving = false