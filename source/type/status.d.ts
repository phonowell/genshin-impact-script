type Name = 'cryo' | 'hydro'

export class Status2G extends EmitterShell {
  private list: Name[]
  private mapColor: Record<Name, number[][]>
  private mapTs: Record<Name, number>
  constructor()
  private add(name: Name): void
  private check(name: Name): boolean
  has(name: Name): boolean
  init(): void
  private remove(name: Name): void
  private update(): void
}
