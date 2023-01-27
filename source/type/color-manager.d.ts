import { AreaLike, PointLike } from './global'

export class ColorManagerG {
  private cache: {
    find: Record<string, [number, number]>
    get: Record<string, number>
  }
  constructor()
  private clearCache(): void
  find(color: number, a: AreaLike): [number, number]
  findAll(listColor: number | number[], a: AreaLike): boolean
  findAny(
    listColor: number | number[],
    a: AreaLike,
  ): [number, number, number] | void
  format(n: number): number
  get(p: PointLike): number
  init(): void
  next(): void
  pick(): void
}
