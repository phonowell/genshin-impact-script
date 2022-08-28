import $ from 'fire-keeper'
import c2a from 'coffee-ahk'

// function

const clean = () => $.remove('./dist')

const compile = (source: string) =>
  c2a(`./source/${source}.coffee`, { salt: 'genshin' })

const main = async () => {
  await compile('index')
  // await compile('slim')
  await clean()
  await pack('index', 'GIS')
  // await pack('slim', 'GISS')
}

const pack = async (source: string, target: string) => {
  const { version } = await $.read<{ version: string }>('./package.json')

  const buffer = await $.read<Buffer>(`./source/${source}.ahk`)
  const dir = `./dist/${target}_${version}`

  await $.write(`./dist/${target}.ahk`, buffer)

  await $.copy(
    [
      './data/config.ini',
      './data/readme.url',
      './source/off.ico',
      './source/on.ico',
    ],
    dir
  )
}

// export
export default main
