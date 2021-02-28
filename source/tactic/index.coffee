class TacticX

  count: 0
  isActive: false

  constructor: ->
    player
      .on 'attack:start', @start
      .on 'attack:end', @stop

  delay: (time, callback) ->

    unless @isActive
      return

    clearTimeout timer.tacticDelay
    timer.tacticDelay = $.delay time, callback

  start: ->

    if @isActive
      return

    callback = @validate()
    unless callback
      $.click 'left:down'
      return

    @isActive = true
    callback()

  stop: ->

    if @isActive
      @count = 0
      @isActive = false
      return

    $.click 'left:up'

  validate: ->

    name = member.name
    unless name
      return false

    {typeAtk} = Character.data[name]
    unless typeAtk
      return false

    unless @[name]
      return false

    unless statusChecker.isActive
      return false

    return @[name]

# execute
tactic = new TacticX()

import 'data/*'