type Name = 'aiming' | 'free' | NameElement
type NameElement = 'cryo' | 'hydro'

export class StateG extends EmitterShell {
  private cacheElement: Record<NameElement, boolean>
  private list: Name[]
  private mapColor: Record<Name, number[][]>
  constructor()
  private checkElement(name: NameElement): boolean
  private checkIsAiming(): boolean
  private checkIsFree(): boolean
  init(): void
  is(name: Name): boolean
  private makeListName(): Name[]
  update(): void
}
