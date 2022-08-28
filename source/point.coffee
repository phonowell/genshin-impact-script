# function

class Point

  # create(ipt: (number | string)[]): Position
  create: (ipt) ->

    unless $.isArray ipt then throw new Error 'point/create: invalid ipt'

    return [
      @w ipt[0]
      @h ipt[1]
    ]

  # h(n: number | string): number
  h: (n) ->
    if $.isNumber n then return n
    n = $.replace n, '%', ''
    return $.round Client.height * n * 0.01

  # isValid(p: Point): boolean
  isValid: (p) ->
    unless $.isArray p then return false
    unless p[0] >= 0 and p[1] >= 0 then return false
    return true

  # w(n: number | string): number
  w: (n) ->
    if $.isNumber n then return n
    n = $.replace n, '%', ''
    return $.round Client.width * n * 0.01

# execute
Point = new Point()