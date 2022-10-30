export class ControllerG extends EmitterShell {
  private cache: Record<string, number>
  private isPressed: Record<string, boolean>
  private mapButton: Record<string, number>
  private thresholdStick: 1e4
  private ts: Record<string, number>
  constructor()
  private aboutButton(value: number): void
  private aboutStickX(stick: 'left' | 'right', value: number): void
  private aboutStickY(stick: 'left' | 'right', value: number): void
  private aboutTrigger(trigger: 'left' | 'right', value: number): void
  init(): void
  private registerCross(): void
  private registerLeftStick(): void
  private registerRightStick(): void
  private update(): void
  private watch(): void
}
