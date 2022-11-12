type Name =
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
  private aboutHalfMenu(): Name[]
  private aboutMenu(): Name[]
  private aboutNormal(): Name[]
  private check(): Name[]
  private checkIsAiming(): boolean
  private checkIsBusy(): boolean
  private checkIsChat(): boolean
  private checkIsDomain(): boolean
  private checkIsEvent(): boolean
  private checkIsHalfMenu(): boolean
  private checkIsLoading(): boolean
  private checkIsMap(): boolean
  private checkIsMenu(): boolean
  private checkIsMiniMenu(): boolean
  private checkIsMulti(): boolean
  private checkIsNormal(): boolean
  private checkIsParty(): boolean
  private checkIsPlaying(): boolean
  freezeAs(listName: Name[], time: number): void
  init(): void
  is(...names: (Name | NameNot | 'unknown')[]): boolean
  private makeListName(...names: Name[]): Name[]
  private throttle(name: Name, time: number, callback: () => boolean): boolean
  private update(): void
}
