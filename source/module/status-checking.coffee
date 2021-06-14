# variable
ts.checkIsActive = 0
# ts.checkIsAiming = 0
ts.checkIsSwimming = 0

# function
class StatusCheckerX

  interval: 300
  isActive: false
  # isAiming: false
  isSwimming: false

  checkIsActive: ->

    now = $.now()
    unless now - ts.checkIsActive > @interval
      return @isActive
    ts.checkIsActive = now

    if @checkPoint [94, 1], [99, 8], 0x3B4255
      @isActive = false
    else if @checkPoint [1, 16], [4, 22], 0xFFFFFF
      @isActive = true
    else @isActive = @checkPoint [95, 2], [98, 7], 0xFFFFFF

    return @isActive

  # checkIsAiming: ->

  #   unless @isActive
  #     return false

  #   now = $.now()
  #   unless now - ts.checkIsAiming > @interval
  #     return @isAiming
  #   ts.checkIsAiming = now

  #   @isAiming = @checkPoint [49, 49], [51, 51]
  #   return @isAiming

  checkIsSwimming = ->

    unless @isActive
      return false

    if player.name == 'mona'
      return true

    now = $.now()
    unless now - ts.checkIsSwimming > @interval
      return @isSwimming
    ts.checkIsSwimming = now

    @isSwimming = @checkPoint [88, 95], [99, 99], 0xFFE92C
    return @isSwimming

  checkPoint: (start, end, color = 0xFFFFFF) ->
    [x, y] = $.findColor color, (client.point start), client.point end
    return x * y > 0

  setIsActive: (isActive) ->
    ts.checkIsActive = $.now()
    @isActive = isActive

# execute
statusChecker = new StatusCheckerX()