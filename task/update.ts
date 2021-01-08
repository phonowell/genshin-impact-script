import $ from 'fire-keeper'

// interface

type Package = {
  dependencies: {
    [key: string]: string
  }
  devDependencies: {
    [key: string]: string
  }
}

// function

async function main_(): Promise<void> {

  const source = './package.json'
  const pkg: Package = (await $.read_(source)) as Package
  const listCmd: string[] = []

  Object.keys(pkg.dependencies)
    .forEach(key => {
      const value = pkg.dependencies[key]
      if (!value.startsWith('^')) return
      listCmd.push(`npm i --legacy-peer-deps ${key}@latest`)
    })

  Object.keys(pkg.devDependencies)
    .forEach(key => {
      const value = pkg.devDependencies[key]
      if (!value.startsWith('^')) return
      listCmd.push(`npm i -D --legacy-peer-deps ${key}@latest`)
    })

  await $.exec_(listCmd)
}

// export
export default main_
