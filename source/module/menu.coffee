class MenuX

  isVisible: false

  constructor: ->

    ticker.on 'change', (tick) =>

      if client.isSuspend
        return

      if $.mod tick, 1e3
        return

      @checkVisibility()

  checkVisibility: ->

    start = client.point [95, 5]
    end = [
      client.vw 96
      start[1] + 1
    ]

    [x, y] = $.findColor 0xFFFFFF, start, end
    @isVisible = not (x * y > 0)

# execute
menu =  new MenuX()