import $ from 'fire-keeper'
import c2a from 'coffee-ahk'

// function

const clean = () => $.remove('./dist')

const compile = () => c2a('./source/index.coffee', { salt: 'genshin' })

const main = async (): Promise<void> => {
  await compile()
  await clean()
  await pack()
}

const pack = async (): Promise<void> => {

  const { version } = await $.read<{ version: string }>('./package.json')

  const buffer = await $.read<Buffer>('./source/index.ahk')
  const dirCN = `./dist/Genshin_Impact_Script_CN_${version}`
  const dirEN = `./dist/Genshin_Impact_Script_EN_${version}`

  await $.write('./dist/start.ahk', buffer)

  await $.copy([
    './data/config.ini',
    './data/readme.url',
    './source/off.ico',
    './source/on.ico',
  ], dirCN)

  await $.copy('./data/config-en.ini', dirEN, 'config.ini')
  await $.copy([
    './data/readme.url',
    './source/off.ico',
    './source/on.ico',
], dirEN)
}

// export
export default main