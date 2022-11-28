# @ts-check

class KeyBinding extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/key-binding').KeyBinding['isFired'] ###
    @isFired = {}
    ###* @type import('./type/key-binding').KeyBinding['isPressed'] ###
    @isPressed = {}
    ###* @type import('./type/key-binding').KeyBinding['map'] ###
    @map = {}

  ###* @type import('./type/key-binding').KeyBinding['registerEvent'] ###
  registerEvent: (name, key, isPrevented = false) ->

    unless name then throw new Error 'KeyBinding/registerEvent: name is required'
    unless key then throw new Error 'KeyBinding/registerEvent: key is required'
    # if isPrevented
    #   console.log "key-binding/registerEvent: #{key}.#{name} is prevented"

    unless @map[name] then @map[name] = []
    $.push @map[name], key

    $.on "#{key}.#{name}", =>

      if @isPressed[key] then return
      @isPressed[key] = true

      unless isPrevented then $.press "#{key}:down"
      @emit "#{name}:start", key

      @isFired[key] = true

    $.on "#{key}:up.#{name}", =>

      fn = =>

        unless @isPressed[key] then return
        @isPressed[key] = false

        @isFired[key] = false

        unless isPrevented then $.press "#{key}:up"
        @emit "#{name}:end", key
        @emit name, key

      if @isFired[key] then fn()
      else Timer.add 50, fn

  ###* @type import('./type/key-binding').KeyBinding['unregisterEvent'] ###
  unregisterEvent: (name, key) ->

    unless name then throw new Error 'KeyBinding/unregisterEvent: name is required'
    unless key then throw new Error 'KeyBinding/unregisterEvent: key is required'

    group = @map[name]
    unless group then return
    unless $.includes group, key then return

    @map[name] = $.filter group, (k) -> k != key
    $.off "#{key}.#{name}"
    $.off "#{key}:up.#{name}"