class ColorManager

  constructor: ->
    @init()

  # find(color: number, start: Point, end: Point): Point
  find: Gdip.findColor

  # findAll(listColor: number | number[], a: Area): Boolean
  findAll: (listColor, a) ->

    unless $.isArray listColor
      listColor = [listColor]

    a = Area.create a

    for color in listColor
      p = @find color, a
      unless Point.isValid p then return false

    return true

  # findAny(listColor: number | number[], a: Area): Point | 0
  findAny: (listColor, a) ->

    unless $.isArray listColor
      listColor = [listColor]

    a = Area.create a

    for color in listColor
      p = @find color, a
      if Point.isValid p then return [p[0], p[1], color]

    return 0

  # format(n: string): string
  format: (n) -> return $.replace "0x#{(Format '{:p}', n)}", '0x00', '0x'

  # init(): void
  init: ->

    unless Config.get 'debug' then return

    $.on 'alt + f9', =>
      Sound.beep()
      @pick()

    $.on 'f8', ->
      a = [
        ['95%', '3%']
        ['97%', '6%']
      ]
      result = ColorManager.findAll 0x3B4255, a
      console.log $.join (Area.create a), ', '
      console.log result

  # get(p: Point): number
  get: Gdip.getColor

  # pick(): void
  pick: ->

    color = @format @get()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / Client.width
    y1 = $.round (y * 100) / Client.height

    console.log "color-manager: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# export
ColorManager = new ColorManager()