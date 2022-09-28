type Data = {
  debug: ['enable']
  basic: ['arguments', 'path', 'process']
  'better-jump': ['enable']
  'better-pickup': ['enable', 'use-fast-pickup', 'use-quick-skip']
  idle: ['use-time', 'use-mouse-move-out']
  'skill-timer': ['enable']
  sound: ['use-beep', 'use-mute-when-idle']
  controller: ['enable']
  misc: ['use-transparency-when-idle']
}

type Keys<K extends keyof Data> = K extends keyof Data
  ? `${K}/${Data[K][number]}`
  : never
type Key = Keys<keyof Data>

export class ConfigG {
  data: Record<Key, string | number>
  private source: 'config.ini'
  constructor()
  detectPath(): void
  detectRegion(): true | void
  get(ipt: Key): string | number
  private load(): void
  private read(ipt: Key, defaultValue?: string): string | number
  private register(ipt: Key, key?: string): void
  private set(ipt: Key, value: string | number): void
  private toggle(ipt: Key): void
  private write(ipt: Key, value: string | number): void
}
