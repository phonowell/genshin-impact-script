# @ts-check

class PartyG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/party').PartyG['current'] ###
    @current = 0
    ###* @type import('./type/party').PartyG['list'] ###
    @list = [''] # '' is a placeholder, don't remove it
    ###* @type import('./type/party').PartyG['listOnSwitch'] ###
    @listOnSwitch = []
    ###* @type import('./type/party').PartyG['listSlot'] ###
    @listSlot = [1, 2, 3, 4, 5]
    ###* @type import('./type/party').PartyG['name'] ###
    @name = ''
    ###* @type import('./type/party').PartyG['size'] ###
    @size = 0

    @aboutBinding1()
    @aboutBinding2()
    # @watch()

  ###* @type import('./type/party').PartyG['aboutBinding1'] ###
  aboutBinding1: ->

    for slot in @listSlot
      @registerEvent 'press', $.toString slot
      $.on "alt + #{slot}", =>
        unless @size
          $.press "alt + #{slot}"
          return
        Skill.switchQ slot

    @on 'press:start', (key) =>

      Timer.remove 'party/is-current-as'
      Timer.remove 'party/wait-for'

      unless Scene.is 'normal' then return

      n = $.toNumber key
      unless n <= @size then return

      @isCurrentAs n, =>
        @tsSwitch = $.now()
        @emit 'switch', n
        @emit 'switch:start'
      , -> Sound.beep 2

    @on 'press:end', (key) =>

      unless Scene.is 'normal' then return

      n = $.toNumber key
      unless n <= @size then return

      @waitFor n, => @emit 'switch:end'

    @on 'switch:start', =>
      onSwitch = @listOnSwitch[@current]
      unless onSwitch then return

      if onSwitch == 'e'
        $.trigger 'e:down'
        return

    @on 'switch:end', =>
      onSwitch = @listOnSwitch[@current]
      unless onSwitch then return

      if onSwitch == 'e'
        $.trigger 'e:up'
        return

      Tactic.start onSwitch, $.noop

  ###* @type import('./type/party').PartyG['aboutBinding2'] ###
  aboutBinding2: ->

    @on 'change', =>

      unless @size then return
      console.log "party/member: #{$.join ($.tail @list), ', '}"

      for name in @list

        unless name
          $.push @listOnSwitch, ''
          continue

        {onSwitch} = Character.get name
        unless onSwitch
          $.push @listOnSwitch, ''
          continue

        $.push @listOnSwitch, onSwitch
      console.log "party/on-switch: #{$.join ($.tail @listOnSwitch), ', '}"

      Buff.pick()

    @on 'switch', (n) =>

      last = @current
      @current = $.toNumber n

      nameLast = @list[last]
      @name = @list[@current]

      unless nameLast then nameLast = 'unknown'
      unless @name then @name = 'unknown'

      console.log $.join [
        'party:'
        "[#{last}]#{nameLast}"
        '->'
        "[#{@current}]#{@name}"
        @listOnSwitch[@current]
      ], ' '

      {typeE} = Character.get nameLast
      if typeE == 3 then Skill.endEAsType3 last

    $.on 'f12', =>
      @scan()
      Character.load()

    $.on 'alt + f12', =>
      @reset()
      @emit 'change'
      Hud.render 0, Dictionary.get 'party_is_cleared'

  ###* @type import('./type/party').PartyG['countMember'] ###
  countMember: ->

    a = Area.create [
      '97%', '15%'
      '98%', '65%'
    ]

    result = 0

    for n in @listSlot
      p = ColorManager.findAny 0xFFFFFF, a
      unless p then break
      result++
      a[1] = p[1] + Point.h '5%'

    @size = result + 1
    return

  # ###* @type import('./type/party').PartyG['findCurrent'] ###
  # findCurrent: ->
  #   for n in @listSlot
  #     unless @isCurrent n then continue
  #     return n
  #   return 0

  ###* @type import('./type/party').PartyG['getNameViaSlot'] ###
  getNameViaSlot: (n) ->

    a = @makeArea n, false

    for name, char of Character.data

      if @has name then continue
      unless char.color then continue

      for group in char.color
        count = 0
        for color in group
          unless Point.isValid ColorManager.find color, a then break
          count++
        if count >= 3 then return name

    return ''

  ###* @type import('./type/party').PartyG['has'] ###
  has: (name) -> $.includes @list, name

  ###* @type import('./type/party').PartyG['isCurrent'] ###
  isCurrent: (n) -> not ColorManager.findAll 0xFFFFFF, @makeArea n, true

  ###* @type import('./type/party').PartyG['isCurrentAs'] ###
  isCurrentAs: (n, cbDone, cbFail = undefined) ->
    [interval, limit, token] = [25, 500, 'party/is-current-as']

    tsCheck = $.now()
    Timer.loop token, interval, =>

      unless Scene.is 'normal' then return
      diff = $.now() - tsCheck

      if @isCurrent n
        Timer.remove token
        cbDone()
        console.log "#{token}: [#{n}] passed in #{diff} ms"
        return

      unless diff >= limit then return
      Timer.remove token
      if cbFail then cbFail()
      console.log "#{token}: [#{n}] failed after #{diff} ms"

  ###* @type import('./type/party').PartyG['makeArea'] ###
  makeArea: (n, isNarrow = false) ->

    top = [37, 32, 28, 23, 19][@size - 1] + 9 * (n - 1)

    [left, right] = [92, 96]
    if isNarrow then [left, right] = [96, 98]

    return [
      "#{left}%", "#{top - 5}%"
      "#{right}%", "#{top + 5}%"
    ]

  ###* @type import('./type/party').PartyG['reset'] ###
  reset: ->
    @current = 0
    @list = ['']
    @listOnSwitch = []
    @name = ''
    @size = 0
    return

  ###* @type import('./type/party').PartyG['scan'] ###
  scan: ->

    token = 'party/scan'
    Indicator.setCost token, 'start'

    unless Scene.is 'normal', 'not-busy', 'not-multi'
      Hud.render 0, Dictionary.get 'cannot_use_party_scanning'
      Sound.beep()
      return

    @reset()
    @countMember()

    Skill.reset()
    Hud.reset()

    for n in @listSlot
      if n > @size then break
      @scanSlot n

    @emit 'change'

    unless @current then $.trigger '1'

    Indicator.setCost token, 'end'
    console.log "#{token}: completed in #{Indicator.getCost token} ms"

  ###* @type import('./type/party').PartyG['scanSlot'] ###
  scanSlot: (n) ->

    name = @getNameViaSlot n
    $.push @list, name

    nameOutput = Dictionary.get name
    if ($.length nameOutput) > 10 and $.includes nameOutput, ' '
      nameOutput = $.replace nameOutput, ' ', '\n'

    # vision
    if name == 'traveler'
      vision = Character.get name, 'vision'
      if vision then nameOutput = "#{nameOutput} [#{vision}]"

    # constellation
    constellation = Character.get name, 'constellation'
    if constellation then nameOutput = "#{nameOutput} [C#{constellation}]"

    # current
    if !@current and @isCurrent n
      @current = n
      @name = name
      nameOutput = "#{nameOutput} 🎮"

    Hud.render n, nameOutput

  ###* @type import('./type/party').PartyG['waitFor'] ###
  waitFor: (n, callback) ->
    [interval, limit, token] = [25, 1e3, 'party/wait-for']
    tsCheck = $.now()
    Timer.loop token, interval, =>

      if Timer.has 'is-current-as' then return

      if n == @current
        Timer.remove token
        callback()
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

  # ###* @type import('./type/party').PartyG['watch'] ###
  # watch: ->
  #   [interval, token] = [1e3, 'party/watch']
  #   Client.on 'idle', -> Timer.remove token
  #   Client.on 'activate', => Timer.loop token, interval, =>
  #     if Timer.has 'party/is-current-as' then return
  #     if Timer.has 'party/wait-for' then return
  #     unless Scene.is 'normal', 'not-busy', 'not-multi' then return
  #     if @isCurrent @current then return

  #     n = @findCurrent()
  #     if n and n <= @size then @emit 'switch', n

Party = new PartyG()