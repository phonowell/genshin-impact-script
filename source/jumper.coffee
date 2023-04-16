# @ts-check

class JumperG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/jumper').JumperG['namespace'] ###
    @namespace = 'jumper'

    ###* @type import('./type/jumper').JumperG['tsJump'] ###
    @tsJump = 0

  ###* @type import('./type/jumper').JumperG['break'] ###
  break: ->
    unless Config.get 'misc/use-better-jump' then return
    unless State.is 'frozen' then return
    @jump()

  ###* @type import('./type/jumper').JumperG['init'] ###
  init: ->

    @on 'jump:start', =>
      unless State.is 'free' then return
      @tsJump = $.now()

    @on 'jump:end', =>

      unless State.is 'free' then return

      now = $.now()
      diff = now - @tsJump
      @tsJump = now

      unless diff < 350 then return
      Timer.add 'jumper/jump', 350 - diff, @jump

    Client.useChange [Config, Scene], ->
      unless Config.get 'misc/use-better-jump' then return false
      unless Scene.is 'not-domain' then return false
      return true
    , =>
      @registerEvent 'jump', 'space'
      return =>
        @unregisterEvent 'jump', 'space'
        Timer.remove 'jumper/jump'

  ###* @type import('./type/jumper').JumperG['jump'] ###
  jump: ->
    $.press 'space'
    @tsJump = $.now()
    return

# @ts-ignore
Jumper = new JumperG()