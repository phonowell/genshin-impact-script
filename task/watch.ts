import c2a from 'coffee-ahk'
import debounce from 'lodash/debounce'
import watch from 'fire-keeper/watch'

// variable

let isBusy = false
let timer: NodeJS.Timeout | number = 0

// function

const compile_ = debounce(async (): Promise<void> => {

  if (isBusy) {
    clearTimeout(timer as NodeJS.Timeout)
    timer = setTimeout(compile_, 5e3)
    return
  }
  isBusy = true

  await c2a('./source/index.coffee', {
    salt: 'genshin',
  })

  isBusy = false
}, 3e3)

function main(): void {

  process.on('uncaughtException', e => console.error(e))
  watch('./source/**/*.coffee', compile_)
}

// export
export default main