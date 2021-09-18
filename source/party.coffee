# function

class PartyX extends EmitterShellX

  current: 0
  isBusy: false
  listMember: ['']
  name: ''
  tsSwitch: 0

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

    $.on 'f12', @scan

  checkCurrent: (n) ->
    [start, end] = @makeRange n, 'narrow'
    [x, y] = $.findColor 0x323232, start, end
    return !(x * y > 0)

  checkCurrentAs: (n, callback) ->

    $.clearTimeout timer.checkCurrentFromParty
    delay = 200

    if Config.data.performance == 'low'
      timer.checkCurrentFromParty = $.setTimeout callback, delay
      return

    name = @listMember[n]
    unless name
      timer.checkCurrentFromParty = $.setTimeout callback, delay
      return

    if Config.data.performance == 'medium'
      delay = 300

    timer.checkCurrentFromParty = $.setTimeout =>
      unless @checkCurrent n
        $.beep()
        return
      if callback then callback()
    , delay

  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4]
      if @listMember[n] == name
        return n

  getNameViaPosition: (n) ->

    [start, end] = @makeRange n

    for name, char of Character.data

      if @has name then continue
      unless char.color then continue

      for color in char.color

        [x, y] = $.findColor color, start, end
        unless x * y > 0 then continue

        return name

    return ''

  has: (name) -> return $.includes @listMember, name

  makeRange: (n, isNarrow = false) ->

    if isNarrow
      start = Client.point [96, 20 + 9 * (n - 1)]
      end = Client.point [99, 20 + 9 * n]
      return [start, end]

    start = Client.point [90, 20 + 9 * (n - 1)]
    end = Client.point [96, 20 + 9 * n]
    return [start, end]

  scan: ->

    if Scene.name != 'normal' or Scene.isMulti
      $.beep()
      return

    if @isBusy
      $.beep()
      return
    @isBusy = true

    @current = 0
    @listMember = ['']
    @name = ''

    SkillTimer.reset()
    Hud.reset()

    for n in [1, 2, 3, 4]

      name = @getNameViaPosition n
      $.push @listMember, name

      char = Character.data[name]
      nameOutput = char.nameEN
      if Config.data.region == 'cn'
        nameOutput = char.nameCN

      if !@current and @checkCurrent n
        @current = n
        @name = name
        nameOutput = "#{nameOutput} 💬"

      Hud.render n, nameOutput

    @emit 'change'

    unless @current
      $.press 1
      @switchTo 1

    $.setTimeout (=> @isBusy = false), 200

  switchTo: (n) ->
    unless n then return
    @checkCurrentAs n, => @emit 'switch', n, @current

  switchBy: (name) -> @switchTo @getIndexBy name

# execute
Party = new PartyX()