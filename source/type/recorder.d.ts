type Item = {
  delay: number
  key: string
  position: string
}

export class RecorderG extends KeyBinding {
  isActive: boolean
  private list: Item[]
  private listKey: string[]
  namespace: 'recorder'
  private ts: number
  constructor()
  init(): void
  private record(key: string): void
  private reset(): void
  private save(): void
  private start(): void
  private stop(): void
}
