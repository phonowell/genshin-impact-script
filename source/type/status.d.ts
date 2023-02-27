type Name = 'aiming' | 'free' | NameElement
type NameElement = 'cryo' | 'hydro'

export class Status2G extends EmitterShell {
  private list: Name[]
  private mapColor: Record<Name, number[][]>
  constructor()
  private checkElement(name: NameElement): boolean
  private checkIsAiming(): boolean
  private checkIsFree(): boolean
  has(name: Name): boolean
  init(): void
  private makeListName(): Name[]
  update(): void
}
