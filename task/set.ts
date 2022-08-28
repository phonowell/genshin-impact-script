import $ from 'fire-keeper'

// function

const main = async () => {
  const version = await savePkg()
  if (!version) return

  await saveMd(version)
}

const saveMd = async (version: string) => {
  const listSource = ['./readme.md']

  for (const source of listSource) {
    // eslint-disable-next-line no-await-in-loop
    const content = await $.read<string>(source)
    const cont = content.replace(/\d+\.\d+\.\d+/g, version)
    // eslint-disable-next-line no-await-in-loop
    await $.write(source, cont)
  }
}

const savePkg = async () => {
  type Pkg = {
    version: string
  }

  const pkg = await $.read<Pkg>('./package.json')

  const version = await $.prompt({
    default: pkg.version,
    message: 'input version',
    type: 'text',
  })

  if (version.split('.').length !== 3) return ''
  pkg.version = version

  await $.write('./package.json', pkg)
  return version
}

// export
export default main
