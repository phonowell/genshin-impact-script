import { Fn } from './global'

export class Party2G extends KeyBinding {
  private isPressed2: boolean
  private tsSwitch: number
  constructor()
  private aboutPress(): void
  private aboutPressAlt(): void
  private aboutSwitch(): void
  init(): void
  private isCurrentAs(slot: number, cbDone: Fn, cbFail?: Fn): void
  private waitFor(slot: number, callback: Fn)
  private watch(): void
}
