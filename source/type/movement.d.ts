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
  private aboutAim(): void
  private aboutMove(): void
  private aboutSprint(): void
  private aboutUnhold(): void
  private aboutWalk(): void
  init(): void
  sprint(): void
  private startForward(): void
  private stopForward(): void
  private toggleForward(key: string): void
}
