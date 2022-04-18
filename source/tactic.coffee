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
# ja - jump & attack
# q - use q
# s - sprint
# t - aim
# tt - aim twice

### interface
type Fn = () => unknown
###

# function

class Tactic

  intervalCheck: 50
  intervalExecute: 100

  isActive: false
  isPressed: {}

  constructor: ->

    Player
      .on 'attack:start', @start
      .on 'attack:end', @stop

    Party
      .on 'change', @reset
      .on 'switch', =>
        unless @isActive then return
        @stop()
        @start()

  # aim(callback: Fn): void
  aim: (callback) ->
    $.press 'r'
    @delay @intervalExecute, callback

  # aimTwice(callback: Fn): void
  aimTwice: (callback) ->
    $.press 'r'
    @delay @intervalExecute, =>
      $.press 'r'
      @delay @intervalExecute, callback

  # atDuration(cbA: Fn, cbB: Fn, isNot: boolean = false): void
  atDuration: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Skill.listDuration[Party.current]
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  # atMovement: (cbA: Fn, cbB: Fn, isNot: boolean = false): void
  atMovement: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Movement.isMoving
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  # atReady(cbA: Fn, cb: Fn, isNot: boolean = false): void
  atReady: (cbA, cbB, isNot = false) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    unless Skill.listCountDown[Party.current]
      @delay @intervalCheck, cb[0]
    else @delay @intervalCheck, cb[1]

  # attack(isCharged: boolean, callback: Fn): void
  attack: (isCharged, callback) ->

    if isCharged
      $.click 'left:down'
      @isPressed['l-button'] = true

      delay = 400
      name = Party.name
      {weapon} = Character.data[name]
      switch weapon
        when 'bow'
          delay = 1500
          if name == 'ganyu' then delay = 1800
          if name == 'tartaglia' then delay = 400
          if name == 'yoimiya' then delay = 2600
        when 'sword'
          if name == 'xingqiu' then delay = 600

      @delay delay, =>
        $.click 'left:up'
        @isPressed['l-button'] = false

        if Movement.isMoving and Party.name == 'klee'
          @delay 200, => @jump callback
          return

        @delay @intervalExecute, callback

      return

    $.click 'left'
    @delay 200, callback

  # delay(time: number, callback: Fn): void
  delay: (time, callback) ->
    unless @isActive then return
    Timer.add 'tactic', time, callback

  # execute(listTactic: string[], g: number = 0, i: number = 0): void
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
      'ja': => @jumpAttack next
      'q': => @useQ next
      's': => @sprint next
      't': => @aim next
      'tt': => @aimTwice next

    # console.log "tactic: #{item}"
    callback = map[item]
    if !callback and ($.type item) == 'number'
      callback = => @delay item, next

    if callback then callback()

  # get(list: string[], g: number = 0, i: number = 0): string
  get: (list, g = 0, i = 0) ->
    if g >= $.length list then return ''
    group = list[g]
    if i >= $.length group then return ''
    return group[i]

  # jump(callback: Fn): void
  jump: (callback) ->
    Movement.jump()
    unless Movement.isMoving
      @delay 450, callback
    else @delay 550, callback

  # jumpAttack(callback: Fn): void
  jumpAttack: (callback) ->
    Movement.jump()
    @delay 50, ->
      $.click 'left'
      @delay 50, callback

  # reset(): void
  reset: ->

    Timer.remove 'tactic'

    if @isPressed['l-button']
      $.click 'left:up'

    @isActive = false

  # sprint(callback: Fn): void
  sprint: (callback) ->
    Movement.sprite()
    @delay @intervalExecute, callback

  # start(): void
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

  # stop(): void
  stop: ->

    if @isActive
      @reset()
      return

    $.click 'left:up'

  # useE(isHolding: boolean, callback: Fn): void
  useE: (isHolding, callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalCheck, callback
      return

    Skill.useE isHolding
    @delay @intervalExecute, callback

  # useEE(callback: Fn): void
  useEE: (callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalCheck, callback
      return

    Skill.useE()
    @delay 600, =>
      Skill.useE()
      @delay @intervalExecute, callback

  # useQ(callback: Fn): void
  useQ: (callback) ->
    Skill.useQ()
    @delay @intervalExecute, callback

  # validate(): boolean
  validate: ->

    unless Scene.is 'normal' then return false

    {name} = Party
    unless name then return false

    listTactic = Character.data[name].onLongPress
    unless listTactic then return false

    return listTactic

# execute
Tactic = new Tactic()