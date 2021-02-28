class StatusCheckerX

  isActive: false
  # isPickable: false
  # isTalkable: false

  constructor: ->
    client.on 'leave', @reset

  check: (tick) ->

    if client.isSuspend
      return

    unless Mod tick, 1e3
      @isActive = @checkIsActive()

    # unless Mod tick, 200
    #   [@isPickable, @isTalkable] = @checkIsPickable()
    #   if @isPickable then player.pick()

  checkIsActive: ->

    start = client.point [95, 5]
    end = [
      client.vw 96
      start[1] + 1
    ]

    [x, y] = $.findColor 0xFFFFFF, start, end
    return x * y > 0

  # checkIsPickable: ->

  #   unless @isActive
  #     return [false, false]

  #   unless player.isMoving
  #     return [false, false]

  #   start = client.point [58, 35]
  #   end = [
  #     start[0] + 1
  #     client.vh 60
  #   ]
  #   [x, y] = $.findColor 0xFFFFFF, start, end

  #   unless x * y > 0
  #     return [false, false]

  #   start = [
  #     client.vw 61
  #     y + 5
  #   ]
  #   end = [
  #     client.vw 62
  #     y + 6
  #   ]
  #   [x, y] = $.findColor 0xFFFFFF, start, end

  #   if x * y > 0
  #     return [false, true]
  #   else return [true, false]

  reset: ->
    @isActive = false
    # @isPickable = false
    # @isTalkable = false

# execute

statusChecker = new StatusCheckerX()

ticker.on 'change', (tick) ->
  statusChecker.check tick