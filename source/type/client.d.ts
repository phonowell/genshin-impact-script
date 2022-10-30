import { WindowShell } from 'shell-ahk/dist/type/windowShell'

export class ClientG extends KeyBinding {
  height: number
  isActive: boolean
  isFullScreen: boolean
  isSuspended: boolean
  position: [number, number]
  width: number
  window: WindowShell
  x: number
  y: number
  constructor()
  private getState(): void
  private getTaskBarBounds(): [number, number, number, number]
  init(): void
  private isMouseInside(): boolean
  private main(): void
  private reset(): void
  private setPosition(): void
  private setStyle(): void
  private suspend(isSuspended: boolean): void
  private update(): void
  private watch(): void
}
