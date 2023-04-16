# @ts-check

class SceneG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/scene').SceneG['list'] ###
    @list = []

    ###* @type import('./type/scene').SceneG['namespace'] ###
    @namespace = 'scene'

  ###* @type import('./type/scene').SceneG['init'] ###
  init: ->

    @on 'change', =>
      unless $.length @list
        console.log '#scene: unknown'
      else console.log "#scene: #{$.join @list, ', '}"

  ###* @type import('./type/scene').SceneG['is'] ###
  is: (names...) ->

    if $.includes names, 'unknown' then return ($.length @list) == 0

    for name in names

      if $.startsWith name, 'not-'
        name2 = $.subString name, 4
        if $.includes @list, name2 then return false
        continue

      unless $.includes @list, name then return false
      continue

    return true

  ###* @type import('./type/scene').SceneG['update'] ###
  update: ->

    # do not use @is() here
    # because it will cause infinite loop

    list = Scene2.check()
    if $.eq list, @list then return
    @list = list
    @emit 'change'

  ###* @type import('./type/scene').SceneG['useExact'] ###
  useExact: (list, fn) ->

    data = {
      callback: $.noop
      isFired: false
    }

    @on 'change', =>

      if @is list...
        unless data.isFired
          data.isFired = true
          data.callback = fn()
      else
        if data.isFired
          data.isFired = false
          data.callback()

# @ts-ignore
Scene = new SceneG()