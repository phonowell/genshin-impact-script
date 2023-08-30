import { glob, read, write } from 'fire-keeper'

// function

const main = async () => {
  const listSource = await glob([
    './*.js',
    './*.ts',
    './source/**/*.ts',
    './source/**/*.js',
    './source/**/*.tsx',
    './task/*.ts',
  ])
  for (const source of listSource) {
    const content = await read<string>(source)
    if (!content) continue
    const cont = content.replace(/\r/g, '')
    if (cont === content) continue
    await write(source, cont)
  }
}

// export
export default main
