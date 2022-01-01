class ColorManagerX

  constructor: ->

    if Config.data.isDebug
      $.on 'alt + f9', =>
        Sound.beep()
        @pick()

  # find(color: number, start: Point, end: Point): Point
  find: $.findColor

  # pick(): void
  pick: ->

    color = $.getColor()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / Client.width
    y1 = $.round (y * 100) / Client.height

    console.log "color-picker: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# export
ColorManager = new ColorManagerX()