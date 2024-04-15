import { exec, read } from 'fire-keeper'

// interface

type Pkg = {
  dependencies?: Record<string, string>
  devDependencies?: Record<string, string>
}

type Result = {
  current: string
  latest: string
  wanted: string
  isDeprecated: boolean
  dependencyType: 'dependencies' | 'devDependencies'
}

// functions

const getListLocked = async () => {
  const pkg = await read<Pkg>('./package.json')
  if (!pkg) return []

  const listLocked = [
    ...Object.entries(pkg.dependencies ?? {}),
    ...Object.entries(pkg.devDependencies ?? {}),
  ]
    .filter((it) => !Number.isNaN(Number(it[1][0])))
    .map((it) => it[0])

  return listLocked
}

const main = async () => {
  await updateDeps()
}

const updateDeps = async () => {
  const [, raw] = await exec('pnpm outdated --json')
  const result = JSON.parse(raw) as Record<string, Result>

  const listLocked = await getListLocked()
  const listName = Object.entries(result)
    .filter((it) => {
      const [name, data] = it
      if (data.isDeprecated) return false
      if (listLocked.includes(name)) return false
      if (name.endsWith('react') || name.endsWith('react-dom')) return false
      return true
    })
    .map((it) => it[0])
  if (!listName.length) return

  const listCmd = listName.map((name) => `pnpm i ${name}@latest`)
  await exec([...listCmd])
}

// export
export default main
