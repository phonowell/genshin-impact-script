# @ts-check

# @ts-ignore
class KeyBinding extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/key-binding').KeyBinding['mapFired'] ###
    @mapFired = {}
    ###* @type import('./type/key-binding').KeyBinding['mapGroup'] ###
    @mapGroup = {}
    ###* @type import('./type/key-binding').KeyBinding['mapPressed'] ###
    @mapPressed = {}
    ###* @type import('./type/key-binding').KeyBinding['mapPrevented'] ###
    @mapPrevented = {}

  ###* @type import('./type/key-binding').KeyBinding['end'] ###
  end: (name, key) ->

    unless @mapFired["#{key}.#{name}"] then return
    @mapFired["#{key}.#{name}"] = false

    # @log name, key, 'end', @mapFired["#{key}.#{name}"]

    unless @mapPrevented[key]
      if @mapPressed[key]
        @mapPressed[key] = false
        $.press "#{key}:up"

    @mapFired["#{key}.#{name}"] = false
    @emit "#{name}:end", key
    @emit name, key

  ###* @type import('./type/key-binding').KeyBinding['log'] ###
  log: (name, key, step, message) ->
    unless Config.get 'misc/use-debug-mode' then return
    name2 = key
    if name != key then name2 = "#{key}.#{name}"
    console.log "#{name2}/#{step}: #{message}"

  ###* @type import('./type/key-binding').KeyBinding['registerEvent'] ###
  registerEvent: (name, key, isPrevented = false) ->

    unless name then throw new Error 'key-binding/registerEvent: name is required'
    unless key then throw new Error 'key-binding/registerEvent: key is required'

    # init
    unless @mapGroup[name] then @mapGroup[name] = []
    $.push @mapGroup[name], key

    if @mapFired["#{key}.#{name}"]
      Timer.add 50, => @registerEvent name, key, isPrevented
      return
    @mapFired["#{key}.#{name}"] = false

    @mapPrevented[key] = isPrevented

    $.on "#{key}.#{name}", => @start name, key
    $.on "#{key}:up.#{name}", => @end name, key

  ###* @type import('./type/key-binding').KeyBinding['start'] ###
  start: (name, key) ->

    if @mapFired["#{key}.#{name}"] then return
    @mapFired["#{key}.#{name}"] = true

    # @log name, key, 'start', @mapFired["#{key}.#{name}"]

    unless @mapPrevented[key]
      unless @mapPressed[key]
        @mapPressed[key] = true
        $.press "#{key}:down"

    @mapFired["#{key}.#{name}"] = true
    @emit "#{name}:start", key

  ###* @type import('./type/key-binding').KeyBinding['unregisterEvent'] ###
  unregisterEvent: (name, key) ->

    unless name then throw new Error 'key-binding/unregisterEvent: name is required'
    unless key then throw new Error 'key-binding/unregisterEvent: key is required'

    group = @mapGroup[name]
    unless group then return
    unless $.includes group, key then return

    if @mapFired["#{key}.#{name}"]
      Timer.add 50, => @unregisterEvent name, key
      return

    @mapGroup[name] = $.filter group, (k) -> k != key
    $.off "#{key}.#{name}"
    $.off "#{key}:up.#{name}"