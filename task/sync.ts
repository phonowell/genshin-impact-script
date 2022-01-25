import $copy from 'fire-keeper/copy'
import $getName from 'fire-keeper/getName'
import $info from 'fire-keeper/info'
import $isExisted from 'fire-keeper/isExisted'
import $isSame from 'fire-keeper/isSame'
import $prompt from 'fire-keeper/prompt'
import $read from 'fire-keeper/read'
import $source from 'fire-keeper/source'
import $stat from 'fire-keeper/stat'
import $uniq from 'lodash/uniq'

// interface

type Option = {
  title: string
  value: string
}

// function

const ask = async (
  source: string,
  target: string,
): Promise<string> => {

  const isExisted = [
    await $isExisted(source),
    await $isExisted(target),
  ]

  const mtime: [number, number] = [0, 0]
  if (isExisted[0]) {
    const stat = await $stat(source)
    mtime[0] = stat
      ? stat.mtimeMs
      : 0
  }
  if (isExisted[1]) {
    const stat = await $stat(target)
    mtime[1] = stat
      ? stat.mtimeMs
      : 0
  }

  const choice: Option[] = []

  if (isExisted[0])
    choice.push({
      title: [
        'overwrite, export',
        mtime[0] > mtime[1] ? '(newer)' : '',
      ].join(' '),
      value: 'export',
    })

  if (isExisted[1])
    choice.push({
      title: [
        'overwrite, import',
        mtime[1] > mtime[0] ? '(newer)' : '',
      ].join(' '),
      value: 'import',
    })

  if (!choice.length) {
    $info('skip')
    return 'skip'
  }

  let indexDefault = -1
  for (let i = 0; i < choice.length; i++) {
    if (!choice[i].title.includes('(newer)')) continue
    indexDefault = i
    break
  }

  choice.push({
    title: 'skip',
    value: 'skip',
  })

  return $prompt({
    default: indexDefault,
    list: choice,
    message: 'and you decide to...',
    type: 'select',
  })
}

const load = async (): Promise<string[]> => {

  $info.pause()
  const listSource = await $source('./data/sync/**/*.yaml')
  const listData = (await Promise.all(listSource.map(source => $read<string[]>(source))))
  $info.resume()

  let result: string[] = []

  for (const data of listData)
    result = [
      ...result,
      ...data,
    ]

  return $uniq(result)
}

const main = async (): Promise<void> => {

  const data = await load()

  // diff
  for (const line of data) {

    const [path, extra] = line.split('@')

    const list = (extra || '').split('/')
    const [namespace, version] = [
      list[0] || 'default',
      list[1] || 'latest',
    ]

    const source = `./${path}`
    let target = `../midway/${path}`
    const { basename, dirname, extname } = $getName(target)
    target = `${dirname}/${basename}-${namespace}-${version}${extname}`

    // eslint-disable-next-line no-await-in-loop
    if (await $isSame([source, target])) continue

    $info(`'${source}' is different from '${target}'`)

    // eslint-disable-next-line no-await-in-loop
    const value = await ask(source, target)
    if (!value) break

    // eslint-disable-next-line no-await-in-loop
    await overwrite(value, source, target)
  }
}

const overwrite = async (
  value: string,
  source: string,
  target: string,
): Promise<void> => {

  if (value === 'export') {
    const { dirname, filename } = $getName(target)
    await $copy(source, dirname, filename)
  }

  if (value === 'import') {
    const { dirname, filename } = $getName(source)
    await $copy(target, dirname, filename)
  }
}

// export
export default main