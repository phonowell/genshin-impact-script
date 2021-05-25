import $exec_ from 'fire-keeper/exec_'
import $read_ from 'fire-keeper/read_'

// interface

type Item = {
  [key: string]: string
}

type Package = {
  dependencies: Item
  devDependencies: Item
  peerDependencies: Item
}

// function

const main = async (): Promise<void> => {

  const source = './package.json'
  const pkg = await $read_<Package>(source)
  const listCmd: string[] = []

  if (pkg.dependencies)
    Object.keys(pkg.dependencies)
      .forEach(key => {
        const value = pkg.dependencies[key]
        if (!value.startsWith('^')) return
        listCmd.push(`npm i --legacy-peer-deps ${key}@latest`)
      })

  if (pkg.devDependencies)
    Object.keys(pkg.devDependencies)
      .forEach(key => {
        const value = pkg.devDependencies[key]
        if (!value.startsWith('^')) return
        listCmd.push(`npm i -D --legacy-peer-deps ${key}@latest`)
      })

  if (pkg.peerDependencies)
    Object.keys(pkg.peerDependencies)
      .forEach(key => {
        const value = pkg.peerDependencies[key]
        if (!value.startsWith('^')) return
        listCmd.push(`npm i ${key}@latest`)
      })

  await $exec_(listCmd)
}

// export
export default main