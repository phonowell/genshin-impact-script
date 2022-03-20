import $ from 'fire-keeper'
import sortBy from 'lodash/sortBy'

// variable

const listDeps = [
  'Character',
  'Client',
  'ColorManager',
  'Config',
  'Fishing',
  'Gdip',
  'Hud',
  'KeyBinding',
  'Menu',
  'Movement',
  'Party',
  'Picker',
  'Player',
  'Point',
  'Scene',
  'Skill',
  'Sound',
  'Tactic',
  'Timer',
  'Trial',
  'Upgrader',
  'console',
] as const

// function

const main = async () => {
  const listResult: string[] = []
  const listSource = await $.source('./source/*.coffee')
  for (const source of listSource) {
    const content = await $.read<string>(source)
    const name = $.getBasename(source)
    const listRes = listDeps.filter(key => {
      const cont = content.toLowerCase()
      const k = key.toLowerCase()
      const n = name.replace(/\-/g, '').toLowerCase()
      return k !== n && cont.includes(k)
    })
    listResult.push(`- ${name}: ${listRes.join(', ')}`)
  }
  await $.write('./data/deps.yaml', sortBy(listResult, item => item.length).join('\n'))
}

// export
export default main