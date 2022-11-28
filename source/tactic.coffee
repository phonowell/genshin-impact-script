# @ts-check

### keywords
!@e - not at e duration
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

class TacticG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/tactic').TacticG['intervalLong'] ###
    @intervalLong = 100
    ###* @type import('./type/tactic').TacticG['intervalShort'] ###
    @intervalShort = 50
    ###* @type import('./type/tactic').TacticG['isActive'] ###
    @isActive = false

  ###* @type import('./type/tactic').TacticG['atDuration'] ###
  atDuration: (cbA, cbB, isNot) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Skill.listDuration[Party.current]
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  ###* @type import('./type/tactic').TacticG['atMovement'] ###
  atMovement: (cbA, cbB, isNot) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    if Movement.isMoving
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  ###* @type import('./type/tactic').TacticG['atReady'] ###
  atReady: (cbA, cbB, isNot) ->

    cb = [cbA, cbB]
    if isNot then cb = [cbB, cbA]

    unless Skill.listCountDown[Party.current]
      @delay @intervalShort, cb[0]
    else @delay @intervalShort, cb[1]

  ###* @type import('./type/tactic').TacticG['delay'] ###
  delay: (time, callback) -> Timer.add 'tactic/next', time, callback

  ###* @type import('./type/tactic').TacticG['doAim'] ###
  doAim: (callback) ->
    $.press 'r'
    @delay @intervalLong, callback

  ###* @type import('./type/tactic').TacticG['doAimTwice'] ###
  doAimTwice: (callback) ->
    $.press 'r'
    @delay @intervalLong, =>
      $.press 'r'
      @delay @intervalLong, callback

  ###* @type import('./type/tactic').TacticG['doAttack'] ###
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
        @delay @intervalLong, callback

      return

    $.press 'l-button'
    @delay 200, callback

  ###* @type import('./type/tactic').TacticG['doJump'] ###
  doJump: (callback) ->
    Jumper.jump()
    unless Movement.isMoving
      @delay 450, callback
    else @delay 550, callback

  ###* @type import('./type/tactic').TacticG['doSprint'] ###
  doSprint: (callback) ->
    Movement.sprint()
    @delay @intervalLong, callback

  ###* @type import('./type/tactic').TacticG['doUseE'] ###
  doUseE: (isHolding, callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalShort, callback
      return

    Skill.useE isHolding, callback

  ###* @type import('./type/tactic').TacticG['doUseEE'] ###
  doUseEE: (callback) ->

    if Skill.listCountDown[Party.current]
      @delay @intervalShort, callback
      return

    Skill.useE()
    @delay 600, -> Skill.useE false, callback

  ###* @type import('./type/tactic').TacticG['doUseQ'] ###
  doUseQ: (callback) ->
    Skill.useQ()
    @delay @intervalLong, callback

  ###* @type import('./type/tactic').TacticG['end'] ###
  end: (list, callback = undefined) ->
    unless callback
      @execute list
      return

    @stop()
    callback()
    return

  ###* @type import('./type/tactic').TacticG['execute'] ###
  execute: (list, g = 0, i = 0, callback = undefined) ->

    unless @isActive
      @stop()
      return

    unless Scene.is 'normal'
      @stop()
      return

    item = @get list, g, i

    unless item
      @delay @intervalLong, => @end list, callback
      return

    next = => @execute list, g, i + 1, callback
    nextGroup = => @execute list, g + 1, 0, callback

    map =
      '!@e': => @atDuration next, nextGroup, true
      '!@e?': => @atReady next, nextGroup, true
      '!@m': => @atMovement next, nextGroup, true
      '@e': => @atDuration next, nextGroup, false
      '@e?': => @atReady next, nextGroup, false
      '@m': => @atMovement next, nextGroup, false
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
        $.press $.subString item, 1
        @delay @intervalShort, next

      if $.isNumber item then return => @delay ($.toNumber item), next
      return $.noop

    cb()

  ###* @type import('./type/tactic').TacticG['format'] ###
  format: (ipt) ->

    unless ipt then return []

    ipt = $.replace ipt, ' ', ''
    listAll = []

    for group in $.split ipt, ';'
      listGroup = []
      for item in $.split group, ','
        $.push listGroup, item
      $.push listAll, listGroup

    return listAll

  ###* @type import('./type/tactic').TacticG['get'] ###
  get: (list, g = 0, i = 0) ->
    if g >= $.length list then return ''
    group = list[g]
    if i >= $.length group then return ''
    return group[i]

  ###* @type import('./type/tactic').TacticG['init'] ###
  init: ->

    Scene.useEffect =>

      @registerEvent 'attack', 'l-button'
      @on 'attack:start', =>
        unless Party.name then return
        @start Character.get Party.name, 'onLongPress'
      @on 'attack:end', @stop

      return =>
        @unregisterEvent 'attack', 'l-button'
        @off 'attack:start'
        @off 'attack:end'

    , ['normal']

    Scene.useEffect =>

      @registerEvent 'side-button-1', 'x-button-1'
      @on 'side-button-1:start', =>
        unless Party.name then return
        @start Character.get Party.name, 'onSideButton1'
      @on 'side-button-1:end', @stop

      return =>
        @unregisterEvent 'side-button-1', 'x-button-1'
        @off 'side-button-1:start'
        @off 'side-button-1:end'

    , ['normal']

    Scene.useEffect =>

      @registerEvent 'side-button-2', 'x-button-2'
      @on 'side-button-2:start', =>
        unless Party.name then return
        @start Character.get Party.name, 'onSideButton2'
      @on 'side-button-2:end', @stop

      return =>
        @unregisterEvent 'side-button-2', 'x-button-2'
        @off 'side-button-2:start'
        @off 'side-button-2:end'

    , ['normal']

    Scene.useEffect =>
      Party.on 'switch.tactic', @stop
      return -> Party.off 'switch.tactic'
    , ['normal']

  ###* @type import('./type/tactic').TacticG['start'] ###
  start: (line, callback = undefined) ->

    @stop()

    unless Scene.is 'normal'
      if callback then callback()
      return

    if Movement.isForwarding
      Movement.stopForward()

    list = @format line
    unless $.length list
      if callback then callback()
      return

    @isActive = true
    @execute list, 0, 0, callback

  ###* @type import('./type/tactic').TacticG['stop'] ###
  stop: ->
    @isActive = false
    Timer.remove 'tactic/next'

Tactic = new TacticG()