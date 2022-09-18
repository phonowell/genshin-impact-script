# function

class Jumper extends KeyBinding

  flagIsNormal: false
  isBreaking: false
  tsJump: 0

  constructor: ->
    super()
    @init()
    @watch()

  # check(): void
  check: ->

    unless Config.get 'better-jump' then return
    if @isBreaking then return
    unless Scene.is 'normal' then return

    unless ColorManager.findAll 0xF05C4A, [
      '73%', '48%'
      '75%', '52%'
    ] then return

    unless ColorManager.findAll [0xFFFFFF, 0x323232], [
      '72%', '53%'
      '75%', '56%'
    ] then return

    @isBreaking = true
    Timer.loop 'jumper/break', 50, @jump
    Timer.add 550, =>
      Timer.remove 'jumper/break'
      @isBreaking = false

  # checkIsVeryNormal(): boolean
  checkIsVeryNormal: -> return ColorManager.findAll [0xFFFFFF, 0x323232], [
    '94%', '80%'
    '95%', '82%'
  ]

  # init(): void
  init: ->

    @registerEvent 'jump', 'space'

    @on 'jump:start', =>
      @flagIsNormal = (Scene.is 'normal', 'unknown') and @checkIsVeryNormal()
      @tsJump = $.now()

    @on 'jump:end', =>

      now = $.now()
      diff = now - @tsJump
      @tsJump = now

      unless (Config.get 'better-jump') and @flagIsNormal then return
      unless diff < 350 then return

      Timer.add 'jump', 350 - diff, @jump

  # jump(): void
  jump: ->
    $.press 'space'
    @tsJump = $.now()

  # watch(): void
  watch: ->

    interval = 300
    token = 'jumper/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @check

# execute
Jumper = new Jumper()