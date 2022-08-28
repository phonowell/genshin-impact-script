class Transparent

  constructor: ->

    n = Config.get 'misc/use-transparency-when-idle'
    unless n then return

    Client.on 'idle', => @set 100 - n
    Client.on 'activate', => @set 100

  # set(vn: number): void
  set: (vn) ->
    name = "ahk_exe #{Config.get 'basic/process'}"
    opacity = 255 * (vn / 100)
    `WinSet, Transparent, % opacity, % name`

# export
Transparent = new Transparent()