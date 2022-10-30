export class CameraG extends KeyBinding {
  private count: number
  private isWatching: boolean
  private listKey: ['left', 'right', 'up', 'down']
  constructor()
  init(): void
  move(): void
  private watch(): void
}
