import { Fn } from './global'

export class ClientG extends KeyBinding {
  isSuspended: boolean
  namespace: 'client'
  constructor()
  init(): void
  private setIcon(name: 'on' | 'off'): void
  suspend(isSuspended: boolean): void
  useActive(fn: () => Fn): void
  useChange(
    listDeps: EmitterShell[],
    fnCheck: () => boolean,
    fnExec: () => Fn,
  ): void
}
