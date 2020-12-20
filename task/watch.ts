import $ from 'fire-keeper'
import c2a from 'coffee-ahk'
import throttle from 'lodash/throttle'

// function

const compile_ = throttle(async (): Promise<void> => {

  await c2a('./source/index.coffee', {
    salt: 'genshin'
  })
}, 1e3, { trailing: true })

function main(): void {

  $.watch('./source/**/*.coffee', compile_)
}

// export
export default main