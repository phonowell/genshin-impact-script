type Item = {
  cdE: [number, number]
  cdQ: number
  color: number[][]
  constellation: number
  durationE: [number, number]
  durationQ: number
  onLongPress: string
  onSideButton1: string
  onSideButton2: string
  onSwitch: string
  star: number
  typeE: TypeE
  typeSprint: TypeSprint
  vision: string
  weapon: string
}

type TypeE =
  | 0
  | 1 // amber beidou fischl jean keqing
  | 2 // diluc nilou
  | 3 // tartaglia
  | 4 // sayu yelan

type TypeSprint = 0 | 1 // mona kamisato_ayaka

type ItemRaw = {
  'cd-e': number | [number, number]
  'cd-q': number
  color: number[][]
  constellation: number
  'duration-e': number | [number, number]
  'duration-q': number
  'on-long-press': string
  'on-side-button-1': string
  'on-side-button-2': string
  'on-switch': string
  star: number
  'type-e': TypeE
  'type-sprint': TypeSprint
  vision: string
  weapon: string
}

export type dataRaw = Record<string, ItemRaw>

export class CharacterG {
  data: Record<string, Item>
  private source: 'character.ini'
  constructor()
  get<T extends keyof Item | void = void>(
    name: string,
    key?: T,
  ): T extends string ? Item[T] : Item
  private isTuple(ipt: number[]): ipt is [number, number]
  load(): void
  private makeValueIntoArray(value: number | number[]): number[]
  private padArray(list: number[]): [number, number]
  private pickFromFile(name: string, key: string): string | number
  private read(ipt: string, defaultValue?: string | number): string
}
