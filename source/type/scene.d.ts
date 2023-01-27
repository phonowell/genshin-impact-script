import { Fn } from './global'

export type Name =
  | 'aiming'
  | 'chat'
  | 'domain'
  | 'event'
  | 'fishing'
  | 'free'
  | 'half-menu'
  | 'loading'
  | 'map'
  | 'menu'
  | 'mini-menu'
  | 'normal'
  | 'party'
  | 'playing'
  | 'single'
type NameNot = `not-${Name}`
type NamePossible = Name | NameNot | 'unknown'

export class SceneG extends EmitterShell {
  private list: Name[]
  constructor()
  init(): void
  is(...names: NamePossible[]): boolean
  private update(): void
  useExact(
    listDeps: NamePossible[] | (() => boolean),
    fn: () => Fn
  ): void
  private watch(): void
}
