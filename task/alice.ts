import $argv from 'fire-keeper/argv'
import $getBasename from 'fire-keeper/getBasename'
import $prompt from 'fire-keeper/prompt'
import $source from 'fire-keeper/source'
import _compact from 'lodash/compact'

// interface

type FnAsync = <T>() => Promise<T>

// function

const ask = async (
  list: string[],
): Promise<string> => {

  const answer = await $prompt({
    id: 'default-task',
    list,
    message: 'select a task',
    type: 'auto',
  })
  if (!answer) return ''
  if (!list.includes(answer)) return ask(list)
  return answer
}

const load = async (): Promise<string[]> => {

  const listSource = await $source([
    './task/*.js',
    './task/*.ts',
    '!*.d.ts',
  ])

  const listResult = listSource.map(source => {
    const basename = $getBasename(source)
    return basename === 'alice'
      ? ''
      : basename
  })

  return _compact(listResult)
}

const main = async (): Promise<void> => {

  const task = $argv()._[0]
    ? $argv()._[0].toString()
    : await ask(await load())

  if (!task) return
  await run(task)
}

const run = async (
  task: string,
): Promise<void> => {

  const [source] = await $source([
    `./task/${task}.js`,
    `./task/${task}.ts`,
  ])

  const fn: FnAsync = (await import(source)).default
  await fn()
}

// execute
main()