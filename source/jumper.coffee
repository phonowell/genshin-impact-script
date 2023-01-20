# @ts-check

class JumperG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/jumper').JumperG['isBreaking'] ###
    @isBreaking = false
    ###* @type import('./type/jumper').JumperG['tsJump'] ###
    @tsJump = 0

  ###* @type import('./type/jumper').JumperG['check'] ###
  check: ->

    if @isBreaking then return

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

    unless (Config.get 'better-jump/enable') then return

    Scene.useExact ['free', 'not-domain'], =>

      @registerEvent 'jump', 'space'

      @on 'jump:start', => @tsJump = $.now()

      @on 'jump:end', =>

        now = $.now()
        diff = now - @tsJump
        @tsJump = now

        unless diff < 350 then return
        Timer.add 'jumper/jump', 350 - diff, @jump

      return =>
        @unregisterEvent 'jump', 'space'
        @off 'jump:start'
        @off 'jump:end'

    @watch()

  ###* @type import('./type/jumper').JumperG['jump'] ###
  jump: ->
    $.press 'space'
    @tsJump = $.now()
    return

  ###* @type import('./type/jumper').JumperG['watch'] ###
  watch: -> Scene.useExact ['normal'], =>
    unless (Status2.has 'cryo') or (Status2.has 'hydro') then return $.noop
    [interval, token] = [300, 'jumper/watch']
    Timer.loop token, interval, @check
    return -> Timer.remove token

Jumper = new JumperG()