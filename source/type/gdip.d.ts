type Bitmap = number
type Code = number
type Graphics = number

declare global {
  const Gdip_BitmapFromHWND: (hwnd: number) => Bitmap
  const Gdip_BitmapFromScreen: (area: string) => Bitmap

  const Gdip_CloneBitmapArea: (
    bitmap: Bitmap,
    x: number,
    y: number,
    width: number,
    height: number,
  ) => Bitmap

  const Gdip_CreateBitmap: (width: number, height: number) => Bitmap

  const Gdip_CreateBitmapFromGraphics: (
    grahpics: Graphics,
    width: number,
    height: number,
  ) => Bitmap

  const Gdip_DeleteGraphics: (graphics: Graphics) => void

  const Gdip_DisposeImage: (bitmap: Bitmap) => void

  const Gdip_DrawImageRect: (
    pGraphics: Graphics,
    bitmap: Bitmap,
    x: number,
    y: number,
    width: number,
    height: number,
  ) => Code

  const Gdip_GraphicsFromImage: (bitmap: Bitmap) => Graphics

  const Gdip_GetPixel: (bitmap: Bitmap, x: number, y: number) => number

  const Gdip_PixelSearch: (
    area: Bitmap,
    color: number,
    x: number,
    y: number,
  ) => number

  const Gdip_ResizeBitmap: (
    bitmap: Bitmap,
    width: number,
    height: number,
    keepRatio: boolean,
  ) => Bitmap

  const Gdip_SaveBitmapToFile: (bitmap: Bitmap, path: string) => void

  const Gdip_Shutdown: (token: number) => void

  const Gdip_Startup: () => number
}

type Cache = {
  findColor: Record<number, number>
  getColor: Record<number, number>
  pArea: Record<string, Bitmap>
  pBitmap: Bitmap
  pToken: number
}

export class GdipG {
  private cache: Cache
  constructor()
  private argb2rgb(argb: number): number
  clearCache(): void
  private end(): void
  findColor(
    color: number,
    a: [number, number, number, number],
  ): [number, number]
  getColor(p: [number, number]): number
  init(): void
  private report(): void
  private rgb2argb(rgb: number): number
  screenshot(): void
  private start(): void
}
