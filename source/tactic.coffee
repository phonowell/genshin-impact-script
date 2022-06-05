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
# q - use q
# s - sprint
# t - aim
# tt - aim twice

### interface
type Fn = () => unknown
###

# function

class Tactic

  intervalLong: 100
  intervalShort: 50
  isActive: false
  isPressed: false

  constructor: ->
    Player.on 'attack:start', => @start Character.get Party.name, 'onLongPress'
    Player.on 'attack:end', @stop
    Party.on 'switch', @stop

  # atDuration(cbA: Fn, cbB: Fn, isNot: boolean = false): void
  atDuration: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Skill.listDuration[Party.current]
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  # atMovement: (cbA: Fn, cbB: Fn, isNot: boolean = false): void
  atMovement: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Movement.isMoving
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  # atReady(cbA: Fn, cb: Fn, isNot: boolean = false): void
  atReady: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    unless Skill.listCountDown[Party.current]
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  # delay(time: number, callback: Fn): void
  delay: (time, callback) ->
    unless @isActive then return
    Timer.add 'tactic/next', time, callback

  # doAim(callback: Fn): void
  doAim: (callback) ->
    $.press 'r'
    @delay @intervalLong, callback

  # doAimTwice(callback: Fn): void
  doAimTwice: (callback) ->
    $.press 'r'
    @delay @intervalLong, =>
      $.press 'r'
      @delay @intervalLong, callback

  # doAttack(isCharged: boolean, callback: Fn): void
  doAttack: (isCharged, callback) ->

    if isCharged
      $.click 'left:down'
      @isPressed = true

      delay = 400
      {name} = Party
      switch Character.get name, 'weapon'
        when 'bow'
          delay = 1500
          if name == 'ganyu' then delay = 1800
          if name == 'tartaglia' then delay = 400
          if name == 'yoimiya' then delay = 2600
        when 'sword'
          if name == 'xingqiu' then delay = 600

      @delay delay, =>
        $.click 'left:up'
        @isPressed = false

        if Movement.isMoving and Party.name == 'klee'
          @delay 200, => @jump callback
          return

        @delay @intervalLong, callback

      return

    $.click 'left'
    @delay 200, callback

  # doJump(callback: Fn): void
  doJump: (callback) ->
    Movement.jump()
    unless Movement.isMoving
      @delay 450, callback
    else @delay 550, callback

  # doSprint(callback: Fn): void
  doSprint: (callback) ->
    Movement.sprite()
    @delay @intervalLong, callback

  # doUseE(isHolding: boolean, callback: Fn): void
  doUseE: (isHolding, callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalShort, callback
      return

    Skill.useE isHolding
    @delay @intervalLong, callback

  # doUseEE(callback: Fn): void
  doUseEE: (callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalShort, callback
      return

    Skill.useE()
    @delay 600, =>
      Skill.useE()
      @delay @intervalLong, callback

  # doUseQ(callback: Fn): void
  doUseQ: (callback) ->
    Skill.useQ()
    @delay @intervalLong, callback

  # execute(list: string[], g: number = 0, i: number = 0, isOnce = false): void
  execute: (list, g = 0, i = 0, isOnce = false) ->

    item = @get list, g, i
    unless item
      unless isOnce then @execute list
      return

    next = => @execute list, g, i + 1, isOnce
    nextGroup = => @execute list, g + 1, 0, isOnce

    map =
      '!@e': => @atDuration next, nextGroup, 'not'
      '!@e?': => @atReady next, nextGroup, 'not'
      '!@m': => @atMovement next, nextGroup, 'not'
      '@e': => @atDuration next, nextGroup, 0
      '@e?': => @atReady next, nextGroup, 0
      '@m': => @atMovement next, nextGroup, 0
      'a': => @doAttack false, next
      'a~': => @doAttack true, next
      'e': => @doUseE false, next
      'ee': => @doUseEE next
      'e~': => @doUseE true, next
      'j': => @doJump next
      'q': => @doUseQ next
      's': => @doSprint next
      't': => @doAim next
      'tt': => @doAimTwice next

    callback = map[item]
    unless callback
      if ($.type item) == 'number' then callback = => @delay item, next

    if callback then callback()

  # format(ipt: string): string[]
  format: (ipt) ->

    unless ipt then return 0

    ipt = $.replace ipt, ' ', ''
    listAll = []

    for group in $.split ipt, ';'
      listGroup = []
      for item in $.split group, ','
        $.push listGroup, item
      $.push listAll, listGroup

    return listAll

  # get(list: string[], g: number = 0, i: number = 0): string
  get: (list, g = 0, i = 0) ->
    if g >= $.length list then return ''
    group = list[g]
    if i >= $.length group then return ''
    return group[i]

  # start(list: string, isOnce = false): void
  start: (list, isOnce = false) ->

    @stop()

    unless Scene.is 'normal' then return

    list = @format list
    unless list then return

    @isActive = true
    $.click 'left:up'

    @execute list, 0, 0, isOnce

  # stop(): void
  stop: ->
    @isActive = false
    Timer.remove 'tactic/next'

# execute
Tactic = new Tactic()