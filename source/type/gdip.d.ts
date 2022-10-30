type Cache = {
  findColor: Record<number, number>
  getColor: Record<number, number>
  pArea: Record<string, number>
  pBitmap: number
  pToken: number
}

export class GdipG {
  private cache: Cache
  constructor()
  private argb2rgb(argb: number): number
  private clearCache(): void
  private end(): void
  findColor(
    color: number,
    a: [number, number, number, number],
  ): [number, number]
  getColor(p: [number, number]): number
  init(): void
  private report(): void
  private rgb2argb(rgb: number): number
  private screenshot(): boolean
  private start(): void
}
