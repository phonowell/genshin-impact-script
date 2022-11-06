import { Fn } from './global'

export class TacticG extends KeyBinding {
  private intervalLong: 100
  private intervalShort: 50
  private isActive: boolean
  constructor()
  private atDuration(cbA: Fn, cbB: Fn, isNot: boolean): void
  private atMovement(cbA: Fn, cbB: Fn, isNot: boolean): void
  private atReady(cbA: Fn, cbB: Fn, isNot: boolean)
  private delay(time: number, callback: Fn): void
  private doAim(callback: Fn): void
  private doAimTwice(callback: Fn): void
  private doAttack(isCharged: boolean, callback: Fn): void
  private doJump(callback: Fn): void
  private doSprint(callback: Fn): void
  private doUseE(isHolding: boolean, callback: Fn): void
  private doUseEE(callback: Fn): void
  private doUseQ(callback: Fn): void
  private end(list: string[][], callback?: Fn): void
  private execute(list: string[][], g?: number, i?: number, callback?: Fn)
  private format(str: string): string[][]
  private get(list: string[][], g?: number, i?: number): string
  init(): void
  start(line: string, callback?: Fn): void
  private stop(): void
}
