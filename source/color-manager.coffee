class ColorManagerX

  constructor: ->

    if Config.data.isDebug
      $.on 'alt + f9', =>
        Sound.beep()
        @pick()

  # find(color: number, start: Point, end: Point): Point
  find: Gdip.findColor

  # format(input: string): string
  format: (n) -> return $.replace "0x#{(Format '{:p}', n)}", '0x00', '0x'

  # get(p: Point): number
  get: Gdip.getColor

  # pick(): void
  pick: ->

    color = @format @get()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / Client.width
    y1 = $.round (y * 100) / Client.height

    console.log "color-picker: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# export
ColorManager = new ColorManagerX()