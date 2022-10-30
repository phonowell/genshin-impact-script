# @ts-check

class JumperG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/jumper').JumperG['flagIsNormal'] ###
    @flagIsNormal = false
    ###* @type import('./type/jumper').JumperG['isBreaking'] ###
    @isBreaking = false
    ###* @type import('./type/jumper').JumperG['tsJump'] ###
    @tsJump = 0

  ###* @type import('./type/jumper').JumperG['check'] ###
  check: ->

    unless Config.get 'better-jump/enable' then return
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

  ###* @type import('./type/jumper').JumperG['init'] ###
  init: ->
    @watch()

    @registerEvent 'jump', 'space'

    @on 'jump:start', =>
      @flagIsNormal = Scene.is 'normal', 'not-domain', 'not-busy'
      @tsJump = $.now()

    @on 'jump:end', =>

      now = $.now()
      diff = now - @tsJump
      @tsJump = now

      unless (Config.get 'better-jump/enable') and @flagIsNormal then return
      unless diff < 350 then return

      Timer.add 'jump', 350 - diff, @jump

  ###* @type import('./type/jumper').JumperG['jump'] ###
  jump: ->
    $.press 'space'
    @tsJump = $.now()
    return

  ###* @type import('./type/jumper').JumperG['watch'] ###
  watch: ->

    interval = 300
    token = 'jumper/watch'

    Client.on 'idle', -> Timer.remove token
    Client.on 'activate', => Timer.loop token, interval, @check

Jumper = new JumperG()