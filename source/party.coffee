### interface
type Fn = () => unknown
type Range = [[number, number], [number, number]]
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

      name = @listMember[n]
      nameNew = name
      nameOld = @listMember[@current]
      unless nameNew then nameNew = 'unknown'
      unless nameOld then nameOld = 'unknown'
      console.log "party: [#{@current}]#{nameOld} -> [#{n}]#{nameNew}"

      @current = n
      @name = nameNew
      @tsSwitch = $.now()

      if nameOld == 'tartaglia' and nameNew != 'tartaglia'
        Skill.endTartaglia()

    $.on 'f12', @scan
    $.on 'alt + f12', =>
      @reset()
      Hud.render 0, 'party reset'

  # addBuff(name: string): void
  addBuff: (name) ->
    if $.includes @listBuff, name then return
    $.push @listBuff, name

  # checkCurrent(n: Slot): boolean
  checkCurrent: (n) ->
    [start, end] = @makeRange n, 'narrow'
    p = ColorManager.find 0x323232, start, end
    return !Point.isValid p

  # checkCurrentAs(n: Slot, callback: Fn): void
  checkCurrentAs: (n, callback) ->

    delay = 100
    interval = 100
    limit = 500
    token = 'party/check-current-as'

    Timer.remove token

    name = @listMember[n]
    unless name
      Timer.add token, interval, callback
      return

    tsCheck = $.now()
    Timer.add token, delay, => Timer.loop token, interval, =>

      if @checkCurrent n
        Timer.remove token
        callback()
        console.log "#{token}: #{name} passed"
        return

      unless $.now() - tsCheck >= limit then return
      Timer.remove token

      Sound.beep()
      console.log "#{token}: #{name} failed"

  # countMember(): void
  countMember: ->

    start = Point.new ['97%', '15%']
    end = Point.new ['98%', '65%']

    result = 0

    for n in [1, 2, 3, 4, 5]
      [x, y] = ColorManager.find 0xFFFFFF, start, end
      unless Point.isValid [x, y] then break
      result++
      start = [
        Point.vw 95
        y + Point.vw 5
      ]

    @total = result + 1

  # getIndexBy(name: string): Slot
  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4, 5]
      if @listMember[n] == name
        return n

  # getNameViaSlot(n: Slot): string
  getNameViaSlot: (n) ->

    [start, end] = @makeRange n

    for name, char of Character.data

      if @has name then continue
      unless char.color then continue

      for group in char.color
        count = 0
        for color in group
          unless Point.isValid ColorManager.find color, start, end then break
          count++
        if count >= 3 then return name

    return ''

  # has(name: string): boolean
  has: (name) -> return $.includes @listMember, name

  # hasBuff(name: string): boolean
  hasBuff: (name) -> return $.includes @listBuff, name

  # makeRange(n: Slot, isNarrow: boolean = false): Range
  makeRange: (n, isNarrow = false) ->

    vTop = [37, 32, 28, 23, 19][@total - 1] + 9 * (n - 1)

    left = 90
    right = 96
    if isNarrow
      left = 96
      right = 99

    start = Point.new ["#{left}%", "#{vTop - 4}%"]
    end = Point.new ["#{right}%", "#{vTop + 4}%"]

    return [start, end]

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

      name = @getNameViaSlot n
      $.push @listMember, name

      nameOutput = Character.get name, 'name'

      if !@current and @checkCurrent n
        @current = n
        @name = name
        nameOutput = "#{nameOutput} 🎮"

      Hud.render n, nameOutput

    @emit 'change'

    unless @current
      $.press 1
      @switchTo 1

    Indicator.setCost token, 'end'
    console.log "#{token}: completed in #{Indicator.getCost token} ms"
    Timer.add 200, => @isBusy = false

  # switchTo(n: Slot): void
  switchTo: (n) ->
    unless n then return
    unless n <= @total then return
    @checkCurrentAs n, => @emit 'switch', n, @current

  # switchBy(name: string): void
  switchBy: (name) -> @switchTo @getIndexBy name

# execute
Party = new Party()