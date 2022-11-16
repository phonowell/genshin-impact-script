# @ts-check

class SceneG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/scene').SceneG['cache'] ###
    @cache = {}
    ###* @type import('./type/scene').SceneG['isFrozen'] ###
    @isFrozen = false
    ###* @type import('./type/scene').SceneG['list'] ###
    @list = []
    ###* @type import('./type/scene').SceneG['tsChange'] ###
    @tsChange = 0

  ###* @type import('./type/scene').SceneG['freezeAs'] ###
  freezeAs: (listName, time) ->
    @isFrozen = true
    @list = listName
    @emit 'change'
    Timer.add 'scene/freeze-as', time, => @isFrozen = false
    return

  ###* @type import('./type/scene').SceneG['init'] ###
  init: ->
    @on 'change', =>
      unless $.length @list
        console.log '#scene: unknown'
      else console.log "#scene: #{$.join @list, ', '}"
      @tsChange = $.now()

  ###* @type import('./type/scene').SceneG['is'] ###
  is: (names...) ->

    @update()
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

    if @isFrozen then return
    if $.includes @list, 'fishing' then return

    list = Scene2.check()
    if $.eq list, @list then return
    @list = list
    @emit 'change'

Scene = new SceneG()