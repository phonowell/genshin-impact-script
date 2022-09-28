import { AreaLike, PointLike } from './global'

export class ColorManagerG {
  find(color: number, a: AreaLike): [number, number]
  findAll(listColor: number | number[], a: AreaLike): boolean
  findAny(
    listColor: number | number[],
    a: AreaLike,
  ): [number, number, number] | void
  format(n: number): number
  get(p: PointLike): number
  pick(): void
}
