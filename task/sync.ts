import $ from 'fire-keeper'
import _ from 'lodash'

// interface

type Option = {
  title: string
  value: string
}

// function

async function ask_(
  source: string,
  target: string
): Promise<string> {

  const isExisted = [
    await $.isExisted_(source),
    await $.isExisted_(target),
  ]

  const mtime: [number, number] = [0, 0]
  if (isExisted[0]) {
    const stat = await $.stat_(source)
    mtime[0] = stat
      ? stat.mtimeMs
      : 0
  }
  if (isExisted[1]) {
    const stat = await $.stat_(target)
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
    $.info('skip')
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

  return $.prompt_({
    default: indexDefault,
    list: choice,
    message: 'and you decide to...',
    type: 'select',
  })
}

async function load_(): Promise<string[]> {

  $.info().pause()
  const listData = await Promise.all(
    (await $.source_('./data/sync/**/*.yaml'))
      .map(source => $.read_(source))
  ) as string[][]
  $.info().resume()

  let result: string[] = []

  for (const data of listData)
    result = [
      ...result,
      ...data,
    ]

  return _.uniq(result)
}

async function main_(): Promise<void> {

  const data = await load_()

  // diff
  for (const line of data) {

    const _list = line.split('@')
    const [path, extra] = [_list[0], _list[1] || '']

    const _list2 = extra.split('/')
    const [namespace, version] = [
      _list2[0] || 'default',
      _list2[1] || 'latest',
    ]

    const source = `./${path}`
    let target = `../midway/${path}`
    const { basename, dirname, extname } = $.getName(target)
    target = `${dirname}/${basename}-${namespace}-${version}${extname}`

    // eslint-disable-next-line no-await-in-loop
    if (await $.isSame_([source, target])) continue

    $.info(`'${source}' is different from '${target}'`)

    // eslint-disable-next-line no-await-in-loop
    const value = await ask_(source, target)
    if (!value) break

    // eslint-disable-next-line no-await-in-loop
    await overwrite_(value, source, target)
  }
}

async function overwrite_(
  value: string,
  source: string,
  target: string
): Promise<void> {

  if (value === 'export') {
    const { dirname, filename } = $.getName(target)
    await $.copy_(source, dirname, filename)
  }

  if (value === 'import') {
    const { dirname, filename } = $.getName(source)
    await $.copy_(target, dirname, filename)
  }
}

// export
export default main_