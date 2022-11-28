# @ts-check

class PointG

  ###* @type import('./type/point').PointG['click'] ###
  click: (p) ->
    p0 = $.getPosition()
    p1 = @create p
    $.move p1
    $.click()
    Timer.add 50, -> $.move p0

  ###* @type import('./type/point').PointG['create'] ###
  create: (ipt) ->

    unless $.isArray ipt then throw new Error 'point/create: invalid ipt'

    return [
      @w ipt[0]
      @h ipt[1]
    ]

  ###* @type import('./type/point').PointG['h'] ###
  h: (n) ->
    if $.isNumber n then return n
    n = $.replace n, '%', ''
    return $.Math.round Window2.bounds.height * ($.toNumber n) * 0.01

  ###* @type import('./type/point').PointG['isValid'] ###
  isValid: (p) ->
    unless $.isArray p then return false
    [x, y] = p
    unless ($.isNumber x) and x >= 0 then return false
    unless ($.isNumber y) and y >= 0 then return false
    return true

  ###* @type import('./type/point').PointG['w'] ###
  w: (n) ->
    if $.isNumber n then return n
    n = $.replace n, '%', ''
    return $.Math.round Window2.bounds.width * ($.toNumber n) * 0.01

Point = new PointG()