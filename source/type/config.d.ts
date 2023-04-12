type Data = {
  basic: ['arguments', 'path', 'process']
  'better-pickup': ['enable', 'use-fast-pickup', 'use-quick-skip']
  misc: [
    'use-beep',
    'use-better-jump',
    'use-controller',
    'use-debug-mode',
    'use-mute',
    'use-skill-timer',
    'use-tactic',
  ]
}

type Keys<K extends keyof Data> = K extends keyof Data
  ? `${K}/${Data[K][number]}`
  : never
type Key = Keys<keyof Data>

export class ConfigG {
  data: Record<Key, string | number>
  namespace: 'config'
  private source: 'config.ini'
  constructor()
  detectPath(): void
  detectRegion(): true | void
  get(ipt: Key): string | number
  init(): void
  private load(): void
  private read(ipt: Key, defaultValue?: string): string | number
  private register(ipt: Key, key?: string): void
  private set(ipt: Key, value: string | number): void
  private toggle(ipt: Key): void
  private write(ipt: Key, value: string | number): void
}
