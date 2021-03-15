class KeyBindingX extends EmitterShellX

  isPressed: {}
  isPrevented: {}

  constructor: ->
    super()
    client.on 'leave', @resetKey

  bindEvent: (name, key, prevent = false) ->

    ($$.vt 'keyBinding.bindEvent', name, 'string') key, ['number', 'string']

    if prevent
      @isPrevented[key] = true

    $.on "#{key}", =>

      if @isPressed[key]
        return
      @isPressed[key] = true

      recorder.record "#{key}:down"
      unless @isPrevented[key]
        @press "#{key}:down"

      @emit "#{name}:start", key

    $.on "#{key}:up", =>

      unless @isPressed[key]
        return
      @isPressed[key] = false

      recorder.record "#{key}:up"
      unless @isPrevented[key]
        @press "#{key}:up"

      @emit "#{name}:end", key

    return @

  press: (key) ->

    $$.vt 'keyBinding.press', key, 'string'

    unless $.includes key, '-button'
      $.press key
      return @

    if $.includes key, 'l-button'
      key = $.replace key, 'l-button', 'left'
    else if $.includes key, 'm-button'
      key = $.replace key, 'm-button', 'middle'
    else if $.includes key, 'r-button'
      key = $.replace key, 'r-button', 'right'

    $.click key
    return @

  resetKey: ->

    for key, value of @isPressed

      if @isPrevented[key]
        continue

      unless value
        continue

      if $.getState key
        continue
      @press "#{key}:up"

    return @