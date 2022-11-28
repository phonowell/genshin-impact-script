import { Fn } from './global'

export type Name =
  | 'aiming'
  | 'busy'
  | 'chat'
  | 'domain'
  | 'event'
  | 'fishing'
  | 'half-menu'
  | 'loading'
  | 'map'
  | 'menu'
  | 'mini-menu'
  | 'multi'
  | 'normal'
  | 'party'
  | 'playing'
  | 'using-q'
type NameNot = `not-${Name}`

export class SceneG extends EmitterShell {
  private cache: Record<Name, boolean>
  private isFrozen: boolean
  private list: Name[]
  private tsChange: number
  constructor()
  freezeAs(listName: Name[], time: number): void
  init(): void
  is(...names: (Name | NameNot | 'unknown')[]): boolean
  private update(): void
  useEffect(fn: () => Fn, listDeps: (Name | NameNot | 'unknown')[]): void
}
