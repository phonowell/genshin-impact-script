import $ from 'fire-keeper'

// interface

type Character = {
  cd: number | [number, number]
  color: number
  mode: number
}

// function

async function main_(): Promise<void> {

  const data = await $.read_('./data/character.yaml') as Record<string, Character>
  const listContent: string[] = []

  listContent.push(
    '[index]',
    `index = ${Object.keys(data).join(',')}`,
  )

  Object.keys(data).forEach(name => {
    const char = data[name]
    listContent.push(
      '',
      `[${name}]`,
    )

    // cd
    if (!(char.cd instanceof Array))
      char.cd = [char.cd || 0, char.cd || 0]
    if (char.cd[0] + char.cd[1])
      listContent.push(`cd = ${char.cd.join(',')}`)

    // color
    if (char.color)
      listContent.push(`color = ${char.color}`)

    // type
    if (char['type-e'])
      listContent.push(`type-e = ${char['type-e']}`)
  })

  await $.write_('./data/character.ini', listContent.join('\n'))
}

// export
export default main_