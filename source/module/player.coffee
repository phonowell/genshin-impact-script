class PlayerX extends EmitterX

  isMoving: false
  isSprinting: false

# execute

player = new PlayerX()

player

  .on 'move-start', ->
    if player.isMoving
      return
    player.isMoving = true
  .on 'move-end', ->
    unless player.isMoving
      return
    player.isMoving = false

  .on 'sprint-start', ->
    if player.isSprinting
      return
    player.isSprinting = true
  .on 'sprint-end', ->
    unless player.isSprinting
      return
    player.isSprinting = false