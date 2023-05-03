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
  is: (name) ->

    if name == 'unknown' then return ($.length @list) == 0

    if $.startsWith name, 'not-'
      name2 = $.subString name, 4
      return not $.includes @list, name2

    return $.includes @list, name

  ###* @type import('./type/scene').SceneG['update'] ###
  update: ->

    # do not use @is() here
    # because it will cause infinite loop

    list = Scene2.check()
    if $.eq list, @list then return
    @list = list
    @emit 'change'

  ###* @type import('./type/scene').SceneG['useExact'] ###
  useExact: (name, fn) ->

    data = {
      callback: $.noop
      isFired: false
    }

    @on 'change', =>

      if @is name
        unless data.isFired
          data.isFired = true
          data.callback = fn()
      else
        if data.isFired
          data.isFired = false
          data.callback()

# @ts-ignore
Scene = new SceneG()