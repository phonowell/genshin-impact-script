export class UtilityG {
  makeList<T extends 'number' | 'string'>(
    type: T,
    list: unknown,
  ): T extends 'number' ? number[] : T extends 'string' ? string[] : unknown[]
}
