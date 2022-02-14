import '../../gis-static/lib/Gdip_All.ahk'
import '../../gis-static/lib/Gdip_PixelSearch.ahk'

### interface
type Point = [number, number]
###

# function

class Gdip

  cache: [0, '']
  pArea: 0
  pBitmap: 0
  pToken: 0

  constructor: -> @start()

  # argb2rgb(argb: number): number
  argb2rgb: (argb) -> return argb - 0xFF000000

  # end(): void
  end: ->
    unless @pToken then return
    Gdip_Shutdown @pToken
    @pToken = 0

  # findColor(color: number, start: Point, end: Point): Point
  findColor: (color, start = '', end = '') ->

    unless @screenshot() then return [-1, -1]

    unless start then start = [0, 0]
    unless end then end = [Client.width, Client.height]
    [x, y] = start
    [w, h] = [end[0] - x, end[1] - y]

    [last, token] = @cache
    now = $.now()
    unless now - last < 100 and token == "#{x}|#{y}|#{w}|#{h}"
      @cache = [now, "#{x}|#{y}|#{w}|#{h}"]
      pArea = Gdip_CloneBitmapArea @pBitmap, x, y, w, h
      unless pArea then return [-1, -1]
      if @pArea then Gdip_DisposeImage @pArea
      @pArea = pArea

    argb = @rgb2argb color
    err = `Gdip_PixelSearch(this.pArea, argb, __x__, __y__)`
    if err then return [-1, -1]

    return `[__x__ == -1 ? -1 : __x__ + x, __y__ == -1 ? -1 : __y__ + y]`

  # getColor(p: Point): number
  getColor: (p = '') ->

    unless @screenshot() then return 0

    unless p then p = $.getPosition()
    argb = Gdip_GetPixel @pBitmap, p[0], p[1]
    rgb = @argb2rgb argb

    unless rgb >= 0 then return 0
    return rgb

  # rgb2argb(rgb: number): number
  rgb2argb: (rgb) -> return rgb + 0xFF000000

  # screenshot(): boolean
  screenshot: ->

    interval = 100
    unless Timer.checkInterval 'gdip/throttle', interval then return true

    {left, top, width, height} = Client
    pBitmap = Gdip_BitmapFromScreen "#{left}|#{top}|#{width}|#{height}"
    unless pBitmap then return false

    if @pBitmap then Gdip_DisposeImage @pBitmap
    @pBitmap = pBitmap
    return true

  # start(): void
  start: ->
    if @pToken then return
    @pToken = Gdip_Startup()

# execute
Gdip = new Gdip()