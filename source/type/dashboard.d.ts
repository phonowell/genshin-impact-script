export class DashboardG {
  // constructor()
  private format(n: number): string
  private hide(n: number): void
  private render(n: number, message: string): void
  private renderProgress(
    n: number,
    m: number,
    method: 'ceil' | 'floor' | 'round',
  ): string
  update(): void
}
