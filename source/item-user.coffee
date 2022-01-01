# function

class ItemUserX

  isAuto: false

  # ---

  constructor: ->
    $.on 'alt + z', @toggle
    @watch()

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

  # watch(): void
  watch: ->
    interval = 500
    Client.on 'pause', -> Timer.remove 'item-user/watch'
    Client.on 'resume', => Timer.loop 'item-user/watch', interval, @next
    Timer.loop 'item-user/watch', interval, @next

# execute
ItemUser = new ItemUserX()