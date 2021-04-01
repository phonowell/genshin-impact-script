class MenuX

  isVisible: false
  tsCheck: 0

  checkVisibility: ->

    unless $.now() - @tsCheck > 1e3
      return @isVisible
    @tsCheck = $.now()

    start = client.point [95, 5]
    end = [
      client.vw 96
      start[1] + 1
    ]

    [x, y] = $.findColor 0xFFFFFF, start, end
    @isVisible = not (x * y > 0)

    return @isVisible

# execute
menu =  new MenuX()