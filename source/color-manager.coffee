# @ts-check

class ColorManagerG

  ###* @type import('./type/color-manager').ColorManagerG['find'] ###
  find: (color, a) -> Gdip.findColor color, Area.create a

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
  get: (p) -> Gdip.getColor Point.create p

  ###* @type import('./type/color-manager').ColorManagerG['pick'] ###
  pick: ->

    color = @format @get $.getPosition()
    [x, y] = $.getPosition()

    x1 = $.Math.round (x * 100) / Client.width
    y1 = $.Math.round (y * 100) / Client.height

    console.log "#color-manager: #{x1}, #{y1} / #{color}"
    ClipBoard = color
    $.noop ClipBoard

# export
ColorManager = new ColorManagerG()