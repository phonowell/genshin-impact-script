# @ts-check

class Party2G extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/party2').Party2G['namespace'] ###
    @namespace = 'party-2'

  ###* @type import('./type/party2').Party2G['aboutPress'] ###
  aboutPress: ->

    @on 'press:start', (key) =>

      unless State.is 'free' then return

      Timer.remove 'party2/is-current-as'
      Timer.remove 'party2/wait-for'

      n = $.toNumber key
      unless Party.isSlotValid n then return

      @isCurrentAs n, =>
        Party.emit 'switch', n
        @emit 'switch:start'

    @on 'press:end', (key) =>

      unless State.is 'free' then return

      n = $.toNumber key
      unless Party.isSlotValid n then return

      @waitFor n, => @emit 'switch:end'

    Scene.useExact ['single'], =>

      for slot in Party.listSlot
        @registerEvent 'press', $.toString slot

      return =>
        for slot in Party.listSlot
          @unregisterEvent 'press', $.toString slot

  ###* @type import('./type/party2').Party2G['aboutPressAlt'] ###
  aboutPressAlt: -> Scene.useExact ['single'], ->

    for slot in Party.listSlot
      $.on "alt + #{slot}", ->

        unless Party.size
          $.press "alt + #{slot}"
          return

        unless State.is 'free' then return

        Skill.switchQ slot

    return ->
      for slot in Party.listSlot
        $.off "alt + #{slot}"

  ###* @type import('./type/party2').Party2G['aboutSwitch'] ###
  aboutSwitch: ->

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

  ###* @type import('./type/party2').Party2G['init'] ###
  init: ->

    return

    unless Config.get 'misc/use-skill-timer' then return
    @aboutPress()
    @aboutPressAlt()
    @aboutSwitch()
    @watch()

  ###* @type import('./type/party2').Party2G['isCurrentAs'] ###
  isCurrentAs: (slot, callback) ->

    [delay, limit, interval, token] = [100, 500, 25, 'party2/is-current-as']
    if slot == Party.current then delay = 25

    tsCheck = $.now()
    Timer.add token, delay, -> Timer.loop token, interval, ->

      diff = $.now() - tsCheck

      if Party.isCurrent slot
        Timer.remove token
        callback()
        console.log "##{token}: [#{slot}] passed in #{diff} ms"
        return

      unless diff > limit then return
      Timer.remove token
      console.log "##{token}: [#{slot}] failed after #{diff} ms"

      # @retry slot

  ###* @type import('./type/party2').Party2G['retry'] ###
  retry: (slot) ->
    token = 'party2/retry'
    # $.press slot
    $.trigger "#{slot}:down"
    Timer.add token, 50, -> $.trigger "#{slot}:up"

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
  watch: -> Scene.useExact ['normal'], =>

    [interval, token] = [200, 'party2/watch']

    Timer.loop token, interval, =>

      unless Party.size then return
      unless State.is 'free', 'single' then return
      unless $.now() - Party.tsSwitch > 1e3 then return
      if Party.isCurrent Party.current then return

      slot = Party.findCurrent()
      unless Party.isSlotValid slot then return
      if slot == Party.current then return

      Sound.beep()
      console.log '#party2/watch:', 'should be', Party.current, 'but got', slot

      @retry slot

    return -> Timer.remove token

# @ts-ignore
Party2 = new Party2G()