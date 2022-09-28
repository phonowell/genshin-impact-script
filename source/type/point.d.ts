import { PointLike } from './global'

export class PointG {
  create(ipt: PointLike): [number, number]
  h(n: number | string): number
  isValid(p: PointLike): p is [number, number]
  w(n: number | string): number
}
