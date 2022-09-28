export class DictionaryG {
  data: Record<string, string>
  constructor()
  get(name: string): string
  private load(): void
}
