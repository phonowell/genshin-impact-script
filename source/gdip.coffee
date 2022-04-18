import '../../gis-static/lib/Gdip_All.ahk'
import '../../gis-static/lib/Gdip_PixelSearch.ahk'

### interface
type Point = [number, number]
###

# function
class Gdip

  cache:
    findColor: {}
    getColor: {}
    pArea: {}
    pBitmap: 0
    pToken: 0

  constructor: ->
    @start()
    if Config.data.isDebug then Indicator.on 'update', @report

  # argb2rgb(argb: number): number
  argb2rgb: (argb) -> return argb - 0xFF000000

  # clearCache(): void
  clearCache: ->

    @cache.findColor = {}
    @cache.getColor = {}

    for pArea of @cache.pArea
      Gdip_DisposeImage pArea
    @cache.pArea = {}

    if @cache.pBitmap then Gdip_DisposeImage @cache.pBitmap
    @cache.pBitmap = 0

  # end(): void
  end: ->
    unless @cache.pToken then return
    Gdip_Shutdown @cache.pToken
    @cache.pToken = 0

  # findColor(color: number, start: Point, end: Point): Point
  findColor: (color, start = '', end = '') ->

    unless @screenshot()
      Indicator.setCount 'gdip/error'
      return [-1, -1]

    Indicator.setCount 'gdip/findColor'

    unless start then start = [0, 0]
    unless end then end = [Client.width, Client.height]
    [x, y] = start
    [w, h] = [end[0] - x, end[1] - y]

    key = "#{x}|#{y}|#{w}|#{h}"
    pArea = @cache.pArea[key]
    unless pArea
      pArea = Gdip_CloneBitmapArea @cache.pBitmap, x, y, w, h
      unless pArea then return [-1, -1]
      @cache.pArea[key] = pArea

    key2 = "#{key}|#{color}"
    result = @cache.findColor[key2]
    if result then return result

    argb = @rgb2argb color
    err = `Gdip_PixelSearch(pArea, argb, __x__, __y__)`
    if err then return [-1, -1]

    result = `[__x__ == -1 ? -1 : __x__ + x, __y__ == -1 ? -1 : __y__ + y]`
    @cache.findColor[key2] = result
    Indicator.setCount 'gdip/findColor2'
    return result

  # getColor(p: Point): number
  getColor: (p = '') ->

    unless @screenshot()
      Indicator.setCount 'gdip/error'
      return 0
    Indicator.setCount 'gdip/getColor'

    unless p then p = $.getPosition()
    key = "#{p[0]}|#{p[1]}"
    result = @cache.getColor[key]
    if result then return result

    argb = Gdip_GetPixel @cache.pBitmap, p[0], p[1]
    rgb = @argb2rgb argb
    unless rgb >= 0 then return 0

    result = rgb
    @cache.getColor[key] = result
    Indicator.setCount 'gdip/getColor2'
    return result

  # report(): void
  report: ->

    token = 'gdip/error'
    count = Indicator.getCount token
    if count then console.log "#{token}: #{count}"

    token = 'gdip/findColor'
    count = Indicator.getCount token
    count2 = Indicator.getCount 'gdip/findColor2'
    if count then console.log "#{token}: #{count} / #{count2}"

    token = 'gdip/getColor'
    count = Indicator.getCount token
    count2 = Indicator.getCount 'gdip/getColor2'
    if count then console.log "#{token}: #{count} / #{count2}"

    token = 'gdip/screenshot'
    count = Indicator.getCount token
    cost = Indicator.getCost token
    if count then console.log "#{token}: #{count} / #{cost} ms"

  # rgb2argb(rgb: number): number
  rgb2argb: (rgb) -> return rgb + 0xFF000000

  # screenshot(): boolean
  screenshot: ->

    token = 'gdip/screenshot'
    interval = (Indicator.getCost token) * 2
    if interval < 90 then interval = 90

    if @cache.pBitmap and not Timer.checkInterval 'gdip/throttle', interval then return true
    Indicator.setCount token
    Indicator.setCost token, 'start'

    {left, top, width, height} = Client
    pBitmap = Gdip_BitmapFromScreen "#{left}|#{top}|#{width}|#{height}"
    unless pBitmap then return false

    @clearCache()
    Timer.add token, 1e3, @clearCache
    @cache.pBitmap = pBitmap

    Indicator.setCost token, 'end'
    return true

  # start(): void
  start: ->
    if @cache.pToken then return
    @cache.pToken = Gdip_Startup()


# execute
Gdip = new Gdip()