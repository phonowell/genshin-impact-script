type Direction = 'left' | 'right' | 'up' | 'down'

export class CursorG {
  private map: Record<Direction, boolean>
  speed: number
  constructor()
  end(direction: Direction, speed: number): void
  init(): void
  private move(): void
  start(direction: Direction, speed: number): void
  private stop(): void
  private watch(): void
}
