declare module 'coffee-ahk' {
  export default function c2a(
    source: string,
    options: { salt: string },
  ): Promise<void>
}
