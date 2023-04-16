import c2a from 'coffee-ahk'
import $ from 'fire-keeper'

import sort from './sort'

// function

const clean = () => $.remove('./dist')

const compile = (source: string) =>
  c2a(`./source/${source}.coffee`, { salt: 'genshin' })

const main = async () => {
  await sort()
  await compile('index')
  await clean()
  await pack('index', 'GIS')
}

const pack = async (source: string, target: string) => {
  const pkg = await $.read<{ version: string }>('./package.json')
  if (!pkg) return
  const { version } = pkg

  const buffer = await $.read<Buffer>(`./source/${source}.ahk`)
  const dir = `./dist/${target}_${version}`

  await $.write(`./dist/${target}.ahk`, buffer)

  await $.copy(
    [
      './data/character.ini',
      './data/config.ini',
      './data/readme.url',
      './source/off.ico',
      './source/on.ico',
    ],
    dir,
  )
}

// export
export default main
