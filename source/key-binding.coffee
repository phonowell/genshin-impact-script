class KeyBindingX extends EmitterShellX

  isPressed: {}
  isPrevented: {}

  constructor: ->
    super()
    client.on 'pause', @resetKey

  bindEvent: (name, key, prevent = false) ->

    if prevent
      @isPrevented[key] = true

    $.on key, =>

      if @isPressed[key]
        return
      @isPressed[key] = true

      unless @isPrevented[key]
        $.press "#{key}:down"

      @emit "#{name}:start", key

    $.on "#{key}:up", =>

      unless @isPressed[key]
        return
      @isPressed[key] = false

      unless @isPrevented[key]
        $.press "#{key}:up"

      @emit "#{name}:end", key

    return @

  resetKey: ->

    for key, value of @isPressed

      if @isPrevented[key]
        continue

      unless value
        continue

      if $.getState key
        continue
      $.press "#{key}:up"

    return @