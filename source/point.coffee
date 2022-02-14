### interface
type Position = [number, number]
###

# function

class Point

  # isValid(input: Point): boolean
  isValid: (p) -> return p[0] >= 0 and p[1] >= 0

  # new(input: [number | string, number | string]): Position
  new: (input) ->

    x = 0
    y = 0

    if ($.type input[0]) == 'number'
      x = input[0]
    else x = @vw $.replace input[0], '%', ''

    if ($.type input[1]) == 'number'
      y = input[1]
    else y = @vh $.replace input[1], '%', ''

    return [x, y]

  # vw(number): number
  vh: (n) -> return $.round Client.height * n * 0.01

  # vh(number): number
  vw: (n) -> return $.round Client.width * n * 0.01

# execute
Point = new Point()