class KeyBindingX extends EmitterX

  isPressed: {}
  isPrevented: {}

  constructor: ->
    super()
    client.on 'leave', @resetKey

  bindEvent: (name, key, prevent = false) ->

    if prevent
      @isPrevented[key] = true

    $.on "#{key}", =>

      if @isPressed[key]
        return
      @isPressed[key] = true

      unless @isPrevented[key]
        @press "#{key}:down"

      @emit "#{name}:start", key

    $.on "#{key}:up", =>

      unless @isPressed[key]
        return
      @isPressed[key] = false

      unless @isPrevented[key]
        @press "#{key}:up"

      @emit "#{name}:end", key

    return @

  press: (key) ->

    recorder.record key

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