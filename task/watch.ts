import c2a from 'coffee-ahk'
import $sleep from 'fire-keeper/sleep'
import $watch from 'fire-keeper/watch'

// function

class Compiler {

  delay = 1e3
  interval = 5e3
  isBusy = false
  list: Set<string> = new Set()

  constructor() {
    setInterval(this.next.bind(this), this.interval)
  }

  async next() {

    if (!this.list.size) return
    if (this.isBusy) return

    this.isBusy = true

    const source = [...this.list][0]
    this.list.delete(source)

    await c2a(source, {
      salt: 'genshin',
    })
      .catch(e => console.error(e))
      .finally(async () => {
        await $sleep(this.delay)
        this.isBusy = false
      })
  }
}

const main = () => {
  process.on('uncaughtException', e => console.error(e))
  const compiler = new Compiler()
  $watch('./source/**/*.coffee', () => compiler.list.add('./source/index.coffee'))
}

// export
export default main