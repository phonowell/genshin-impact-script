### interface
type Fn = () => unknown
type Position = 1 | 2 | 3 | 4
type Range = [[number, number], [number, number]]
###

# function

class PartyX extends EmitterShellX

  current: 0
  isBusy: false
  listMember: ['']
  name: ''
  total: 4
  tsSwitch: 0

  # ---

  constructor: ->
    super()

    @on 'change', => console.log "party: #{$.join ($.tail @listMember), ', '}"

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
        SkillTimer.endTartaglia()

      {audio} = Character.data[@name]
      if audio then Timer.add 200, -> Sound.play audio

    $.on 'f12', @scan

  # checkCurrent(n: Position): boolean
  checkCurrent: (n) ->
    [start, end] = @makeRange n, 'narrow'
    [x, y] = ColorManager.find 0x323232, start, end
    return !(x * y > 0)

  # checkCurrentAs(n: Position, callback: Fn): void
  checkCurrentAs: (n, callback) ->

    Timer.remove 'party/check'
    delay = 300

    if Config.data.weakNetwork
      Timer.add 'party/check', delay, callback
      return

    name = @listMember[n]
    unless name
      Timer.add 'party/check', delay, callback
      return

    Timer.add 'party/check', delay, =>
      unless @checkCurrent n
        Sound.beep()
        return
      if callback then callback()

  # countMember(): void
  countMember: ->

    start = Point.new ['97%', '15%']
    end = Point.new ['98%', '65%']

    result = 0

    for n in [1, 2, 3, 4, 5]
      [x, y] = ColorManager.find 0xFFFFFF, start, end
      unless x * y > 0 then break
      result++
      start = [
        Point.vw 95
        y + Point.vw 5
      ]

    @total = result + 1

  # getIndexBy(name: string): Position
  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4]
      if @listMember[n] == name
        return n

  # getNameViaPosition(n: Position): string
  getNameViaPosition: (n) ->

    [start, end] = @makeRange n

    for name, char of Character.data

      if @has name then continue
      unless char.color then continue

      for color in char.color

        [x, y] = ColorManager.find color, start, end
        unless x * y > 0 then continue

        return name

    return ''

  # has(name: string): boolean
  has: (name) -> return $.includes @listMember, name

  # makeRange(n: Position, isNarrow: boolean = false): Range
  makeRange: (n, isNarrow = false) ->

    top = [37, 32, 28, 23][@total - 1] + 9 * (n - 1)

    left = 90
    right = 96
    if isNarrow
      left = 96
      right = 99

    start = Point.new ["#{left}%", "#{top - 4}%"]
    end = Point.new ["#{right}%", "#{top + 4}%"]

    return [start, end]

  # scan(): void
  scan: ->

    if Scene.name != 'normal'
      Sound.beep()
      return

    if @isBusy
      Sound.beep()
      return
    @isBusy = true

    @countMember()

    @current = 0
    @listMember = ['']
    @name = ''

    SkillTimer.reset()
    Hud.reset()

    for n in [1, 2, 3, 4]
      if n > @total then break

      name = @getNameViaPosition n
      $.push @listMember, name

      char = Character.data[name]
      nameOutput = char.name

      if !@current and @checkCurrent n
        @current = n
        @name = name
        nameOutput = "#{nameOutput} 💬"

      Hud.render n, nameOutput

    @emit 'change'

    unless @current
      $.press 1
      @switchTo 1

    Timer.add 200, => @isBusy = false

  # switchTo(n: Position): void
  switchTo: (n) ->
    unless n then return
    unless n <= @total then return
    @checkCurrentAs n, => @emit 'switch', n, @current

  # switchBy(name: string): void
  switchBy: (name) -> @switchTo @getIndexBy name

# execute
Party = new PartyX()