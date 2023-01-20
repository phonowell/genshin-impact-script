import { Fn } from './global'

export class TimerG {
  cacheTimer: Record<string, Fn>
  cacheTs: Record<string, number>
  constructor()
  add(...args: [string, number, Fn] | [number, Fn]): void
  has(id: string): boolean
  hasElapsed(id: string, time: number): boolean
  private isTuple(ipt: unknown[]): ipt is [string, number, Fn]
  loop(...args: [string, number, Fn] | [number, Fn]): void
  private pick(args: [string, number, Fn] | [number, Fn]): [string, number, Fn]
  reset(): void
  remove(id: string): void
}
