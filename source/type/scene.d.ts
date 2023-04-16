import { Fn } from './global'

export type Name =
  | 'chat'
  | 'dialogue'
  | 'domain'
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
  namespace: 'scene'
  constructor()
  init(): void
  is(...names: NamePossible[]): boolean
  update(): void
  useExact(listDeps: NamePossible[], fn: () => Fn): void
}
