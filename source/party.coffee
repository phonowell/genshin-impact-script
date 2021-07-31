# function

class PartyX extends EmitterShellX

  current: 0
  isBusy: false
  listMember: ['']
  name: ''
  tsSwitch: 0

  constructor: ->
    super()

    @on 'change', =>
      console.log "Party: #{$.join ($.tail @listMember), ', '}"
      $.press 1
      @switchTo 1

    @on 'switch', (n) =>

      name = @listMember[n]
      nameNew = name
      nameOld = @listMember[@current]
      unless nameNew then nameNew = 'unknown'
      unless nameOld then nameOld = 'unknown'
      console.log "Party: [#{@current}]#{nameOld} -> [#{n}]#{nameNew}"

      @current = n
      @name = nameNew
      @tsSwitch = $.now()

      if nameOld == 'tartaglia' and nameNew != 'tartaglia'
        skillTimer.endTartaglia()

    $.on 'f12', @scan

  checkCurrentAs: (n, callback) ->

    name = @listMember[n]
    unless name
      if callback then callback()
      return

    $.clearTimeout timer.checkCurrentFromParty
    timer.checkCurrentFromParty = $.setTimeout =>
      [pointA, pointB] = @makeRange n, 'narrow'
      point = $.findColor 0x323232, pointA, pointB
      if point[0] * point[1] > 0
        $.beep()
        return
      if callback then callback()
    , 200

  getIndexBy: (name) ->
    unless @has name then return 0
    for n in [1, 2, 3, 4]
      if @listMember[n] == name
        return n

  getNameViaPosition: (n) ->

    [pointA, pointB] = @makeRange n

    for name, char of Character.data

      if @has name then continue
      unless char.color then continue

      point = $.findColor char.color, pointA, pointB
      unless point[0] * point[1] > 0 then continue

      return name

    return ''

  has: (name) -> return $.includes @listMember, name

  makeRange: (n, isNarrow = false) ->

    if isNarrow
      start = client.point [96, 20 + 9 * (n - 1)]
      end = client.point [99, 20 + 9 * n]
      return [start, end]

    start = client.point [90, 20 + 9 * (n - 1)]
    end = client.point [96, 20 + 9 * n]
    return [start, end]

  scan: ->

    if Scene.name != 'normal' or Scene.isMulti
      $.beep()
      return

    if @isBusy then return
    @isBusy = true

    @listMember = ['']
    skillTimer.reset()
    hud.reset()

    for n in [1, 2, 3, 4]

      name = @getNameViaPosition n
      $.push @listMember, name

      char = Character.data[name]
      if Config.data.region == 'en'
        hud.render n, char.nameEN
      else hud.render n, char.nameCN

    @emit 'change'
    @isBusy = false

  switchTo: (n) ->
    unless n then return
    @checkCurrentAs n, => @emit 'switch', n, @current

  switchBy: (name) -> @switchTo @getIndexBy name

# execute
party = new PartyX()