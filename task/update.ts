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

  const source: string = './package.json'
  const pkg: Package = (await $.read_(source)) as Package
  const listCmd: string[] = []

  Object.keys(pkg.dependencies)
    .forEach(key => {
      const value = pkg.dependencies[key]
      if (!value.startsWith('^')) return
      delete pkg.dependencies[key]
      listCmd.push(`npm i --legacy-peer-deps ${key}`)
    })

  Object.keys(pkg.devDependencies)
    .forEach(key => {
      const value = pkg.devDependencies[key]
      if (!value.startsWith('^')) return
      delete pkg.devDependencies[key]
      listCmd.push(`npm i --legacy-peer-deps --save-dev ${key}`)
    })

  await $.backup_(source)
  await $.write_(source, pkg)

  await $.exec_('') // cache

  await $.remove_('./node_modules')
  await $.exec_([
    'npm i --legacy-peer-deps',
    ...listCmd
  ])

  const value = await $.prompt_({
    type: 'confirm',
    message: "delete 'package.json.bak'?"
  })
  if (value === true)
    await $.remove_(`${source}.bak`)
}

// export
export default main_