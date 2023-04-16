export class MovementG extends KeyBinding {
  direction: string[]
  isForwarding: boolean
  isMoving: boolean
  namespace: 'movement'
  constructor()
  private aboutAim(): void
  private aboutForward(): void
  private aboutMove(): void
  private aboutUnhold(): void
  init(): void
  private report(): void
  sprint(): void
  private startForward(): void
  stopForward(): void
}
