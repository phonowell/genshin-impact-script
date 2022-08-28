# function

class Area

  # create(ipt: (number | string)[] | (number | string)[][]): Area
  create: (ipt) ->

    unless $.isArray ipt
      throw new Error 'area/create: invalid ipt'

    len = $.length ipt

    if len >= 4 then return [
      Point.w ipt[0]
      Point.h ipt[1]
      Point.w ipt[2]
      Point.h ipt[3]
    ]

    if len >= 2

      [p1, p2] = ipt
      unless (Point.isValid p1) and Point.isValid p2
        throw new Error 'area/create: invalid ipt'

      return [
        Point.w p1[0]
        Point.h p1[1]
        Point.w p2[0]
        Point.h p2[1]
      ]

    throw new Error 'area/create: invalid ipt'

  # isValid(r: Area): boolean
  isValid: (a) ->
    unless $.isArray a then return false
    unless a[0] >= 0 and a[1] >= 0 then return false
    unless a[2] >= a[0] and a[3] >= a[1] then return false
    return true

# execute
Area = new Area()