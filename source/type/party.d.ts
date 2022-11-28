import { AreaLike } from './global'

export class PartyG extends KeyBinding {
  current: number
  list: string[]
  listSlot: [1, 2, 3, 4, 5]
  name: string
  private order: string
  size: number
  constructor()
  private countMember(): void
  findCurrent(): number
  private getNameViaSlot(n: number): string
  has(name: string): boolean
  init(): void
  isCurrent(n: number): boolean
  isSlotValidate(slot: number): boolean
  private makeArea(n: number, isNarrow: boolean): AreaLike
  reset(): void
  scan(): void
  private scanSlot(n: number): void
}
