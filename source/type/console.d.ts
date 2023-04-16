export class ConsoleG {
  private isEnabled: boolean
  private lifetime: 10e3
  private listContent: [number, string, string][]
  namespace: 'console'
  constructor()
  private add(msg: string): void
  private hide(): void
  init(): void
  log(...ipt: unknown[]): void
  private render(): void
  update(): void
}
