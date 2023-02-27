# @ts-check

class ColorManagerG

  constructor: ->

    ###* @type import('./type/color-manager').ColorManagerG['cache'] ###
    @cache = {
      find: {}
      get: {}
    }

  ###* @type import('./type/color-manager').ColorManagerG['clearCache'] ###
  clearCache: ->
    @cache.find = {}
    @cache.get = {}
    return

  ###* @type import('./type/color-manager').ColorManagerG['find'] ###
  find: (color, a) ->

    a2 = Area.create a
    token = "#{color}|#{$.join a2, ','}"

    if @cache.find[token]
      Indicator.setCount 'gdip/prevent'
      return @cache.find[token]

    return @cache.find[token] = Gdip.findColor color, a2

  ###* @type import('./type/color-manager').ColorManagerG['findAll'] ###
  findAll: (listColor, a) ->

    listColor2 = [0]
    if $.isArray listColor
      listColor2 = listColor
    else listColor2 = [listColor]

    for color in listColor2
      p = @find color, a
      unless Point.isValid p then return false

    return true

  ###* @type import('./type/color-manager').ColorManagerG['findAny'] ###
  findAny: (listColor, a) ->

    unless $.isArray listColor
      listColor = [listColor]

    a = Area.create a

    for color in listColor
      p = @find color, a
      if Point.isValid p then return [p[0], p[1], color]

    return undefined

  ###* @type import('./type/color-manager').ColorManagerG['format'] ###
  format: (n) -> $.toNumber $.replace "0x#{(Format '{:p}', n)}", '0x00', '0x'

  ###* @type import('./type/color-manager').ColorManagerG['get'] ###
  get: (p) ->

    p2 = Point.create p
    token = $.join p2, ','

    if @cache.get[token]
      Indicator.setCount 'gdip/prevent'
      return @cache.get[token]
    return @cache.get[token] = Gdip.getColor p2

  ###* @type import('./type/color-manager').ColorManagerG['init'] ###
  init: ->

    Client.useActive =>
      @next()
      return -> Timer.remove 'color-manager/next'

  ###* @type import('./type/color-manager').ColorManagerG['next'] ###
  next: ->

    Gdip.screenshot()
    @clearCache()

    Scene.update()
    Status2.update()
    Picker.next()
    console.update()

    [interval, token] = [100, 'color-manager/next']
    Timer.add token, interval, @next

  ###* @type import('./type/color-manager').ColorManagerG['pick'] ###
  pick: ->

    color = @format @get $.getPosition()
    [x, y] = $.getPosition()

    x1 = $.Math.round (x * 100) / Window2.bounds.width
    y1 = $.Math.round (y * 100) / Window2.bounds.height

    console.log "#color-manager: #{x1}, #{y1} / #{color}"
    ClipBoard = color
    $.noop ClipBoard

# @ts-ignore
ColorManager = new ColorManagerG()