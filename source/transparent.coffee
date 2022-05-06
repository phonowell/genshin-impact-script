class Transparent

  opacity: 100

  constructor: ->
    $.on 'alt + up', @minus
    $.on 'alt + down', @add

  add: ->
    opacity = @opacity + 10
    if opacity > 100 then opacity = 100
    @opacity = opacity
    @render()

  minus: ->
    opacity = @opacity - 10
    if opacity < 0 then opacity = 0
    @opacity = opacity
    @render()

  render: ->
    name = "ahk_exe #{Config.get 'basic/process'}"
    opacity = 255 * (@opacity / 100)
    `WinSet, Transparent, % opacity, % name`

# export
Transparent = new Transparent()