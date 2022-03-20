# function

class KeyBinding extends EmitterShellX

  isPressed: {}
  map: {} # Record<string, string[]>

  constructor: ->
    super()
    Client.on 'leave', @resetAllPressedKeys

  # registerEvent(name: string, key: string, isPrevented: boolean): void
  registerEvent: (name, key, isPrevented = false) ->

    unless name then throw new Error 'KeyBinding/registerEvent: name is required'
    unless key then throw new Error 'KeyBinding/registerEvent: key is required'

    unless @map[name] then @map[name] = []
    $.push @map[name], key

    $.on "#{key}.#{name}", =>
      if @isPressed[key] then return
      @isPressed[key] = true
      unless isPrevented then $.press "#{key}:down"
      @emit "#{name}:start", key

    $.on "#{key}:up.#{name}", =>
      unless @isPressed[key] then return
      @isPressed[key] = false
      unless isPrevented then $.press "#{key}:up"
      @emit "#{name}:end", key
      @emit name, key

  # resetAllPressedKeys(): void
  resetAllPressedKeys: -> for key, value of @isPressed
    unless value then continue
    if $.getState key then continue
    $.press "#{key}:up"

  # unregisterEvent(name: string, key: string): void
  unregisterEvent: (name, key) ->

    unless name then throw new Error 'KeyBinding/unregisterEvent: name is required'
    unless key then throw new Error 'KeyBinding/unregisterEvent: key is required'

    group = @map[name]
    unless group then throw new Error "KeyBinding/unregisterEvent: no such event '#{name}'"
    unless $.includes group, key then throw new Error "KeyBinding/unregisterEvent: no such key '#{key}' in event '#{name}'"

    @map[name] = $.filter group, (k) -> return k != key
    $.off "#{key}.#{name}"
    $.off "#{key}:up.#{name}"