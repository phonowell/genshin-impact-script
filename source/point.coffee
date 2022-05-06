### interface
type Position = [number, number]
###

# function

class Point

  # isValid(ipt: Point): boolean
  isValid: (p) -> return p[0] >= 0 and p[1] >= 0

  # new(ipt: [number | string, number | string]): Position
  new: (ipt) ->

    x = 0
    y = 0

    if ($.type ipt[0]) == 'number'
      x = ipt[0]
    else x = @vw $.replace ipt[0], '%', ''

    if ($.type ipt[1]) == 'number'
      y = ipt[1]
    else y = @vh $.replace ipt[1], '%', ''

    return [x, y]

  # vw(number): number
  vh: (n) -> return $.round Client.height * n * 0.01

  # vh(number): number
  vw: (n) -> return $.round Client.width * n * 0.01

# execute
Point = new Point()