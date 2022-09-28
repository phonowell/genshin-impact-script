export class KeyBinding extends EmitterShell {
  private isFired: Record<string, boolean>
  private isPressed: Record<string, boolean>
  private map: Record<string, string[]>
  constructor()
  private registerEvent(name: string, key: string, isPrevented?: boolean): void
  private unregisterEvent(name: string, key: string): void
}

declare global {
  interface KeyBinding {
    on: <T>(key: T, callback: (key: T, ...args: unknown[]) => unknown) => void
  }
}
