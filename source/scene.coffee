# @ts-check

class SceneG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/scene').SceneG['cache'] ###
    @cache = {}
    ###* @type import('./type/scene').SceneG['isFrozen'] ###
    @isFrozen = false
    ###* @type import('./type/scene').SceneG['list'] ###
    @list = []
    ###* @type import('./type/scene').SceneG['tsChange'] ###
    @tsChange = 0

  ###* @type import('./type/scene').SceneG['aboutHalfMenu'] ###
  aboutHalfMenu: ->
    unless @checkIsHalfMenu() then return []
    list = @makeListName 'half-menu'

    if @checkIsChat()
      $.push list, 'chat'
      return list

    return list

  ###* @type import('./type/scene').SceneG['aboutMenu'] ###
  aboutMenu: ->
    unless @checkIsMenu() then return []
    list = @makeListName 'menu'

    if @checkIsMap()
      $.push list, 'map'
      return list

    if @checkIsParty()
      $.push list, 'party'
      return list

    if @checkIsPlaying()
      $.push list, 'playing'
      return list

    return list

  ###* @type import('./type/scene').SceneG['aboutNormal'] ###
  aboutNormal: ->
    unless @checkIsNormal() then return []
    list = @makeListName 'normal'

    if @checkIsBusy() then $.push list, 'busy'
    if @checkIsDomain() then $.push list, 'domain'
    if @checkIsMulti() then $.push list, 'multi'

    return list

  ###* @type import('./type/scene').SceneG['check'] ###
  check: ->

    if @checkIsLoading() then return ['loading']

    list = @aboutMenu()
    if $.length list then return list

    list = @aboutHalfMenu()
    if $.length list then return list

    list = @aboutNormal()
    if $.length list then return list

    if @checkIsEvent() then return ['event']
    if @checkIsMiniMenu() then return ['mini-menu']

    return []

  ###* @type import('./type/scene').SceneG['checkIsBusy'] ###
  checkIsBusy: -> not ColorManager.findAll [0xFFFFFF, 0x323232], [
    '94%', '80%'
    '95%', '82%'
  ]

  ###* @type import('./type/scene').SceneG['checkIsChat'] ###
  checkIsChat: -> @throttle 'chat', 2e3, ->
    ColorManager.findAll [0x3B4255, 0xECE5D8], [
      '58%', '2%'
      '60%', '6%'
    ]

  ###* @type import('./type/scene').SceneG['checkIsDomain'] ###
  checkIsDomain: -> @throttle 'domain', 2e3, ->
    ColorManager.findAll 0xFFFFFF, [
      '1%', '9%'
      '3%', '13%'
    ]

  ###* @type import('./type/scene').SceneG['checkIsEvent'] ###
  checkIsEvent: -> ColorManager.findAll 0xFFC300, [
    '45%', '79%'
    '55%', '82%'
  ]

  ###* @type import('./type/scene').SceneG['checkIsHalfMenu'] ###
  checkIsHalfMenu: -> ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '1%', '3%'
    '3%', '6%'
  ]

  ###* @type import('./type/scene').SceneG['checkIsLoading'] ###
  checkIsLoading: -> @throttle 'loading', 2e3, ->
    $.includes [0xFFFFFF, 0x000000, 0x1C1C22], ColorManager.get ['0%', '0%']

  ###* @type import('./type/scene').SceneG['checkIsMap'] ###
  checkIsMap: -> @throttle 'map', 1e3, ->
    ColorManager.findAll 0xEDE5DA, [
      '1%', '38%'
      '2%', '40%'
    ]

  ###* @type import('./type/scene').SceneG['checkIsMenu'] ###
  checkIsMenu: -> ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '95%', '3%'
    '97%', '6%'
  ]

  ###* @type import('./type/scene').SceneG['checkIsMiniMenu'] ###
  checkIsMiniMenu: -> ColorManager.findAll 0xECE5D8, [
    '97%', '1%'
    '98%', '5%'
  ]

  ###* @type import("./type/scene").SceneG['checkIsMulti'] ###
  checkIsMulti: -> @throttle 'multi', 5e3, ->
    !!ColorManager.findAny [0x006699, 0x408000], [
      '18%', '2%'
      '20%', '6%'
    ]

  ###* @type import('./type/scene').SceneG['checkIsNormal'] ###
  checkIsNormal: ->
    if ColorManager.findAll 0xFFFFFF, [
      '95%', '2%'
      '97%', '6%'
    ] then return true
    if ColorManager.findAll 0xFFFFFF, [
      '2%', '17%'
      '4%', '21%'
    ] then return true
    return false

  ###* @type import('./type/scene').SceneG['checkIsParty'] ###
  checkIsParty: -> @throttle 'party', 5e3, ->
    ColorManager.findAll 0xFFFFFF, [
      '41%', '3%'
      '59%', '6%'
    ]

  ###* @type import('./type/scene').SceneG['checkIsPlaying'] ###
  checkIsPlaying: -> @throttle 'playing', 5e3, ->
    ColorManager.findAll [0xFFFFFF, 0xFFE92C], [
      '9%', '2%'
      '11%', '6%'
    ]

  ###* @type import('./type/scene').SceneG['freezeAs'] ###
  freezeAs: (listName, time) ->
    @isFrozen = true
    @list = listName
    @emit 'change'
    Timer.add 'scene/freeze-as', time, => @isFrozen = false
    return

  ###* @type import('./type/scene').SceneG['init'] ###
  init: ->
    @on 'change', =>
      unless $.length @list
        console.log 'scene: unknown'
      else console.log "scene: #{$.join @list, ', '}"
      @tsChange = $.now()

  ###* @type import('./type/scene').SceneG['is'] ###
  is: (names...) ->

    @update()
    if $.includes names, 'unknown' then return ($.length @list) == 0

    for name in names

      if $.startsWith name, 'not-'
        name2 = $.subString name, 4
        if $.includes @list, name2 then return false
        continue

      unless $.includes @list, name then return false
      continue

    return true

  ###* @type import('./type/scene').SceneG['makeListName'] ###
  makeListName: (names...) -> names

  ###* @type import('./type/scene').SceneG['throttle'] ###
  throttle: (name, time, callback) ->
    unless Timer.checkInterval "scene/#{name}", time
      return @cache[name]
    return @cache[name] = callback()

  ###* @type import('./type/scene').SceneG['update'] ###
  update: ->

    if @isFrozen then return
    if $.includes @list, 'fishing' then return

    list = @check()
    if $.eq list, @list then return
    @list = list
    @emit 'change'

Scene = new SceneG()