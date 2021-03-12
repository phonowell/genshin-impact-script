class TacticX

  backend: {}
  count: 0
  isActive: false
  isFrozen: false
  origin: 0

  constructor: ->

    player
      .on 'attack:start', @start
      .on 'attack:end', @stop

    member.on 'change', @reset

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

  freeze: (wait) ->

    @isFrozen = true

    $.clearTimeout timer.tacticFreeze
    timer.tacticFreeze = $.setTimeout =>
      @isFrozen = false
    , wait

  jump: (callback) ->
    player.jump()
    unless player.isMoving
      @delay 450, callback
    else @delay 550, callback

  normalAttack: (callback) ->
    $.click 'left'
    @delay 200, callback

  reset: ->
    @count = 0
    @isActive = false
    @isFrozen = false
    @origin = 0

  start: ->

    if @isActive
      return

    callback = @validate()
    unless callback
      $.click 'left:down'
      return

    @isActive = true

    wait = 1e3 - ($.now() - ts.toggle)
    if wait < 200
      wait = 200
    @freeze wait

    callback()

  stop: ->

    if @isActive
      @reset()
      return

    $.click 'left:up'

  toggle: (n, callback) ->

    unless @isActive
      return

    $.press n
    member.toggle n
    @delay 200, callback

  useBackend: (callback) ->

    unless @validateBackend()
      return false

    for n in [4, 3, 2, 1]

      if n == player.current
        continue

      if skillTimer.listCountDown[n]
        continue

      name = member.map[n]
      unless @backend[name]
        continue

      unless @origin
        @origin = player.current

      @freeze 10e3
      @toggle n, => @backend[name] =>
        callback()
        @freeze 1e3

      return true

    if @origin and @origin != player.current
      @freeze 10e3
      @toggle @origin, =>
        callback()
        @freeze 1e3
        @origin = 0
      return true

    return false

  validate: ->

    if menu.isVisible
      return false

    name = player.name
    unless name
      return false

    {typeAtk} = Character.data[name]
    unless typeAtk
      return false

    if @[name]
      return @[name]

    return @common

  validateBackend: ->

    if @isFrozen
      return false

    now = $.now()

    unless now - ts.sprint >= 500
      return false

    unless now - ts.jump >= 500
      return false

    unless @origin
      unless Character.data[player.name].typeAtk >= 2
        return false

    return true

# execute
tactic = new TacticX()

import 'detail/*'