export class DictionaryG {
  data: Record<string, string>
  namespace: 'dictionary'
  constructor()
  get(name: string): string
  init(): void
  private load(): void
  noop(): void
}
