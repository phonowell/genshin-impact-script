class ColorPickerX

  tsLast: 0

  constructor: ->

    if Config.data.isDebug
      $.on 'alt + f9', =>
        $.beep()
        @pick()

  pick: ->

    color = $.getColor()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / client.width
    y1 = $.round (y * 100) / client.height

    console.log "color-picker: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# export
ColorPicker = new ColorPickerX()