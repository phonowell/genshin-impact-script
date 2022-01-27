import $ from 'fire-keeper'

// function

const main = async () => {
  const mapColor = await $.read<Record<string, string[]>>('./data/character/color.yaml')
  const listName = Object.keys(mapColor)
  if (!listName.length) throw new Error('no color')
  for (const name of listName) {
    const color = mapColor[name]
    const content = (await $.read<Buffer>(`./data/character/${name}.yaml`, { raw: true })).toString().replace(/\r/g, '')
    const result = content.replace(/color\:\s.+?\n/, `color: [${color.join(', ')}]\n`)
    await $.write(`./data/character/${name}.yaml`, result)
  }
  await $.write('./data/character/color.yaml', '')
}

// export
export default main