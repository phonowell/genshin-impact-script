# @ts-check

class KeyBinding extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/key-binding').KeyBinding['mapGroup'] ###
    @mapGroup = {}
    ###* @type import('./type/key-binding').KeyBinding['mapPressed'] ###
    @mapPressed = {}
    ###* @type import('./type/key-binding').KeyBinding['mapPrevented'] ###
    @mapPrevented = {}

  ###* @type import('./type/key-binding').KeyBinding['end'] ###
  end: (name, key) ->

    unless @mapPressed[key] then return
    @mapPressed[key] = false

    # name2 = "#{key}"
    # if name != key then name2 = "#{key}.#{name}"
    # console.log "#{name2}/end: #{@mapPressed[key]}"

    unless @mapPrevented[key] then $.press "#{key}:up"

    @emit "#{name}:end", key
    @emit name, key

  ###* @type import('./type/key-binding').KeyBinding['registerEvent'] ###
  registerEvent: (name, key, isPrevented = false) ->

    unless name then throw new Error 'key-binding/registerEvent: name is required'
    unless key then throw new Error 'key-binding/registerEvent: key is required'

    # init
    unless @mapGroup[name] then @mapGroup[name] = []
    $.push @mapGroup[name], key

    if @mapPressed[key]
      Timer.add 30, => @registerEvent name, key, isPrevented
      return

    @mapPrevented[key] = isPrevented

    $.on "#{key}.#{name}", => @start name, key

    $.on "#{key}:up.#{name}", =>
      if @mapPressed[key] then @end name, key
      else Timer.add 30, => @end name, key

  ###* @type import('./type/key-binding').KeyBinding['start'] ###
  start: (name, key) ->

    if @mapPressed[key] then return
    @mapPressed[key] = true

    # name2 = "#{key}"
    # if name != key then name2 = "#{key}.#{name}"
    # console.log "#{name2}/start: #{@mapPressed[key]}"

    unless @mapPrevented[key] then $.press "#{key}:down"

    @emit "#{name}:start", key

  ###* @type import('./type/key-binding').KeyBinding['unregisterEvent'] ###
  unregisterEvent: (name, key) ->

    unless name then throw new Error 'key-binding/unregisterEvent: name is required'
    unless key then throw new Error 'key-binding/unregisterEvent: key is required'

    group = @mapGroup[name]
    unless group then return
    unless $.includes group, key then return

    if @mapPressed[key]
      Timer.add 30, => @unregisterEvent name, key
      return

    @mapGroup[name] = $.filter group, (k) -> k != key
    $.off "#{key}.#{name}"
    $.off "#{key}:up.#{name}"