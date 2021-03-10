import $argv from 'fire-keeper/argv'
import $getBasename from 'fire-keeper/getBasename'
import $prompt_ from 'fire-keeper/prompt_'
import $source_ from 'fire-keeper/source_'
import _compact from 'lodash/compact'

// interface

type FnAsync = () => Promise<unknown>

// function

const ask_ = async (
  list: string[]
): Promise<string> => {

  const answer = await $prompt_({
    id: 'default-task',
    list,
    message: 'select a task',
    type: 'auto',
  })
  if (!answer) return ''
  if (!list.includes(answer)) return ask_(list)
  return answer
}

const load_ = async (): Promise<string[]> => {

  const listSource = await $source_([
    './task/*.js',
    './task/*.ts',
    '!*.d.ts',
  ])

  const listResult = listSource.map((source) => {
    const basename = $getBasename(source)
    return basename === 'alice'
      ? ''
      : basename
  })

  return _compact(listResult)
}

const main_ = async (): Promise<void> => {

  const task = $argv()._[0]
    ? $argv()._[0].toString()
    : await (async () => ask_(await load_()))()

  if (!task) return
  await run_(task)
}

const run_ = async (
  task: string
): Promise<void> => {

  const [source] = await $source_([
    `./task/${task}.js`,
    `./task/${task}.ts`,
  ])

  const fn_: FnAsync = (await import(source)).default
  await fn_()
}

// execute
main_()