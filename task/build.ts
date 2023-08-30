import c2a from 'coffee-ahk'
import { copy, read, remove, write } from 'fire-keeper'

import sort from './sort'
import yaml from './yaml'

// function

const clean = () => remove('./dist')

const compile = (source: string) =>
  c2a(`./source/${source}.coffee`, { salt: 'genshin' })

const main = async () => {
  await yaml()
  await sort()
  await compile('index')
  await clean()
  await pack('index', 'GIS')
}

const pack = async (source: string, target: string) => {
  const pkg = await read<{ version: string }>('./package.json')
  if (!pkg) return
  const { version } = pkg

  const buffer = await read<Buffer>(`./source/${source}.ahk`)

  await write(`./dist/${target}.ahk`, buffer)

  await copy(
    [
      './data/character.ini',
      './data/config.ini',
      './data/readme.url',
      './source/off.ico',
      './source/on.ico',
    ],
    `./dist/${target}_${version}`,
  )

  await copy('./source/data/**/*', (source) =>
    source.replace('/source', `/dist/${target}_${version}`),
  )
}

// export
export default main
