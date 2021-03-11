class TacticX

  count: 0
  isActive: false

  constructor: ->
    player
      .on 'attack:start', @start
      .on 'attack:end', @stop

  chargedAttack: (callback) ->
    $.click 'left:down'
    @delay 400, ->
      $.click 'left:up'
      callback()

  delay: (time, callback) ->

    unless @isActive
      return

    $.clearTimeout timer.tacticDelay
    timer.tacticDelay = $.setTimeout callback, time

  jump: (callback) ->
    player.jump()
    unless player.isMoving
      @delay 450, callback
    else @delay 550, callback

  normalAttack: (callback) ->

    if player.isMoving
      @jump callback
      return

    $.click 'left'
    @delay 100, callback

  start: ->

    if @isActive
      return

    callback = @validate()
    unless callback
      $.click 'left:down'
      return

    @isActive = true
    callback()

  stop: ->

    if @isActive
      @count = 0
      @isActive = false
      return

    $.click 'left:up'

  validate: ->

    name = player.name
    unless name
      return false

    {typeAtk} = Character.data[name]
    unless typeAtk
      return false

    unless @[name]
      return false

    if menu.isVisible
      return false

    return @[name]

# execute
tactic = new TacticX()

import 'detail/*'