type Item = {
  delay: number
  key: string
  position: string
}

export class RecorderG extends KeyBinding {
  isActive: boolean
  private list: Item[]
  private ts: number
  constructor()
  private record(key: string): void
  private reset(): void
  private save(): void
  private start(): void
  private stop(): void
}
