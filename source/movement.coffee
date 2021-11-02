# variable

ts.jump = 0

# function

class MovementX extends KeyBindingX

  isForwarding: false
  isMoving: false
  count: 0

  # ---

  constructor: ->
    super()

    # walk
    for key in ['w', 'a', 's', 'd'] then @bindEvent 'walk', key

    @on 'walk:start', =>
      unless @count then @emit 'move:start'
      if @count >= 4 then return
      @count++

    @on 'walk:end', =>
      if @count == 1 then @emit 'move:end'
      if @count <= 0 then return
      @count--

    @on 'move:start', => @isMoving = true
    @on 'move:end', => @isMoving = false

    # forward
    $.on 'alt + w', => Client.delay 'forward', 100, @toggleForward
    @on 'walk:start', @stopForward

    # jump
    @bindEvent 'jump', 'space', 'prevent'

    @on 'jump:start', ->
      $.press 'space:down'
      ts.jump = $.now()

    @on 'jump:end', ->

      $.press 'space:up'

      now = $.now()
      diff = now - ts.jump
      ts.jump = now

      unless Config.data.betterJump and Scene.name == 'normal' then return
      unless diff < 350 then return

      Client.delay '~jump', 350 - diff, ->
        Movement.jump()
        ts.jump = $.now()

  # jump(): void
  jump: ->
    $.press 'space'
    ts.jump = $.now()

  # startForward(): void
  startForward: ->

    unless Scene.name == 'normal' then return
    if @isForwarding then return

    @isForwarding = true
    msg = 'enter auto-forward mode'
    if Config.data.region == 'cn' then msg = '开启自动前行'
    Hud.render 5, msg

    $.press 'w:down'

  # stopForward(): void
  stopForward: ->

    unless Scene.name == 'normal' then return
    unless @isForwarding then return

    @isForwarding = false
    msg = 'leave auto-forward mode'
    if Config.data.region == 'cn' then msg = '关闭自动前行'
    Hud.render 5, msg

    $.press 'w:up'

  # toggleForward(): void
  toggleForward: ->
    if @isForwarding then @stopForward()
    else @startForward()

# execute
Movement = new MovementX()