type Name = string
type Key = string

export class KeyBinding extends EmitterShell {
  private mapFired: Record<Name, boolean>
  constructor()
  private endEvent(name: Name, key: Key): void
  private log(name: Name, key: Key, step: string, message: unknown): void
  private registerEvent(name: Name, key: Key): void
  private startEvent(name: Name, key: Key): void
  private unregisterEvent(name: Name, key: Key): void
}

declare global {
  interface KeyBinding {
    on: <T>(key: T, callback: (key: T, ...args: unknown[]) => unknown) => void
  }
}
