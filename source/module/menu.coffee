class MenuX

  interval: 1e3
  isVisible: false
  tsCheck: 0

  checkVisibility: ->

    unless $.now() - @tsCheck > @interval
      return @isVisible
    @tsCheck = $.now()

    start = client.point [2, 16]
    end = client.point [4, 20]

    [x, y] = $.findColor 0xFFFFFF, start, end
    @isVisible = not (x * y > 0)

    return @isVisible

# execute
menu =  new MenuX()