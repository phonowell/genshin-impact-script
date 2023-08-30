import { getBasename, glob, read, write } from 'fire-keeper'
import { capitalize } from 'lodash'

// variable

const mapTrans: Record<string, string> = {
  'color-manager': 'ColorManager',
  console: 'console',
  menu: 'Menu2',
  window: 'Window2',
}

// function

const getContentByFunc = (content: string, name: string) => {
  const reg = new RegExp(`${name}: ->([\\s\\S]*?)(?:\n  ###|\n[A-Z|a-z])`)
  const match = content.match(reg)
  if (!match) return []
  const listA = match[1]
    .split('\n')
    .filter((line) => !!line)
    .filter((line) => !line.trim().startsWith('#'))

  const listB: string[] = []
  let indentCache = 0
  listA.forEach((line) => {
    const indent = line.length - line.trimStart().length

    if (!indentCache) {
      listB.push(line)
      if (line.endsWith('>')) indentCache = indent
      return
    }

    if (indent > indentCache) return

    indentCache = 0
    listB.push(line)

    if (line.endsWith('>')) indentCache = indent
  })

  return listB.map((line) => line.replace(/(-|=)>.*/, '$1>'))
}

const getContents = (content: string) => {
  const list: string[] = []

  const contInit = getContentByFunc(content, 'init')
  list.push(...contInit)

  contInit.forEach((line) => {
    const line2 = line.trim()
    if (!line2.startsWith('@')) return
    if (!line2.endsWith('()')) return

    const name = line2.replace('@', '').replace('()', '')
    if (name.includes(' ')) return
    if (['on', 'off', 'registerEvent'].includes(name)) return

    list.push('# ---', ...getContentByFunc(content, name))
  })

  return list
}

const getDepends = (listCont: string[], listName: string[]) => {
  const content = listCont.join('')

  const list: string[] = []
  for (const name of listName) {
    if (content.includes(`${name}.`)) list.push(name)
  }

  return list
}

const getList = async () => {
  const listA = await glob([
    './source/*.coffee',
    '!./source/index.coffee',
    '!./source/misc.coffee',
    // ignore
    '!./source/controller.coffee',
  ])

  const listB: [string, string[], string[]][] = []
  const listC: string[] = []

  for (const source of listA) {
    const content = await read<string>(source)
    if (!content) continue
    if (content.includes('init: ->')) {
      listB.push([getName(source), getContents(content.replace(/\r/g, '')), []])
      continue
    }
    listC.push(getBasename(source))
  }

  const listName = listB.map((item) => item[0])

  for (const item of listB) {
    item[2].push(...getDepends(item[1], listName))
  }

  return [listB, listC] as const
}

const getName = (source: string) => {
  const basename = getBasename(source)
  if (mapTrans[basename]) return mapTrans[basename]
  return capitalize(basename)
}

const getName2 = (name: string) => {
  const listKey = Object.keys(mapTrans)
  const listValue = Object.values(mapTrans)
  const index = listValue.indexOf(name)
  if (index !== -1) return listKey[index]
  return name.toLowerCase()
}

const main = async () => {
  const [listA, listB] = await getList()
  const listC = sort(listA)
  await saveIndex([...listB, ...listC])
  await saveMisc(listC)
}

const saveIndex = async (listName: string[]) => {
  const source = './source/index.coffee'

  const content = await read<string>(source)
  if (!content) return

  const result = content.replace(
    /# ---start---[\s\S]*# ---end---/,
    [
      '# ---start---',
      ...listName.map((name) => `import './${getName2(name)}'`),
      '# ---end---',
    ].join('\n'),
  )
  await write(source, result)
}

const saveMisc = async (listName: string[]) => {
  const source = './source/misc.coffee'

  const content = await read<string>(source)
  if (!content) return

  const result = content.replace(
    /# ---start---[\s\S]*# ---end---/,
    [
      '# ---start---',
      ...listName.map((name) => `    ${name}`),
      '    # ---end---',
    ].join('\n'),
  )
  await write(source, result)
}

const sort = (listI: [string, string[], string[]][]) => {
  const listO: string[] = []

  const next = () => {
    listI.forEach((item) => {
      const [name, , depends] = item
      const isOut = depends.some((d) => !listO.includes(d))
      if (!isOut) {
        if (!listO.includes(name)) listO.push(name)
      }
    })
    if (listO.length !== listI.length) next()
  }
  next()

  return listO
}

// export
export default main
