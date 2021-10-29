# variable

ts.jump = 0

# function

class MovementX extends KeyBindingX

  isWalking: false

  # ---

  constructor: ->
    super()

    # move
    for key in ['w', 'a', 's', 'd']
      @bindEvent 'move', key

    # walk
    $.on 'alt + w', => Client.delay 'walk', 100, @toggleWalk
    Player.on 'attack:start', @stopWalk
    @on 'move:start', @stopWalk

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

  # startWalk(): void
  startWalk: ->

    unless Scene.name == 'normal' then return
    if @isWalking then return

    @isWalking = true
    msg = 'enter auto-walk mode'
    if Config.data.region == 'cn' then msg = '开启自动前行'
    Hud.render 5, msg

    $.press 'w:down'
    Sound.beep 2

  # stopWalk(): void
  stopWalk: ->

    unless Scene.name == 'normal' then return
    unless @isWalking then return

    @isWalking = false
    msg = 'leave auto-walk mode'
    if Config.data.region == 'cn' then msg = '关闭自动前行'
    Hud.render 5, msg

    $.press 'w:up'
    Sound.beep 2

  # toggleWalk(): void
  toggleWalk: ->
    if @isWalking then @stopWalk()
    else @startWalk()

# execute
Movement = new MovementX()