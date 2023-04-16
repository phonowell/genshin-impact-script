type Name = 'aiming' | 'free' | 'frozen' | 'ready' | NameElement
type NameElement = 'cryo' | 'hydro'

export class StateG extends EmitterShell {
  private list: Name[]
  private mapColor: Record<Name, number[][]>
  namespace: 'state'
  constructor()
  private checkElement(name: NameElement): boolean
  private checkIsAiming(): boolean
  private checkIsFree(): boolean
  private checkIsFrozen(list: Name[]): boolean
  private checkIsReady(): boolean
  init(): void
  is(name: Name): boolean
  private makeListName(): Name[]
  update(): void
}
