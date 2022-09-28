import { PointLike } from './global'

export class PickerG extends KeyBinding {
  private tsPick: number
  constructor()
  private checkShape(p: [number, number]): boolean
  private click(p: PointLike): void
  private find(): void
  private findTitleColor(y: number): number | false
  private init(): void
  private listen(): void
  private next(): void
  private skip(): boolean
  private watch(): void
}
