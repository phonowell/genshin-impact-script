export class PickerG extends KeyBinding {
  private listShapeForbidden: [number, number][]
  private tsPick: number
  constructor()
  private checkShape(p: [number, number]): boolean
  private find(): void
  private findTitleColor(y: number): number | false
  init(): void
  private listen(): void
  next(): void
  private skip(): boolean
}
