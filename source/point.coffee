### interface
type Position = [number, number]
###

# function

class PointX

  # new([number | string, number | string]): Position
  new: (input) ->

    x = 0
    y = 0

    if ($.type input[0]) == 'number'
      x = input[0]
    else x = Client.vw $.replace input[0], '%', ''

    if ($.type input[1]) == 'number'
      y = input[1]
    else y = Client.vh $.replace input[1], '%', ''

    return [x, y]

# execute
Point = new PointX()