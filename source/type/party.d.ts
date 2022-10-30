import { AreaLike, Fn } from './global'

export class PartyG extends KeyBinding {
  current: number
  list: string[]
  private listOnSwitch: string[]
  private listSlot: [1, 2, 3, 4, 5]
  name: string
  private order: string
  size: number
  constructor()
  private aboutBinding1(): void
  private aboutBinding2(): void
  private countMember(): void
  // private findCurrent(): number
  private getNameViaSlot(n: number): string
  has(name: string): boolean
  init(): void
  private isCurrent(n: number): boolean
  private isCurrentAs(n: number, cbDone: Fn, cbFail?: Fn): void
  private makeArea(n: number, isNarrow: boolean): AreaLike
  reset(): void
  scan(): void
  private scanSlot(n: number): void
  private waitFor(n: number, callback: Fn): void
  // private watch(): void
}
