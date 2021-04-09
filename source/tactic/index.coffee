class TacticX

  backendE: {}
  isActive: false
  isFrozen: false
  isPressed: {}
  origin: 0

  constructor: ->

    player
      .on 'attack:start', @start
      .on 'attack:end', @stop

    member.on 'change', @reset

  attack: (isCharged, callback) ->

    $$.vt 'tactic.attack', callback, 'function'

    if isCharged
      $.click 'left:down'
      @isPressed['l-button'] = true

      delay = 300
      if player.name == 'ganyu'
        delay = 1750

      @delay delay, =>
        $.click 'left:up'
        @isPressed['l-button'] = false

        if player.isMoving and player.name == 'klee'
          @delay 200, => @jump callback
          return

        @delay 100, callback
      return

    $.click 'left'
    @delay 200, callback

  delay: (time, callback) ->

    $$.vt 'tactic.delay', time, 'number'
    $$.vt 'tactic.delay', callback, 'function'

    unless @isActive
      return

    $.clearTimeout timer.tacticDelay
    timer.tacticDelay = $.setTimeout callback, time

  execute: (listTactic, g = 0, i = 0) ->

    item = @get listTactic, g, i
    unless item
      @execute listTactic
      return
    unless item == $.toLowerCase item
      item = "#{item}~"

    next = => @execute listTactic, g, i + 1

    map = {}
    map['@e'] = => @ongoing next, => @execute listTactic, g + 1, 0
    map['@m'] = => @onMoving next, => @execute listTactic, g + 1, 0
    map.a = => @attack false, next
    map['A~'] = => @attack true, next
    map.e = => @useE false, next
    map['E~'] = => @useE true, next
    map.j = => @jump next
    map.s = => @sprint next
    map.t = =>
      $.press 'r'
      @delay 100, next

    callback = map[item]
    unless callback
      callback = => @wait item, next

    callback()

  freeze: (wait) ->

    $$.vt 'tactic.freeze', wait, 'number'

    @isFrozen = true

    $.clearTimeout timer.tacticFreeze
    timer.tacticFreeze = $.setTimeout =>
      @isFrozen = false
    , wait

  get: (list, g = 0, i = 0) ->

    if g >= $.length list
      return false
    group = list[g]

    if i >= $.length group
      return false

    return group[i]

  jump: (callback) ->

    $$.vt 'tactic.jump', callback, 'function'

    player.jump()
    unless player.isMoving
      @delay 450, callback
    else @delay 550, callback

  ongoing: (cbA, cbB) ->

    $$.vt 'tactic.ongoing', cbA, 'function'
    $$.vt 'tactic.ongoing', cbB, 'function'

    if skillTimer.listDuration[player.current]
      @delay 50, cbA
    else @delay 50, cbB

  onMoving: (cbA, cbB) ->

    $$.vt 'tactic.onMoving', cbA, 'function'
    $$.vt 'tactic.onMoving', cbB, 'function'

    if player.isMoving
      @delay 50, cbA
    else @delay 50, cbB

  reset: ->

    $.clearTimeout timer.tacticDelay

    if @isPressed['l-button']
      $.click 'left:up'

    @isActive = false
    @isFrozen = false
    @origin = 0

  sprint: (callback) ->

    $$.vt 'tactic.sprint', callback, 'function'

    player.sprint()
    @delay 100, callback

  start: ->

    if @isActive
      return

    listTactic = @validate()
    unless listTactic
      $.click 'left:down'
      return

    @isActive = true

    wait = 1e3 - ($.now() - ts.toggle)
    if wait < 200
      wait = 200
    @freeze wait

    @execute listTactic, 0, 0

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

  useBackendE: (callback) ->

    $$.vt 'tactic.useBackend', callback, 'function'

    unless @validateBackend()
      return false

    for n in [4, 3, 2, 1]

      if n == player.current
        continue

      if skillTimer.listCountDown[n]
        continue

      name = member.list[n]
      unless @backendE[name]
        continue

      unless @origin
        @origin = player.current

      @freeze 10e3
      @toggle n, => @backendE[name] =>
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

  useE: (isHolding, callback) ->

    $$.vt 'tactic.useE', callback, 'function'

    unless skillTimer.listCountDown[player.current]
      player.useE isHolding
      @freeze 1e3
      @delay 100, callback
      return

    @delay 100, callback

  validate: ->

    if menu.checkVisibility()
      return false

    name = player.name
    unless name
      return false

    listTactic = Character.data[name].tactic
    unless listTactic
      return false

    return listTactic

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

  wait: (time, callback) ->
    unless ($.type time) == 'number'
      throw new Error "tactic.wait: invalid time #{time}"
    @delay time, callback

# execute
tactic = new TacticX()