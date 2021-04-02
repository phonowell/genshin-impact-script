import c2a from 'coffee-ahk'
import watch from 'fire-keeper/watch'

// function

class Compiler {

  delay = 5e3
  interval = 1e4
  isBusy = false
  list: string[] = []

  constructor() {
    setInterval(() => {
      this.next()
    }, this.interval)
  }

  add(
    path: string
  ): void {

    if (!this.list.includes(path))
      this.list.push(path)
  }

  next(): void {

    if (!this.list?.length) return
    if (this.isBusy) return

    this.isBusy = true

    c2a(this.list.shift() as string, {
      salt: 'genshin',
    })
      .catch(e => {
        console.log(e.stack)
      })
      .finally(() => {
        setTimeout(() => {
          this.isBusy = false
        }, this.delay)
      })
  }
}

const main = (): void => {

  process.on('uncaughtException', e => console.error(e))

  const compiler = new Compiler()

  watch('./source/**/*.coffee', () => {
    compiler.add('./source/index.coffee')
  })
}

// export
export default main