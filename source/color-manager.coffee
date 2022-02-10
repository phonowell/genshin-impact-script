class ColorManagerX

  constructor: ->

    if Config.data.isDebug
      $.on 'alt + f9', =>
        Sound.beep()
        @pick()

  # find(color: number, start: Point, end: Point): Point
  find: (color, start, end) ->
    unless Config.data.gdip then return $.findColor color, start, end
    return Gdip.findColor color, start, end

  # get(p: Point): number
  get: (p) ->
    unless Config.data.gdip then return $.getColor p
    return Gdip.getColor p

  # pick(): void
  pick: ->

    color2 = @get()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / Client.width
    y1 = $.round (y * 100) / Client.height

    console.log "color-picker: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# export
ColorManager = new ColorManagerX()