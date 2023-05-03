import c from 'fire-compiler'
import $ from 'fire-keeper'

// function

const main = async () => {
  const listYaml = await $.glob('./source/data/**/*.json')
  await $.remove(listYaml)
  // for (const source of listYaml) {
  //   await c.compile(source)
  // }
}

// export
export default main
