# !@e - not at e duration
### keywords
!@e? - e is not ready
!@m - not at movement
# - ignore
@e - at e-duration
@e? - e is ready
@m - at movement
a - attack
a~ - charged attack
e - use e
ee - use e twice
e~ - holding e
j - jump
q - use q
s - sprint
t - aim
tt - aim twice
###

# function

class Tactic extends KeyBinding

  intervalLong: 100
  intervalShort: 50
  isActive: false

  constructor: ->
    super()
    @init()

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
  delay: (time, callback) -> Timer.add 'tactic/next', time, callback

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
      $.press 'l-button:down'

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
        $.press 'l-button:up'

        if Movement.isMoving and Party.name == 'klee'
          @delay 200, => @jump callback
          return

        @delay @intervalLong, callback

      return

    $.press 'l-button'
    @delay 200, callback

  # doJump(callback: Fn): void
  doJump: (callback) ->
    Jumper.jump()
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

  # end(list: string[][], callback: Fn): void
  end: (list, callback = '') ->
    unless callback
      @execute list
      return

    @stop()
    callback()

  # execute(list: string[][], g: number = 0, i: number = 0, callback: Fn): void
  execute: (list, g = 0, i = 0, callback = '') ->

    unless @isActive
      @stop()
      return

    unless Scene.is 'normal'
      @stop()
      return

    item = @get list, g, i

    unless item
      @end list, callback
      return

    next = => @execute list, g, i + 1, callback
    nextGroup = => @execute list, g + 1, 0, callback

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

    cb = map[item]
    unless cb then cb = do =>

      if $.startsWith item, '#' then return nextGroup

      if $.startsWith item, '$' then return =>
        $.press SubStr item, 2
        @delay @intervalShort, next

      if $.isNumber item then return => @delay item, next

    cb()

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

  # init(): void
  init: ->

    @registerEvent 'attack', 'l-button'
    @on 'attack:start', =>
      @start Character.get Party.name, 'onLongPress'
    @on 'attack:end', @stop

    @registerEvent 'side-button-1', 'x-button-1'
    @on 'side-button-1:start', =>
      @start Character.get Party.name, 'onSideButton1'
    @on 'side-button-1:end', @stop

    @registerEvent 'side-button-2', 'x-button-2'
    @on 'side-button-2:start', =>
      @start Character.get Party.name, 'onSideButton2'
    @on 'side-button-2:end', @stop

    Party.on 'switch', @stop

  # start(list: string, callback: Fn): void
  start: (list, callback = '') ->

    @stop()

    unless Scene.is 'normal'
      if callback then callback()
      return

    list = @format list
    unless list
      if callback then callback()
      return

    @isActive = true
    @execute list, 0, 0, callback

  # stop(): void
  stop: ->
    @isActive = false
    Timer.remove 'tactic/next'

# execute
Tactic = new Tactic()