import { AreaLike, Fn } from './global'

export class SkillG extends KeyBinding {
  listCache: Record<number, [number, number]>
  listCountDown: Record<number, number>
  listDuration: Record<number, number>
  private listQ: Record<number, number>
  private listRecord: Record<number, number>
  private tsUseE: number
  constructor()
  private aboutBinding(): void
  private correctCD(cd: number): number
  endE(): void
  private endEAsDefault(): void
  private endEAsHolding(): void
  private endEAsType1(): void
  endEAsType2(): void
  endEAsType3(current: number): void
  private endEAsType4(): void
  private freeze(): void
  init(): void
  private isEUsed(): void
  private isEUsed2(): void
  private makeArea1(): AreaLike
  private makeArea2(): AreaLike
  reset(): void
  startE(): void
  switchQ(n: number): void
  useE(isHolding?: boolean, callback?: Fn): void
  useQ(): void
  private watch(): void
}
