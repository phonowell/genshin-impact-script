# @ts-check

class Party2G extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/party2').Party2G['isPressed2'] ###
    @isPressed2 = false
    ###* @type import('./type/party2').Party2G['tsSwitch'] ###
    @tsSwitch = 0

  ###* @type import('./type/party2').Party2G['aboutPress'] ###
  aboutPress: -> Scene.useEffect =>

    for slot in Party.listSlot
      @registerEvent 'press', $.toString slot

    @on 'press:start', (key) =>

      Timer.remove 'party2/is-current-as'
      Timer.remove 'party2/wait-for'

      if @isPressed2 then return
      @isPressed2 = true

      now = $.now()
      unless now - @tsSwitch > 900 then return
      @tsSwitch = now

      n = $.toNumber key
      unless Party.isSlotValidate n then return

      @isCurrentAs n, =>
        Party.emit 'switch', n
        @emit 'switch:start'
      , -> Sound.beep 2

    @on 'press:end', (key) =>

      unless @isPressed2 then return
      @isPressed2 = false

      n = $.toNumber key
      unless Party.isSlotValidate n then return

      @waitFor n, => @emit 'switch:end'

    return =>
      for slot in Party.listSlot
        @unregisterEvent 'press', $.toString slot
      @off 'press:start'
      @off 'press:end'

  , ['normal', 'not-busy']

  ###* @type import('./type/party2').Party2G['aboutPressAlt'] ###
  aboutPressAlt: -> Scene.useEffect ->

    for slot in Party.listSlot
      $.on "alt + #{slot}", ->
        unless Party.size
          $.press "alt + #{slot}"
          return
        Skill.switchQ slot

    return ->
      for slot in Party.listSlot
        $.off "alt + #{slot}"

  , ['normal', 'not-busy']

  ###* @type import('./type/party2').Party2G['aboutSwitch'] ###
  aboutSwitch: -> Scene.useEffect =>

    @on 'switch:start', ->

      onSwitch = Character.get Party.name, 'onSwitch'
      unless onSwitch then return

      if onSwitch == 'e'
        $.trigger 'e:down'
        return

    @on 'switch:end', ->

      onSwitch = Character.get Party.name, 'onSwitch'
      unless onSwitch then return

      if onSwitch == 'e'
        $.trigger 'e:up'
        return

      Tactic.start onSwitch, $.noop

    return =>
      @off 'switch:start'
      @off 'switch:end'

  , ['normal', 'not-busy']

  ###* @type import('./type/party2').Party2G['init'] ###
  init: ->
    unless Config.get 'skill-timer/enable' then return
    @aboutPress()
    @aboutPressAlt()
    @aboutSwitch()
    @watch()

  ###* @type import('./type/party2').Party2G['isCurrentAs'] ###
  isCurrentAs: (slot, cbDone, cbFail = undefined) ->
    [delay, limit, interval, token] = [100, 500, 25, 'party2/is-current-as']
    if slot == Party.current then delay = 25

    tsCheck = $.now()
    Timer.add token, delay, -> Timer.loop token, interval, ->

      diff = $.now() - tsCheck

      if Party.isCurrent slot
        Timer.remove token
        cbDone()
        console.log "##{token}: [#{slot}] passed in #{diff} ms"
        return

      unless diff > limit then return
      Timer.remove token
      if cbFail then cbFail()
      console.log "##{token}: [#{slot}] failed after #{diff} ms"

  ###* @type import('./type/party2').Party2G['waitFor'] ###
  waitFor: (slot, callback) ->
    [limit, interval, token] = [500, 15, 'party2/wait-for']

    tsCheck = $.now()
    Timer.loop token, interval, ->

      if Timer.has 'party2/is-current-as' then return

      if slot == Party.current
        Timer.remove token
        callback()
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

  ###* @type import('./type/party2').Party2G['watch'] ###
  watch: -> Scene.useEffect =>

    [interval, token] = [1e3, 'party2/watch']

    Timer.loop token, interval, =>

      unless Party.size then return
      unless Scene.is 'normal', 'not-busy' then return
      unless $.now() - @tsSwitch > 1e3 then return
      if Party.isCurrent Party.current then return

      slot = Party.findCurrent()
      unless Party.isSlotValidate slot then return
      if slot == Party.current then return

      $.beep()
      console.log Party.current, slot

      Party.emit 'switch', slot

    return -> Timer.remove token

  , ['normal', 'not-busy']

Party2 = new Party2G()