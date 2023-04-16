export class CameraG extends KeyBinding {
  private count: number
  private isWatching: boolean
  private listKey: ['left', 'right', 'up', 'down']
  namespace: 'camera'
  constructor()
  center(): void
  init(): void
  move(): void
  private watch(): void
}
