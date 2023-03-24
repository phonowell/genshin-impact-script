# @ts-check

# @ts-ignore
class KeyBinding extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/key-binding').KeyBinding['mapFired'] ###
    @mapFired = {}

  ###* @type import('./type/key-binding').KeyBinding['endEvent'] ###
  endEvent: (name, key) ->

    unless @mapFired["#{key}.#{name}"] then return
    @mapFired["#{key}.#{name}"] = false

    # @log name, key, 'end', @mapFired["#{key}.#{name}"]

    @emit "#{name}:end", key
    @emit name, key

  ###* @type import('./type/key-binding').KeyBinding['log'] ###
  log: (name, key, step, message) ->
    unless Config.get 'misc/use-debug-mode' then return
    name2 = key
    if name != key then name2 = "#{key}.#{name}"
    console.log "#{name2}/#{step}: #{message}"

  ###* @type import('./type/key-binding').KeyBinding['registerEvent'] ###
  registerEvent: (name, key) ->

    unless name then throw new Error 'key-binding/registerEvent: name is required'
    unless key then throw new Error 'key-binding/registerEvent: key is required'

    if @mapFired["#{key}.#{name}"]
      Timer.add 50, => @registerEvent name, key
      return
    @mapFired["#{key}.#{name}"] = false

    $.on "#{key}.#{name}", => @startEvent name, key
    $.on "#{key}:up.#{name}", => @endEvent name, key

  ###* @type import('./type/key-binding').KeyBinding['startEvent'] ###
  startEvent: (name, key) ->

    if @mapFired["#{key}.#{name}"] then return
    @mapFired["#{key}.#{name}"] = true

    # @log name, key, 'start', @mapFired["#{key}.#{name}"]

    @emit "#{name}:start", key

  ###* @type import('./type/key-binding').KeyBinding['unregisterEvent'] ###
  unregisterEvent: (name, key) ->

    unless name then throw new Error 'key-binding/unregisterEvent: name is required'
    unless key then throw new Error 'key-binding/unregisterEvent: key is required'

    if @mapFired["#{key}.#{name}"]
      Timer.add 50, => @unregisterEvent name, key
      return

    $.off "#{key}.#{name}"
    $.off "#{key}:up.#{name}"