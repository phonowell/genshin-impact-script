import { WindowShell } from 'shell-ahk/dist/type/windowShell'

type Bounds = {
  x: number
  y: number
  width: number
  height: number
}

export class WindowG extends KeyBinding {
  bounds: Bounds
  private isActive: boolean
  isFullScreen: boolean
  position: [number, number]
  window: WindowShell
  constructor()
  close(): void
  focus(): void
  private getState(): void
  private getTaskBarBounds(): Bounds
  init(): void
  private isMouseInside(): boolean
  private main(): void
  private setPosition(): void
  private setStyle(): void
  private watch(): void
}