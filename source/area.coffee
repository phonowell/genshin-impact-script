# @ts-check

class AreaG

  ###* @type import('./type/area').AreaG['create'] ###
  create: (ipt) ->

    unless $.isArray ipt
      throw new Error "area/create: invalid ipt 1: #{$.toString ipt}"

    if @isTuple4 ipt then return [
      Point.w ipt[0]
      Point.h ipt[1]
      Point.w ipt[2]
      Point.h ipt[3]
    ]

    if @isTuple2 ipt

      [p1, p2] = ipt

      return [
        Point.w p1[0]
        Point.h p1[1]
        Point.w p2[0]
        Point.h p2[1]
      ]

    throw new Error "area/create: invalid ipt 0: #{$.toString ipt}"

  ###* @type import('./type/area').AreaG['isTuple4'] ###
  isTuple4: (ipt) -> ($.length ipt) >= 4

  ###* @type import('./type/area').AreaG['isTuple2'] ###
  isTuple2: (ipt) -> ($.length ipt) >= 2

  ###* @type import('./type/area').AreaG['isValid'] ###
  isValid: (a) ->
    unless $.isArray a then return false
    [x, y, x2, y2] = a
    unless ($.isNumber x) and x >= 0 then return false
    unless ($.isNumber y) and y >= 0 then return false
    unless ($.isNumber x2) and x2 >= x then return false
    unless ($.isNumber y2) and y2 >= y then return false
    return true

# @ts-ignore
Area = new AreaG()