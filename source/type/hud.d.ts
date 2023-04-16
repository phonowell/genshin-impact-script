export class HudG {
  private lifetime: 5e3
  private map: Record<string, [number, string]>
  private mapLast: Record<string, string>
  namespace: 'hud'
  constructor()
  private hide(n: number, isForce: boolean): void
  private hideAll(): void
  init(): void
  private makePosition(n: number): [number, number]
  render(n: number, msg: string): void
  reset(): void
  private update(): void
  private watch(): void
}
