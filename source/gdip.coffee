# @ts-check

import '../../gis-static/lib/Gdip_All.ahk'
import '../../gis-static/lib/Gdip_PixelSearch.ahk'

class GdipG

  constructor: ->

    ###* @type import('./type/gdip').GdipG['cache'] ###
    @cache =
      findColor: {}
      getColor: {}
      pArea: {}
      pBitmap: 0
      pToken: 0

  ###* @type import('./type/gdip').GdipG['argb2rgb'] ###
  argb2rgb: (argb) -> argb - 0xFF000000

  ###* @type import('./type/gdip').GdipG['clearCache'] ###
  clearCache: ->

    @cache.findColor = {}
    @cache.getColor = {}

    for _key, pa of @cache.pArea
      Gdip_DisposeImage pa
    @cache.pArea = {}

    if @cache.pBitmap then Gdip_DisposeImage @cache.pBitmap
    @cache.pBitmap = 0
    return

  ###* @type import('./type/gdip').GdipG['end'] ###
  end: ->
    unless @cache.pToken then return
    Gdip_Shutdown @cache.pToken
    @cache.pToken = 0
    return

  ###* @type import('./type/gdip').GdipG['findColor'] ###
  findColor: (color, a) ->

    Indicator.setCount 'gdip/findColor2'

    [x, y, w, h] = [
      a[0]
      a[1]
      a[2] - a[0]
      a[3] - a[1]
    ]

    key = "#{x}|#{y}|#{w}|#{h}"
    pa = @cache.pArea[key]
    unless pa
      pa = Gdip_CloneBitmapArea @cache.pBitmap, x, y, w, h
      unless pa then return [-1, -1]
      @cache.pArea[key] = pa

    key2 = "#{key}|#{color}"
    result = @cache.findColor[key2]
    if result then return result

    argb = @rgb2argb color
    [x1, y1] = [-1, -1]
    err = Gdip_PixelSearch pa, argb, x1, y1
    if err then return [-1, -1]

    result = [-1, -1]
    unless x1 == -1 then result[0] = x1 + x
    unless y1 == -1 then result[1] = y1 + y
    @cache.findColor[key2] = result
    Indicator.setCount 'gdip/findColor'
    return result

  ###* @type import('./type/gdip').GdipG['getColor'] ###
  getColor: (p) ->

    Indicator.setCount 'gdip/getColor2'

    key = "#{p[0]}|#{p[1]}"
    result = @cache.getColor[key]
    if result then return result

    argb = Gdip_GetPixel @cache.pBitmap, p[0], p[1]
    rgb = @argb2rgb argb
    unless rgb >= 0 then return 0

    result = rgb
    @cache.getColor[key] = result
    Indicator.setCount 'gdip/getColor'
    return result

  ###* @type import('./type/gdip').GdipG['init'] ###
  init: ->
    @start()
    if Config.get 'misc/use-debug-mode'
      Indicator.on 'update', @report

  ###* @type import('./type/gdip').GdipG['report'] ###
  report: ->

    token = 'gdip/error'
    count = Indicator.getCount token
    if count then console.log "##{token}: #{count}"

    token = 'gdip/findColor'
    count = Indicator.getCount token
    count2 = Indicator.getCount 'gdip/findColor2'
    if count then console.log "##{token}: #{count2} / #{count}"

    token = 'gdip/getColor'
    count = Indicator.getCount token
    count2 = Indicator.getCount 'gdip/getColor2'
    if count then console.log "##{token}: #{count2} / #{count}"

    token = 'gdip/prevent'
    count = Indicator.getCount token
    if count then console.log "##{token}: #{count}"

    token = 'gdip/screenshot'
    count = Indicator.getCount token
    cost = Indicator.getCost token
    if count then console.log "##{token}: #{count} / #{cost} ms"

  ###* @type import('./type/gdip').GdipG['rgb2argb'] ###
  rgb2argb: (rgb) -> rgb + 0xFF000000

  ###* @type import('./type/gdip').GdipG['screenshot'] ###
  screenshot: ->

    token = 'gdip/screenshot'
    Indicator.setCount token
    Indicator.setCost token, 'start'

    # {x, y, width, height} = Window2.bounds
    # pBitmap = Gdip_BitmapFromScreen "#{x}|#{y}|#{width}|#{height}"

    unless Window2.id then return
    pBitmap = Gdip_BitmapFromHWND Window2.id
    unless pBitmap then return

    @clearCache()
    @cache.pBitmap = pBitmap

    Indicator.setCost token, 'end'

  ###* @type import('./type/gdip').GdipG['start'] ###
  start: ->
    if @cache.pToken then return
    @cache.pToken = Gdip_Startup()
    return

# @ts-ignore
Gdip = new GdipG()