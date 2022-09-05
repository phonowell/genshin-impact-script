### interface
type Slot = 1 | 2 | 3 | 4 | 5
###

# function

class Party extends EmitterShellX

  current: 0
  isBusy: false
  listBuff: []
  listMember: ['']
  name: ''
  total: 4
  tsSwitch: 0

  constructor: ->
    super()
    @init()

  # addBuff(name: string): void
  addBuff: (name) ->
    if $.includes @listBuff, name then return
    $.push @listBuff, name

  # checkCurrent(n: Slot): boolean
  checkCurrent: (n) -> return !ColorManager.findAll 0x323232, @makeArea n, 'narrow'

  # checkCurrentAs(n: Slot, callback: Fn): void
  checkCurrentAs: (n, callback) ->

    interval = 15
    limit = 500
    token = 'party/check-current-as'

    Timer.remove token

    name = @listMember[n]
    unless name
      Timer.add token, interval, callback
      return

    tsCheck = $.now()
    Timer.loop token, interval, =>

      diff = $.now() - tsCheck

      if @checkCurrent n
        Timer.remove token
        callback()
        console.log "#{token}: #{name} passed in #{diff} ms"
        return

      unless diff >= limit then return
      Timer.remove token

      Sound.beep()
      console.log "#{token}: #{name} failed after #{diff} ms"

  # countMember(): void
  countMember: ->

    start = ['97%', '15%']
    end = ['98%', '65%']

    result = 0

    for n in [1, 2, 3, 4, 5]
      p = ColorManager.findAny 0xFFFFFF, [start, end]
      unless p then break
      result++
      start[1] = p[1] + Point.h '5%'

    @total = result + 1

  # getIndexBy(name: string): Slot
  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4, 5]
      if @listMember[n] == name
        return n

  # getNameViaSlot(n: Slot): string
  getNameViaSlot: (n) ->

    a = @makeArea n

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

  # has(name: string): boolean
  has: (name) -> return $.includes @listMember, name

  # hasBuff(name: string): boolean
  hasBuff: (name) -> return $.includes @listBuff, name

  # init(): void
  init: ->

    @on 'change', =>
      console.log "party/member: #{$.join ($.tail @listMember), ', '}"
      n = 0
      for name in @listMember
        unless name then continue
        unless (Character.get name, 'vision') == 'anemo' then continue
        n++
      if n >= 2 then @addBuff 'impetuous winds'
      else @removeBuff 'impetuous winds'
      if ($.length @listBuff) then console.log "party/buff: #{$.join @listBuff, ','}"

    @on 'switch', (n) =>

      last = @current
      @current = n

      nameLast = @listMember[last]
      @name = @listMember[@current]

      unless nameLast then nameLast = 'unknown'
      unless @name then @name = 'unknown'

      console.log "party: [#{last}]#{nameLast} -> [#{@current}]#{@name}"

      @tsSwitch = $.now()

      {typeE} = Character.get nameLast
      if typeE == 2 then Skill.endEAsType2 last

    $.on 'f12', =>
      @scan()
      Character.load()

    $.on 'alt + f12', =>
      @reset()
      Hud.render 0, 'party reset'

  # makeArea(n: Slot, isNarrow: boolean = false): Area
  makeArea: (n, isNarrow = false) ->

    vTop = [37, 32, 28, 23, 19][@total - 1] + 9 * (n - 1)

    [left, right] = [92, 96]
    if isNarrow then [left, right] = [96, 98]

    return [
      "#{left}%", "#{vTop - 5}%"
      "#{right}%", "#{vTop + 5}%"
    ]

  # removeBuff(name: string): void
  removeBuff: (name) ->
    unless $.includes @listBuff, name then return
    @listBuff = $.filter @listBuff, (it) -> return it != name

  # reset(): void
  reset: ->
    @current = 0
    @listBuff = []
    @listMember = ['']
    @name = ''
    @total = 4

  # scan(): void
  scan: ->

    token = 'party/scan'
    Indicator.setCost token, 'start'

    unless Scene.is 'normal'
      Sound.beep()
      console.log "invalid scene: #{Scene.name}/#{Scene.subname}"
      return

    if @isBusy
      Sound.beep()
      return
    @isBusy = true

    @reset()
    @countMember()

    Skill.reset()
    Hud.reset()

    for n in [1, 2, 3, 4, 5]
      if n > @total then break
      @subScan n

    @emit 'change'

    unless @current
      $.press 1
      @switchTo 1

    Indicator.setCost token, 'end'
    console.log "#{token}: completed in #{Indicator.getCost token} ms"
    Timer.add 200, => @isBusy = false

  # subScan(n: number): void
  subScan: (n) ->

    name = @getNameViaSlot n
    $.push @listMember, name

    nameOutput = Character.get name, 'name'
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
    if !@current and @checkCurrent n
      @current = n
      @name = name
      nameOutput = "#{nameOutput} 🎮"

    Hud.render n, nameOutput

  # switchTo(n: Slot): void
  switchTo: (n) ->
    unless n then return
    unless n <= @total then return
    @checkCurrentAs n, => @emit 'switch', n, @current

  # switchBy(name: string): void
  switchBy: (name) -> @switchTo @getIndexBy name

# execute
Party = new Party()