export class IndicatorG extends EmitterShell {
  private cacheCost: Record<string, number[]>
  private cacheCount: Record<string, number>
  private cacheTs: Record<string, number>
  namespace: 'indicator'
  constructor()
  private clear(): void
  getCost(name: string): number
  getCount(name: string): number
  init(): void
  setCost(name: string, step: 'start' | 'end'): void
  setCount(name: string): void
  watch(): void
}
