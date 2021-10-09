# function

class ItemUserX

  isAuto: false

  # ---

  constructor: ->
    Client.on 'tick', @next
    $.on 'alt + z', @toggle

  # next(): void
  next: ->
    unless @isAuto then return
    unless Scene.name == 'normal' then return
    $.press 'z'

  # toggle(): void
  toggle: ->

    @isAuto = !@isAuto

    if @isAuto then Hud.render 5, 'enter auto-item mode'
    else Hud.render 5, 'leave auto-item mode'

    $.beep()

# execute
ItemUser = new ItemUserX()