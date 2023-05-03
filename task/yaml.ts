import c from 'fire-compiler'
import $ from 'fire-keeper'
import iconv from 'iconv-lite'

// function

const main = async () => {
  await $.remove('./source/data/**/*.json')

  const listYaml = await $.glob('./data/**/*.yaml')
  for (const source of listYaml) {
    const target = source
      .replace('/data', '/source/data')
      .replace('.yaml', '.json')
    await c.compileYaml(source as `${string}.yaml`, target)
  }

  const listJson = await $.glob('./source/data/**/*.json')
  for (const source of listJson) {
    const content = await $.read(source, { raw: true })
    if (!content) return
    const result = iconv
      .encode(content.toString(), 'utf8', {
        addBOM: true,
      })
      .toString()
    await $.write(source, result)
  }
}

// export
export default main
