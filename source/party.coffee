# @ts-check

class PartyG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/party').PartyG['current'] ###
    @current = 0
    ###* @type import('./type/party').PartyG['list'] ###
    @list = [''] # '' is a placeholder, don't remove it
    ###* @type import('./type/party').PartyG['listSlot'] ###
    @listSlot = [1, 2, 3, 4, 5]
    ###* @type import('./type/party').PartyG['name'] ###
    @name = ''
    ###* @type import('./type/party').PartyG['size'] ###
    @size = 0
    ###* @type import('./type/party').PartyG['tsSwitch'] ###
    @tsSwitch = 0

  ###* @type import('./type/party').PartyG['clear'] ###
  clear: ->
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

  ###* @type import('./type/party').PartyG['findCurrent'] ###
  findCurrent: ->
    for n in @listSlot
      unless @isCurrent n then continue
      return n
    return 0

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

  ###* @type import('./type/party').PartyG['init'] ###
  init: ->

    @on 'change', =>

      unless @size then return

      list = $.tail @list
      if $.includes list, '' then Sound.beep()
      console.log "#party/member: #{$.join list, ', '}"

      Buff.update()

    @on 'switch', (key) =>

      slot = $.toNumber key
      unless @isSlotValid slot then return

      last = @current
      @current = slot

      nameLast = @list[last]
      @name = @list[@current]

      unless nameLast then nameLast = 'unknown'
      unless @name then @name = 'unknown'

      @tsSwitch = $.now()

      console.log $.join [
        '#party:'
        "[#{last}]#{nameLast}"
        '->'
        "[#{@current}]#{@name}"
      ], ' '

      {typeE} = Character.get nameLast
      if typeE == 3 then Skill.endEAsType3 last

    Scene.useExact ['single'], =>

      $.on 'f12', =>

        unless State.is 'free'
          Sound.beep()
          Hud.render 0, Dictionary.get 'cannot_use_party_scanning'
          return

        Character.load()
        @scan()

      return -> $.off 'f12'

    Scene.useExact ['normal'], =>
      $.on 'alt + f12', @clear
      return -> $.off 'alt + f12'

    # auto clear/scan party
    do addListener = =>
      token = 'party/addListener'
      Timer.loop token, 1e3, =>

        if Party.size
          Timer.remove token
          return

        unless Scene.is 'single' then return
        unless State.is 'free' then return
        @scan()

    Client.useChange [Scene], ->
      if Scene.is 'party' then return true
      if Scene.is 'normal', 'not-single' then return true
      return false
    , =>
      @clear()
      return addListener

  ###* @type import('./type/party').PartyG['isCurrent'] ###
  isCurrent: (n) ->

    unless Scene.is 'normal' then return false

    if ColorManager.findAll [0xFFFFFF, 0x323232], @makeArea n, true
      return false

    return true

  ###* @type import("./type/party").PartyG['isSlotValid'] ###
  isSlotValid: (slot) ->
    unless slot > 0 then return false
    unless slot <= @size then return false
    return true

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
    console.log "##{token}: completed in #{Indicator.getCost token} ms"

  ###* @type import('./type/party').PartyG['scanSlot'] ###
  scanSlot: (n) ->

    name = @getNameViaSlot n
    $.push @list, name

    nameOutput = Dictionary.get name
    unless name then nameOutput = Dictionary.get 'unknown_character'
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

# @ts-ignore
Party = new PartyG()