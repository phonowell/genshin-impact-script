type Name =
  | 'aiming'
  | 'free'
  | 'frozen'
  | 'gadget-usable'
  | 'ready'
  | 'single'
  | NameElement
type NameElement = 'cryo' | 'hydro'
type NameNot = `not-${Name}` | `not-${NameElement}`
type NamePossible = Name | NameNot

export class StateG extends EmitterShell {
  private cache: object
  private list: Name[]
  private mapColor: Record<Name, number[][]>
  namespace: 'state'
  constructor()
  private checkElement(name: NameElement): boolean
  private checkIsAiming(): boolean
  private checkIsFree(): boolean
  private checkIsFrozen(list: Name[]): boolean
  checkIsGadgetUsable(): boolean
  private checkIsReady(): boolean
  private checkIsSingle(): boolean
  init(): void
  is(...names: NamePossible[]): boolean
  private makeListName(): Name[]
  private throttle(id: string, interval: number, fn: () => boolean): boolean
  update(): void
}
