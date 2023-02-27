# @ts-check

class Scene2G

  constructor: ->

    ### @type import('./type/scene2').Scene2G['cache'] ###
    @cache = {
      last: 'unknown'
    }
    ### @type import('./type/scene2').Scene2G['mapAbout'] ###
    @mapAbout = {
      event: @aboutEvent
      'half-menu': @aboutHalfMenu
      loading: @aboutLoading
      menu: @aboutMenu
      'mini-menu': @aboutMiniMenu
      normal: @aboutNormal
    }

  ###* @type import('./type/scene2').Scene2G['aboutEvent'] ###
  aboutEvent: ->

    unless @checkIsEvent() then return []
    list = @makeListName 'event'

    return list

  ###* @type import('./type/scene2').Scene2G['aboutHalfMenu'] ###
  aboutHalfMenu: ->

    unless @checkIsHalfMenu() then return []
    list = @makeListName 'half-menu'

    if @checkIsChat()
      $.push list, 'chat'
      return list

    return list

  ###* @type import('./type/scene2').Scene2G['aboutLoading'] ###
  aboutLoading: ->

    unless @checkIsLoading() then return []
    list = @makeListName 'loading'

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

  ###* @type import('./type/scene2').Scene2G['aboutMiniMenu'] ###
  aboutMiniMenu: ->

    unless @checkIsMiniMenu() then return []
    list = @makeListName 'mini-menu'

    return list

  ###* @type import('./type/scene2').Scene2G['aboutNormal'] ###
  aboutNormal: ->
    unless @checkIsNormal() then return []
    list = @makeListName 'normal'

    if @checkIsDomain() then $.push list, 'domain'
    if @checkIsSingle() then $.push list, 'single'

    return list

  ###* @type import('./type/scene2').Scene2G['check'] ###
  check: ->

    list = [
      'loading'
      'menu'
      'half-menu'
      'normal'
      'event'
      'mini-menu'
    ]

    unless @cache.last == 'unknown'
      list = $.filter list, (name) => @cache.last != name
      $.unshift list, @cache.last

    for name in list
      fn = @mapAbout[name]
      result = fn()
      unless $.length result then continue
      @cache.last = name
      return result

    @cache.last = 'unknown'
    return []

  ###* @type import('./type/scene2').Scene2G['checkIsChat'] ###
  checkIsChat: -> @throttle 'check-is-chat', 1e3, ->
    return ColorManager.findAll [0x3B4255, 0xECE5D8], [
      '58%', '2%'
      '60%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsDomain'] ###
  checkIsDomain: -> @throttle 'check-is-domain', 1e3, ->
    return ColorManager.findAll [0x38425C, 0xFFFFFF], [
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
  checkIsLoading: ->

    p = [Window2.bounds.width - 1, '50%']

    for color in [0xFFFFFF, 0x000000, 0x1C1C22]
      if (ColorManager.get p) == color then return true

    return false

  ###* @type import('./type/scene2').Scene2G['checkIsMap'] ###
  checkIsMap: -> @throttle 'check-is-map', 1e3, ->
    return ColorManager.findAll 0xEDE5DA, [
      '1%', '38%'
      '2%', '40%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsMenu'] ###
  checkIsMenu: -> ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '95%', '3%'
    '97%', '6%'
  ]

  ###* @type import('./type/scene2').Scene2G['checkIsMiniMenu'] ###
  checkIsMiniMenu: ->

    unless ColorManager.findAll 0xECE5D8, [
      '97%', '1%'
      '98%', '5%'
    ] then return false

    unless ColorManager.findAny [0x3D4555, 0xE2B42A], [
      '97%', '1%'
      '98%', '5%'
    ] then return false

    return true

  ###* @type import('./type/scene2').Scene2G['checkIsNormal'] ###
  checkIsNormal: ->

    if ColorManager.findAll 0xFFFFFF, [
      '2%', '17%'
      '4%', '21%'
    ] then return true

    if ColorManager.findAll 0xFFFFFF, [
      '1%', '9%'
      '3%', '13%'
    ] then return true

    return false

  ###* @type import('./type/scene2').Scene2G['checkIsParty'] ###
  checkIsParty: -> @throttle 'check-is-party', 1e3, ->
    return ColorManager.findAll 0xFFFFFF, [
      '41%', '3%'
      '59%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsPlaying'] ###
  checkIsPlaying: -> @throttle 'check-is-playing', 1e3, ->
    return ColorManager.findAll [0xFFFFFF, 0xFFE92C], [
      '9%', '2%'
      '11%', '6%'
    ]

  ###* @type import('./type/scene2').Scene2G['checkIsSingle'] ###
  checkIsSingle: -> @throttle 'check-is-single', 5e3, ->
    return not ColorManager.findAny [0x006699, 0x408000], [
      '18%', '2%'
      '20%', '6%'
    ]

  ###* necessary for types, do not remove
  @type import('./type/scene2').Scene2G['makeListName']
  ###
  makeListName: (names...) -> names

  ###* @type import('./type/scene2').Scene2G['throttle'] ###
  throttle: (id, interval, fn) ->

    unless Timer.hasElapsed "scene/#{id}", interval
      Indicator.setCount 'gdip/prevent'
      return @cache[id]

    return @cache[id] = fn()

# @ts-ignore
Scene2 = new Scene2G()