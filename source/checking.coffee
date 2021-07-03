# function
class CheckerX

  isActive: false

  constructor: ->
    client.on 'tick', @check
    client.on 'tick', => hud.render 5, @isActive

  check: ->

    if @checkPoint [94, 1], [99, 8], 0x3B4255
      @isActive = false
      return

    if @checkPoint [1, 1], [5, 8], 0x3B4255
      @isActive = false
      return

    if @checkPoint [1, 16], [4, 22], 0xFFFFFF
      @isActive = true
      return

    if @checkPoint [95, 2], [98, 7], 0xFFFFFF
      @isActive = true
      return

  checkPoint: (start, end, color = 0xFFFFFF) ->
    [x, y] = $.findColor color, (client.point start), client.point end
    return x * y > 0

# execute
checker = new CheckerX()