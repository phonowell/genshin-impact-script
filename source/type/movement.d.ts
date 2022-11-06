export class MovementG extends KeyBinding {
  private count: {
    forward: number
    move: number
  }
  private isForwarding: boolean
  isMoving: boolean
  private ts: {
    forward: number
  }
  constructor()
  init(): void
  private onAim(step: 'start' | 'end'): void
  private onUnhold(step: 'start' | 'end'): void
  sprint(): void
  private startForward(): void
  private stopForward(): void
  private toggleForward(key: string): void
}
