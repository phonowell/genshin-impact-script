export class ControllerG extends EmitterShell {
  private cache: {
    n: Record<string, number>
    s: Record<string, string>
  }
  private isPressed: Record<string, boolean>
  private listLeftStick: [
    ['left-stick-left', 'a', 'left'],
    ['left-stick-right', 'd', 'right'],
    ['left-stick-up', 'w', 'up'],
    ['left-stick-down', 's', 'down'],
  ]
  private listRightStick: [
    ['right-stick-left', 'left'],
    ['right-stick-right', 'right'],
    ['right-stick-up', 'up'],
    ['right-stick-down', 'down'],
  ]
  private mapButton: Record<string, number>
  namespace: 'controller'
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
