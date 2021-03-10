import $copy_ from 'fire-keeper/copy_'
import $read_ from 'fire-keeper/read_'
import $remove_ from 'fire-keeper/remove_'
import c2a from 'coffee-ahk'

// function

const compile_ = async (): Promise<void> => {

  await c2a('./source/index.coffee', {
    salt: 'genshin',
  })
}

const main_ = async (): Promise<void> => {

  await compile_()
  await pack_()
}

const pack_ = async (): Promise<void> => {

  const { version } = await $read_('./package.json') as {
    version: string
  }

  await $remove_('./dist')
  await $copy_('./data/config.ini', `./dist/Genshin_Impact_Script_${version}`)
  await $copy_('./source/index.ahk', `./dist/Genshin_Impact_Script_${version}`)
}

// export
export default main_