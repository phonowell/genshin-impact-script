class KeyBindingX extends EmitterShellX

  isPressed: {}
  isPrevented: {}

  constructor: ->
    super()
    client.on 'leave', @resetKey

  bindEvent: (name, key, prevent = false) ->

    $$.vt 'keyBinding.bindEvent', name, 'string'
    $$.vt 'keyBinding.bindEvent', 'number', 'string'

    if prevent
      @isPrevented[key] = true

    $.on key, =>

      if @isPressed[key]
        return
      @isPressed[key] = true

      recorder.record "#{key}:down"
      unless @isPrevented[key]
        $.press "#{key}:down"

      @emit "#{name}:start", key
      # $$.log "#{name}:start"

    $.on "#{key}:up", =>

      unless @isPressed[key]
        return
      @isPressed[key] = false

      recorder.record "#{key}:up"
      unless @isPrevented[key]
        $.press "#{key}:up"

      @emit "#{name}:end", key
      # $$.log "#{name}:end"

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