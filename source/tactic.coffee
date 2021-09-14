# !@e - not at e duration
# !@e? - e is not ready
# !@m - not at movement
# @e - at e-duration
# @e? - e is ready
# @m - at movement
# a - attack
# a~ - charged attack
# e - use e
# ee - use e twice
# e~ - holding e
# j - jump
# s - sprint
# t - aim
# tt - aim twice

class TacticX

  intervalCheck: 50
  intervalExecute: 100

  isActive: false
  isPressed: {}

  constructor: ->

    player
      .on 'attack:start', @start
      .on 'attack:end', @stop

    party
      .on 'change', @reset
      .on 'switch', =>
        unless @isActive then return
        @stop()
        @start()

  aim: (callback) ->
    $.press 'r'
    @delay @intervalExecute, callback

  aimTwice: (callback) ->
    $.press 'r'
    @delay @intervalExecute, =>
      $.press 'r'
      @delay @intervalExecute, callback

  atDuration: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if SkillTimer.listDuration[Party.current]
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  atMovement: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if movement.isMoving
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  atReady: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    unless SkillTimer.listCountDown[Party.current]
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  attack: (isCharged, callback) ->

    if isCharged
      $.click 'left:down'
      @isPressed['l-button'] = true

      delay = 300
      name = Party.name
      {weapon} = Character.data[name]
      switch weapon
        when 'bow'
          delay = 1500
          if name == 'ganyu'
            delay = 1800
          if name == 'tartaglia'
            delay = 300
        when 'sword'
          delay = 400
          if name == 'xingqiu'
            delay = 600

      @delay delay, =>
        $.click 'left:up'
        @isPressed['l-button'] = false

        if movement.isMoving and Party.name == 'klee'
          @delay 200, => @jump callback
          return

        @delay @intervalExecute, callback

      return

    $.click 'left'
    @delay 200, callback

  delay: (time, callback) ->
    unless @isActive then return
    $.clearTimeout timer.tacticDelay
    timer.tacticDelay = $.setTimeout callback, time

  execute: (listTactic, g = 0, i = 0) ->

    item = @get listTactic, g, i
    unless item
      @execute listTactic
      return

    next = => @execute listTactic, g, i + 1
    nextGroup = => @execute listTactic, g + 1, 0

    map =
      '!@e': => @atDuration next, nextGroup, 'not'
      '!@e?': => @atReady next, nextGroup, 'not'
      '!@m': => @atMovement next, nextGroup, 'not'
      '@e': => @atDuration next, nextGroup, 0
      '@e?': => @atReady next, nextGroup, 0
      '@m': => @atMovement next, nextGroup, 0
      'a': => @attack false, next
      'a~': => @attack true, next
      'e': => @useE false, next
      'ee': => @useEE next
      'e~': => @useE true, next
      'j': => @jump next
      's': => @sprint next
      't': => @aim next
      'tt': => @aimTwice next

    # console.log "tactic: #{item}"
    callback = map[item]
    if !callback and ($.type item) == 'number'
      callback = => @delay item, next

    if callback then callback()

  get: (list, g = 0, i = 0) ->
    if g >= $.length list then return false
    group = list[g]
    if i >= $.length group then return false
    return group[i]

  jump: (callback) ->
    movement.jump()
    unless movement.isMoving
      @delay 450, callback
    else @delay 550, callback

  reset: ->

    $.clearTimeout timer.tacticDelay

    if @isPressed['l-button']
      $.click 'left:up'

    @isActive = false

  sprint: (callback) ->
    movement.sprint()
    @delay @intervalExecute, callback

  start: ->

    if @isActive then return

    listTactic = @validate()
    unless listTactic
      $.click 'left:down'
      return

    @isActive = true

    wait = 1e3 - ($.now() - Party.tsSwitch)
    if wait < 200
      wait = 200

    @execute listTactic, 0, 0

  stop: ->

    if @isActive
      @reset()
      return

    $.click 'left:up'

  useE: (isHolding, callback) ->

    if SkillTimer.listCountDown[Party.current]
      @delay @intervalCheck, callback
      return

    Player.useE isHolding
    @delay @intervalExecute, callback

  useEE: (callback) ->

    if SkillTimer.listCountDown[Party.current]
      @delay @intervalCheck, callback
      return

    Player.useE()
    @delay 600, =>
      Player.useE()
      @delay @intervalExecute, callback

  validate: ->

    unless Scene.name == 'normal' then return false

    {name} = party
    unless name then return false

    listTactic = Character.data[name].onLongPress
    unless listTactic then return false

    return listTactic

# execute
Tactic = new TacticX()