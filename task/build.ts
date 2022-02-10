import $ from 'fire-keeper'
import c2a from 'coffee-ahk'

// function

const clean = () => $.remove('./dist')

const compile = () => c2a('./source/index.coffee', { salt: 'genshin' })

const main = async () => {
  await compile()
  await clean()
  await pack()
}

const pack = async () => {

  const { version } = await $.read<{ version: string }>('./package.json')

  const buffer = await $.read<Buffer>('./source/index.ahk')
  const dir = `./dist/GIS_${version}`

  await $.write('./dist/GIS.ahk', buffer)

  await $.copy([
    './data/config.ini',
    './data/readme.url',
    './source/off.ico',
    './source/on.ico',
  ], dir)
}

// export
export default main