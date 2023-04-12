import { AreaLike, Fn, PointLike } from './global'

export class ColorManagerG {
  private cache: {
    find: Record<string, [number, number]>
    get: Record<string, number>
  }
  private isFrozen: boolean
  namespace: 'color-manager'
  private tsUpdate: number
  constructor()
  private clearCache(): void
  find(color: number, a: AreaLike): [number, number]
  findAll(listColor: number | number[], a: AreaLike): boolean
  findAny(
    listColor: number | number[],
    a: AreaLike,
  ): [number, number, number] | void
  format(n: number): number
  freeze(fn: Fn): void
  get(p: PointLike): number
  init(): void
  private next(): void
  pick(): void
  private update(): void
}
