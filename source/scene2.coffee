# @ts-check

class Scene2G

  ###* @type import('./type/scene2').Scene2G['aboutHalfMenu'] ###
  aboutHalfMenu: ->
    unless @checkIsHalfMenu() then return []
    list = @makeListName 'half-menu'

    if @checkIsChat()
      $.push list, 'chat'
      return list

    return list

  ###* @type import('./type/scene2').Scene2G['aboutMenu'] ###
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

  ###* @type import('./type/scene2').Scene2G['aboutNormal'] ###
  aboutNormal: ->
    unless @checkIsNormal() then return []
    list = @makeListName 'normal'

    if @checkIsBusy()
      $.push list, 'busy'
      if @checkIsAiming() then $.push list, 'aiming'
    if @checkIsDomain() then $.push list, 'domain'
    if @checkIsMulti() then $.push list, 'multi'

    return list

  ###* @type import('./type/scene2').Scene2G['check'] ###
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

  ###* @type import('./type/scene2').Scene2G['checkIsAiming'] ###
  checkIsAiming: ->
    unless (Character.get Party.name, 'weapon') == 'bow' then return false
    return (ColorManager.get ['50%', '50%']) == 0xFFFFFF

  ###* @type import('./type/scene2').Scene2G['checkIsBusy'] ###
  checkIsBusy: -> not ColorManager.findAll [0xFFFFFF, 0x323232], [
    '94%', '80%'
    '95%', '82%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsChat'] ###
  checkIsChat: -> @throttle 'chat', 2e3, ->
    ColorManager.findAll [0x3B4255, 0xECE5D8], [
      '58%', '2%'
      '60%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsDomain'] ###
  checkIsDomain: -> @throttle 'domain', 2e3, ->
    ColorManager.findAll 0xFFFFFF, [
      '1%', '9%'
      '3%', '13%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsEvent'] ###
  checkIsEvent: -> ColorManager.findAll 0xFFC300, [
    '45%', '79%'
    '55%', '82%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsHalfMenu'] ###
  checkIsHalfMenu: -> ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '1%', '3%'
    '3%', '6%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsLoading'] ###
  checkIsLoading: -> @throttle 'loading', 2e3, ->
    $.includes [0xFFFFFF, 0x000000, 0x1C1C22], ColorManager.get ['0%', '50%']

  ###* @type import('./type/scene2').Scene2G['checkIsMap'] ###
  checkIsMap: -> @throttle 'map', 1e3, ->
    ColorManager.findAll 0xEDE5DA, [
      '1%', '38%'
      '2%', '40%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsMenu'] ###
  checkIsMenu: -> ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '95%', '3%'
    '97%', '6%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsMiniMenu'] ###
  checkIsMiniMenu: -> ColorManager.findAll 0xECE5D8, [
    '97%', '1%'
    '98%', '5%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsMulti'] ###
  checkIsMulti: -> @throttle 'multi', 5e3, ->
    !!ColorManager.findAny [0x006699, 0x408000], [
      '18%', '2%'
      '20%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsNormal'] ###
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

  ###* @type import('./type/scene2').Scene2G['checkIsParty'] ###
  checkIsParty: -> @throttle 'party', 5e3, ->
    ColorManager.findAll 0xFFFFFF, [
      '41%', '3%'
      '59%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsPlaying'] ###
  checkIsPlaying: -> @throttle 'playing', 5e3, ->
    ColorManager.findAll [0xFFFFFF, 0xFFE92C], [
      '9%', '2%'
      '11%', '6%'
    ]

  ###* necessary for types, do not remove
  @type import('./type/scene2').Scene2G['makeListName']
  ###
  makeListName: (names...) -> names

  ###* @type import('./type/scene2').Scene2G['throttle'] ###
  throttle: (name, time, callback) ->
    unless Timer.checkInterval "scene2/#{name}", time
      return Scene.cache[name]
    return Scene.cache[name] = callback()

Scene2 = new Scene2G()