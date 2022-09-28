import { AreaLike } from './global'

export class AreaG {
  create(ipt: AreaLike): [number, number, number, number]
  private isTuple4(ipt: AreaLike): ipt is (number | string)[]
  private isTuple2(ipt: AreaLike): ipt is (number | string)[][]
  isValid(a: AreaLike): boolean
}
