import { Fn } from './global'

export type Name =
  | 'chat'
  | 'dialogue'
  | 'half-menu'
  | 'loading'
  | 'map'
  | 'menu'
  | 'mini-menu'
  | 'normal'
  | 'party'
  | 'playing'
type NameNot = `not-${Name}`
type NamePossible = Name | NameNot | 'unknown'

export class SceneG extends EmitterShell {
  private list: Name[]
  namespace: 'scene'
  constructor()
  init(): void
  is(name: NamePossible): boolean
  update(): void
  useExact(name: NamePossible, fn: () => Fn): void
}
