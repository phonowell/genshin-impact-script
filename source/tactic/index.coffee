class TacticX

  backend: {}
  count: 0
  isActive: false
  isFrozen: false
  timer: ''

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

  freeze: (wait = 1e3) ->

    @isFrozen = true

    $.clearTimeout @timer
    @timer = $.setTimeout =>
      @isFrozen = false
    , wait

  jump: (callback) ->
    player.jump()
    unless player.isMoving
      @delay 450, callback
    else @delay 550, callback

  normalAttack: (callback) ->
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

  toggle: (n, callback) ->
    $.press n
    member.toggle n
    @delay 300, callback

  useBackendE: (callback) ->

    if @isFrozen
      return

    unless Character.data[player.name].typeAtk == 2
      return

    m = player.current

    for n in [4, 3, 2, 1]

      if n == player.current
        continue

      if skillTimer.listCountDown[n]
        continue

      name = member.map[n]
      unless @backend[name]
        continue

      @freeze 5e3
      @toggle n, => @backend[name] => @toggle m, =>
        callback()
        @freeze 1e3

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

# execute
tactic = new TacticX()

import 'detail/*'