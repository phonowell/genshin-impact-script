class ToolkitX

  constructor: ->

    unless Config.data.isDebug then return

    $.on 'alt + f9', =>
      $.beep()
      @pickColor()

  pickColor: ->

    color = $.getColor()
    [x, y] = $.getPosition()

    x1 = $.round (x * 100) / client.width
    y1 = $.round (y * 100) / client.height

    console.log "Toolkit: #{x1}, #{y1} / #{color}"
    ClipBoard = color

# execute
toolkit = new ToolkitX()