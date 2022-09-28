export class IndicatorG extends EmitterShell {
  private cacheCost: Record<string, number[]>
  private cacheCount: Record<string, number>
  private cacheTs: Record<string, number>
  constructor()
  private clear():void
  getCost(name: string): number
  getCount(name: string): number
  setCost(name: string, step: 'start' | 'end'): void
  setCount(name: string): void
  watch(): void
}