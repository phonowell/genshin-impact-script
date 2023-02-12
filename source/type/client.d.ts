import { Fn } from './global'

export class ClientG extends KeyBinding {
  isSuspended: boolean
  version: number
  constructor()
  init(): void
  private setIcon(name: 'on' | 'off'): void
  private suspend(isSuspended: boolean): void
  useActive(fn: () => Fn): void
}
