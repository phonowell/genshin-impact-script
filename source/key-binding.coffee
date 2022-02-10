class KeyBindingX extends EmitterShellX

  isPressed: {}
  isPrevented: {}

  constructor: ->
    super()
    Client.on 'pause', @resetKey

  # bindEvent(name: string, key: string, prevent: boolean): void
  bindEvent: (name, key, prevent = false) ->

    if prevent then @isPrevented[key] = true

    $.on key, =>
      if @isPressed[key] then return
      @isPressed[key] = true
      unless @isPrevented[key] then $.press "#{key}:down"
      @emit "#{name}:start", key

    $.on "#{key}:up", =>
      unless @isPressed[key] then return
      @isPressed[key] = false
      unless @isPrevented[key] then $.press "#{key}:up"
      @emit "#{name}:end", key

  # resetKey(): void
  resetKey: -> for key, value of @isPressed
    if @isPrevented[key] then continue
    unless value then continue
    if $.getState key then continue
    $.press "#{key}:up"