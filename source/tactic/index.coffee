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

    $$.vt 'tactic.chargedAttack', callback, 'function'

    $.click 'left:down'
    @delay 400, ->
      $.click 'left:up'
      callback()

  delay: (time, callback) ->

    $$.vt 'tactic.delay', time, 'number'
    $$.vt 'tactic.delay', callback, 'function'

    unless @isActive
      return

    $.clearTimeout timer.tacticDelay
    timer.tacticDelay = $.setTimeout callback, time

  freeze: (wait) ->

    $$.vt 'tactic.freeze', wait, 'number'

    @isFrozen = true

    $.clearTimeout timer.tacticFreeze
    timer.tacticFreeze = $.setTimeout =>
      @isFrozen = false
    , wait

  jump: (callback) ->

    $$.vt 'tactic.jump', callback, 'function'

    player.jump()
    unless player.isMoving
      @delay 450, callback
    else @delay 550, callback

  normalAttack: (callback) ->

    $$.vt 'tactic.normalAttack', callback, 'function'

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

    $$.vt 'tactic.toggle', n, 'number'
    $$.vt 'tactic.toggle', callback, 'function'

    unless @isActive
      return

    $.press n
    member.toggle n
    @delay 200, callback

  useBackend: (callback) ->

    $$.vt 'tactic.useBackend', callback, 'function'

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

    {typeCbt} = Character.data[name]
    unless typeCbt
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
      unless Character.data[player.name].typeCbt >= 2
        return false

    return true

# execute
tactic = new TacticX()

import 'detail/*'