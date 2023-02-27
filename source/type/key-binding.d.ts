type Name = string
type Key = string

export class KeyBinding extends EmitterShell {
  private mapFired: Record<Name, boolean>
  private mapGroup: Record<Name, Key[]>
  private mapPressed: Record<Key, boolean>
  private mapPrevented: Record<Key, boolean>
  constructor()
  private end(name: Name, key: Key): void
  private log(name: Name, key: Key, step: string, message: unknown): void
  private registerEvent(name: Name, key: Key, isPrevented?: boolean): void
  private start(name: Name, key: Key): void
  private unregisterEvent(name: Name, key: Key): void
}

declare global {
  interface KeyBinding {
    on: <T>(key: T, callback: (key: T, ...args: unknown[]) => unknown) => void
  }
}
