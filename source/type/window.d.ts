import { WindowShell } from 'shell-ahk/dist/type/windowShell'

type Bounds = {
  x: number
  y: number
  width: number
  height: number
}

export class WindowG extends KeyBinding {
  bounds: Bounds
  id: number
  private isActive: boolean
  isFullScreen: boolean
  isMouseIn: boolean
  position: [number, number]
  window: WindowShell
  constructor()
  private checkActive(): void
  private checkMousePosition(): void
  close(): void
  focus(): void
  private getState(): void
  private getTaskBarBounds(): Bounds
  init(): void
  private main(): void
  private setPosition(): void
  private setStyle(): void
  private watch(): void
}
