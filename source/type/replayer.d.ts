import { Fn } from './global'

type Item = [string, string, string]

export class ReplayerG {
  isActive: boolean
  private token: 'replayer/next'
  constructor()
  private asMark(list: string[], callback: Fn): void
  private next(list: Item[], i: number, callback?: Fn): void
  private start(key: string, callback?: Fn): void
  private stop(): void
}
