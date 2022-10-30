export class DictionaryG {
  data: Record<string, string>
  constructor()
  get(name: string): string
  init(): void
  private load(): void
}
